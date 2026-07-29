#!/bin/bash -e

## Helpers
. utilities.sh

require_env \
 CACHE_ONLY \
 PYTHON_MIRROR \
 PYTHON_PATH \
 PYTHON_VERSION \
 S3_ENDPOINT \
 SPACK_CORE_ROOT

sys_arch=$(arch)
if [[ $sys_arch == "aarch64" ]]; then
  spack_target=aarch64
elif [[ $sys_arch == "x86_64" ]]; then
  spack_target=x86_64_v3
elif [[ $sys_arch == "ppc64le" ]]; then
  spack_target=ppc64le
else
  _err "ERROR: Cannot process system architecture"
  exit 1
fi

. /etc/os-release
cmd . $SPACK_CORE_ROOT/share/spack/setup-env.sh
if [[ $ID == "rocky" ]] ; then
  source scl_source enable gcc-toolset-13
fi
cmd spack -e . compiler find
cmd spack -e . config add packages:all:require:[target=$spack_target]
cmd spack -e . add python@$PYTHON_VERSION +bz2+crypt+ctypes+dbm~debug+libxml2+lzma+optimizations+pic+pyexpat+pythoncmd+readline+shared+sqlite3+ssl+tkinter+uuid+zlib

cmd export AWS_CONFIG_FILE=/run/secrets/AWS_CONFIG_FILE
cmd export AWS_ENDPOINT_URL_S3=$S3_ENDPOINT

if ! is_true $CACHE_ONLY ; then

cmd export SPACK_GNUPGHOME=/tmp/spack-gnupg

multi_cmd "$(cat <<EOF

## Build from source + push to cache (use padding to enable flexibility in installation)
spack config add 'config:install_tree:padded_length:256'
spack gpg trust -y /run/secrets/SIGNING_KEY
spack gpg list | grep $SPACK_GNUPGHOME
spack mirror add remote --signed --autopush s3://$PYTHON_MIRROR
spack env activate -d .
spack concretize -f | tee concretize.log
spack config add "config:db_lock_timeout:120"
spack config add "config:connect_timeout:60"
spack install -j48 -p4 || spack install -j48 -p4
spack env deactivate

## Update buildcache index
spack buildcache update-index --keys remote

## Cleanup
rm -rf $SPACK_GNUPGHOME
spack mirror rm remote
spack config remove "config:install_tree:padded_length"

EOF
)"

fi # end cache-only logic


multi_cmd "$(cat <<EOF

## Install from cache into final location
spack mirror add --scope site remote s3://$PYTHON_MIRROR
spack buildcache keys -it -y
spack config add "config:install_tree:root:$PYTHON_PATH/pkgs"
spack config add "config:install_tree:projections:all:'{name}-{version}'"
spack config add "config:db_lock_timeout:120"
spack config add "config:connect_timeout:60"
spack -e . install -j8 -p8 --cache-only

## Install pip
spack load python
which python | grep $PYTHON_VERSION
wget -q https://bootstrap.pypa.io/get-pip.py
python get-pip.py
which pip | grep $PYTHON_VERSION

## Cleanup
rm -rf .spack-env

EOF
)"

# gettext_lib=$(spack location -i gettext)/lib
# if [[ ! -d $gettext_lib ]] ; then
#   _err error: gettext_lib var has unexpected value: $gettext_lib
#   exit 1
# fi

# python_lib=$(spack location -i python)/lib
# if [[ ! -d $python_lib ]] ; then
#   _err error: python_lib var has unexpected value: $python_lib
#   exit 1
# fi

# ln -s ${gettext_lib}/libintl.so ${python_lib}/libintl.so
