#!/bin/bash -e

# Load helpers and variables
export CI_ROOT=$(realpath $(git rev-parse --show-toplevel))
. utilities.sh

usage() {
  echo "usage: $0 [--nopush] [--nopad] [--noclone]"
}

# argument parsing adapted from:
# StackOverflow user Robert Siemer April 20, 2015
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

set -o errexit -o pipefail -o noclobber -o nounset

getopt --test > /dev/null && true
if [[ $? -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

LONGOPTS=nopush,nopad,noclone,help
OPTIONS=h

PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@") || exit 2
eval set -- "$PARSED"

push_binaries=true
use_padding=true
clone_repos=true

while true; do
    case "$1" in
        --nopush)
            push_binaries=false
            shift
            ;;
        --nopad)
            use_padding=false
            shift
            ;;
        --noclone)
            clone_repos=false
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [[ $# -ne 1 ]]; then
    usage
    exit 1
fi

set +o noclobber

if is_true $push_binaries; then
  require_env AWS_CONFIG_FILE SIGNING_KEY
fi

if ! is_set ARTIFACTS; then
  echo warning: environment variable is not set: ARTIFACTS
  echo disabling automatic saving of artifacts
else
  mkdir -p $ARTIFACTS
fi

jn=${PARALLELISM_X86_64:-128}
pn=${PACKAGE_PARALLELISM_X86_64:-8}
padding=256

if [[ "$(arch)" == "aarch64" ]]; then
  jn=${TOTAL_PARALLELISM_AARCH64:-48}
  pn=${PACKAGE_PARALLELISM_AARCH64:-4}
elif [[ "$(arch)" == "ppc64le" ]]; then
  jn=${TOTAL_PARALLELISM_PPC64LE:-48}
  pn=${PACKAGE_PARALELLISM_PPC64LE:-4}
  padding=128
fi

spack_core_checkout=v1.2.1
spack_core_repo=https://github.com/spack/spack
spack_packages_checkout=eb2a393c5a41c6a9ae576d9693fe2b23e8fc5a6d
spack_packages_repo=https://github.com/spack/spack-packages

shared_dir=/e4s-shared
build_dir=$shared_dir/${spack_core_checkout:0:10}-${spack_packages_checkout:0:10}
spack_core_root=$build_dir/spack
spack_packages_root=$build_dir/spack-packages

s3_bucket=${S3_BUCKET:-cache.e4s.io}
s3_endpoint=${S3_ENDPOINT:-https://uo-spack-mirror.e4s.io:9000}
s3_prefix=e4s-builds
spack_mirror=s3://${S3_BUCKET}/$s3_prefix

lockfile=$build_dir/.lock
mkdir -p $build_dir
(
  flock 200

  if [[ ! -d $spack_core_root ]]; then
    cmd git clone --quiet $spack_core_repo $spack_core_root
    cmd git -C $spack_core_root checkout --quiet $spack_core_checkout
  fi

  if [[ ! -d $spack_packages_root ]]; then
    cmd git clone --quiet $spack_packages_repo $spack_packages_root
    cmd git -C $spack_packages_root checkout --quiet $spack_packages_checkout
  fi
) 200>$lockfile

if [[ ! -d $spack_packages_root || ! -d $spack_core_root ]]; then
  _err "error: found incomplete existing build_dir: $build_dir"
  _err "error: missing expected paths: $spack_packages_root, $spack_core_root"
  exit 1
fi

cmd . $spack_core_root/share/spack/setup-env.sh

if is_true $use_padding; then
  cmd spack config add "config:install_tree:padded_length:$padding"
else
  cmd spack config add "config:install_tree:padded_length:0"
fi

cmd spack repo set --destination $spack_packages_root builtin

cmd spack config add "config:db_lock_timeout:480"
cmd spack config add "config:connect_timeout:60"

cmd export AWS_ENDPOINT_URL_S3=$s3_endpoint
cmd spack mirror add --autopush --signed e4s $spack_mirror

cmd spack buildcache keys -it -y
cmd spack gpg trust -y $SIGNING_KEY

cmd 'spack find -l > spack-find.log'
cmd save spack-find.log

. /etc/os-release
if [[ $ID =~ "rocky" ]]; then
  pushd $1
  f1=../../_config/packages.yaml
  f2=../_config/packages.yaml
  if [[ -f $f1 ]]; then
    pkgf=$f1
  else
    pkgf=$f2
  fi
  sed -i 's/gcc@13.3.0/gcc@13.3.1/g' $pkgf
  sed -i 's@/usr/bin/gcc@/opt/rh/gcc-toolset-13/root/usr/bin/gcc@g' $pkgf
  sed -i 's@/usr/bin/g++@/opt/rh/gcc-toolset-13/root/usr/bin/g++@g' $pkgf
  sed -i 's@/usr/bin/gfortran@/opt/rh/gcc-toolset-13/root/usr/bin/gfortran@g' $pkgf
  sed -i -e '0,/prefix: \/usr/ s@prefix: /usr@prefix: /opt/rh/gcc-toolset-13/root/usr@' $pkgf

  cmd spack -e . remove paraview +qt || true
  popd
fi

cmd spack env activate -d $1

cmd save $1/spack.yaml

export spack_refs=/tmp/spack-refs.txt
git -C $spack_core_root rev-parse HEAD >> $spack_refs
git -C $spack_packages_root rev-parse HEAD >> $spack_refs
cmd 'spack config blame packages > blame-packages.log'
cmd save blame-packages.log

cmd sha256sum $spack_refs
cmd sha256sum $1/spack.yaml

if [[ "$1" == *"rocm"* || "$1" == *"oneapi"* || "$1" == "cpu" ]]; then
  cmd sha256sum $1/../_config/packages.yaml
  hash=$(cat $spack_refs $1/../_config/packages.yaml $1/spack.yaml | sha256sum | cut -d' ' -f1)
elif [[ "$1" == *"cuda"* ]]; then
  cmd sha256sum $1/../_config/packages.yaml
  cmd sha256sum $1/../../_config/packages.yaml
  hash=$(cat $spack_refs $1/../_config/packages.yaml $1/../../_config/packages.yaml $1/spack.yaml | sha256sum | cut -d' ' -f1)
else
  hash=$(cat $spack_refs $1/spack.yaml | sha256sum | cut -d' ' -f1)
fi

cached_lockfile=s3://${s3_bucket}/${s3_prefix}/cached_lockfiles/$hash
found_lock=false
if [[ "$(arch)" == "ppc64le" ]]; then
  cached_lockfile=s3/${s3_bucket}/${s3_prefix}/cached_lockfiles/$hash
  cmd mc cp $cached_lockfile $1/spack.lock && found_lock=true
else
  cmd aws s3 cp $cached_lockfile $1/spack.lock && found_lock=true
fi

if is_true $found_lock; then
  msg Using cached lockfile: $cached_lockfile
else
  msg No cached lockfile found, proceeding with concretization...
  cmd 'spack concretize -j$jn 2>&1 | tee concretize.log'
  if [[ "$(arch)" == "ppc64le" ]]; then
    cmd mc cp $1/spack.lock ${cached_lockfile}
  else
    cmd aws s3 cp $1/spack.lock ${cached_lockfile}
  fi
  cmd save concretize.log
fi

cmd save $1/spack.lock

cmd spack install -j$jn -p$jn --cache-only --include-build-deps || true
set +e
cmd spack install -j$jn -p$pn
ret=$?

cmd spack buildcache push -j$jn --signed --with-build-dependencies e4s

if [[ $ret -ne 0 ]]; then
  _err spack install failed
  exit $ret
fi

