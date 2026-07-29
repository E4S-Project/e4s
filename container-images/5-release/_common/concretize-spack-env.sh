#!/bin/bash -e

. /etc/e4s/utilities.sh

require_env \
 SPACK_CORE_ROOT \
 SPACK_PACKAGES_ROOT \
 SPACK_MIRROR \
 S3_ENDPOINT

cur_dir=$(pwd)

export spack_refs=$(mktemp)
git -C $SPACK_CORE_ROOT rev-parse HEAD >> $spack_refs
git -C $SPACK_PACKAGES_ROOT rev-parse HEAD >> $spack_refs

cmd sha256sum $spack_refs
cmd sha256sum spack.yaml

if [[ "" == *"rocm"* || "$cur_dir" == *"oneapi"* || "$cur_dir" == *"cpu"* ]]; then
  cmd sha256sum $cur_dir/../_config/packages.yaml
  hash=$(cat $spack_refs $cur_dir/../_config/packages.yaml $cur_dir/spack.yaml | sha256sum | cut -d' ' -f1)
elif [[ "$cur_dir" == *"cuda"* ]]; then
  cmd sha256sum $cur_dir/../_config/packages.yaml
  cmd sha256sum $cur_dir/../../_config/packages.yaml
  hash=$(cat $spack_refs $cur_dir/../_config/packages.yaml $cur_dir/../../_config/packages.yaml $cur_dir/spack.yaml | sha256sum | cut -d' ' -f1)
else
  hash=$(cat $spack_refs $cur_dir/spack.yaml | sha256sum | cut -d' ' -f1)
fi

cached_lockfile=${SPACK_MIRROR}/cached_lockfiles/${hash}

found_lock=false
cmd aws s3 cp --no-sign-request --endpoint-url=$S3_ENDPOINT $cached_lockfile spack.lock && found_lock=true
if is_true $found_lock; then
  echo Using cached lockfile: $cached_lockfile
  exit 0
fi

echo No cached lockfile found, proceeding with concretization...
. $SPACK_CORE_ROOT/share/spack/setup-env.sh
jn=$(( $(nproc) < 24 ? $(nproc) : 24))
spack -e . concretize -f -j${jn} | tee concretize.log
