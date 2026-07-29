#!/bin/bash -e

## Helpers
. utilities.sh

require_env \
 CACHE_ONLY \
 S3_ENDPOINT \
 SPACK_CORE_ROOT \
 TOOLS_MIRROR \
 TOOLS_PATH

cmd . $SPACK_CORE_ROOT/share/spack/setup-env.sh

cmd export AWS_CONFIG_FILE=/run/secrets/AWS_CONFIG_FILE
cmd export AWS_ENDPOINT_URL_S3=$S3_ENDPOINT

if ! is_true $CACHE_ONLY ; then

cmd export SPACK_GNUPGHOME=/tmp/spack-gnupg

multi_cmd "$(cat <<EOF

## Build from source + push to cache (use padding to enable flexibility in installation)
spack config add 'config:install_tree:padded_length:256'
spack gpg trust -y /run/secrets/SIGNING_KEY
spack gpg list | grep $SPACK_GNUPGHOME
spack mirror add --autopush --signed remote s3://$TOOLS_MIRROR
spack env activate -d .
spack concretize -f | tee concretize.log
spack env depfile -o Makefile
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
spack mirror add --scope site remote s3://$TOOLS_MIRROR
spack buildcache keys -it -y
spack config add "config:install_tree:root:$TOOLS_PATH/pkgs"
spack config add "config:install_tree:projections:all:'{name}-{version}'"
spack config add "config:db_lock_timeout:120"
spack config add "config:connect_timeout:60"
spack -e . install -j8 -p8 --cache-only
spack -e . config add "view: $TOOLS_PATH/view"
spack -e . install --cache-only

## Cleanup
rm -rf .spack-env

EOF
)"
