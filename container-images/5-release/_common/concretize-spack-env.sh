#!/bin/bash -e

. /etc/e4s/utilities.sh

require_env \
 SPACK_CORE_ROOT \
 SPACK_PACKAGES_ROOT \
 SPACK_MIRROR \
 S3_ENDPOINT \
 FORCE_CACHED_LOCKFILE

cur_dir=$(pwd)

export spack_refs=$(mktemp)
git -C $SPACK_CORE_ROOT rev-parse HEAD >> $spack_refs
git -C $SPACK_PACKAGES_ROOT rev-parse HEAD >> $spack_refs

cmd sha256sum $spack_refs
cmd sha256sum spack.yaml

if [[ "$cur_dir" == *"rocm"* || "$cur_dir" == *"oneapi"* || "$cur_dir" == *"cpu"* ]]; then
  cmd sha256sum $cur_dir/../_config/packages.yaml
  hash=$(cat $spack_refs $cur_dir/../_config/packages.yaml $cur_dir/spack.yaml | sha256sum | cut -d' ' -f1)
elif [[ "$cur_dir" == *"cuda"* ]]; then
  cmd sha256sum $cur_dir/../_config/packages.yaml
  cmd sha256sum $cur_dir/../../_config/packages.yaml
  hash=$(cat $spack_refs $cur_dir/../_config/packages.yaml $cur_dir/../../_config/packages.yaml $cur_dir/spack.yaml | sha256sum | cut -d' ' -f1)
else
  hash=$(cat $spack_refs $cur_dir/spack.yaml | sha256sum | cut -d' ' -f1)
fi

# cached_lockfile=${SPACK_MIRROR}/cached_lockfiles/${hash}
# found_lock=false
# cmd aws s3 cp --no-sign-request --endpoint-url=$S3_ENDPOINT $cached_lockfile spack.lock && found_lock=true

cached_lockfile=${SPACK_MIRROR}/cached_lockfiles/${hash}
found_lock=false
if [[ "$(arch)" == "ppc64le" ]]; then
  export MC_HOST_s3=$S3_ENDPOINT
  cached_lockfile="s3/${SPACK_MIRROR#s3://}/cached_lockfiles/${hash}"
  cmd mc cp $cached_lockfile $1/spack.lock && found_lock=true
else
  cmd aws s3 cp --no-sign-request --endpoint-url=$S3_ENDPOINT $cached_lockfile spack.lock && found_lock=true
fi

if is_true $found_lock; then
  echo Using cached lockfile: $cached_lockfile
  exit 0
else
  if is_true $FORCE_CACHED_LOCKFILE; then
    echo Failed to find cached lockfile when FORCE_CACHED_LOCKFILE is true: $cached_lockfile
    exit 1
  fi
fi

echo No cached lockfile found, proceeding with concretization...
. $SPACK_CORE_ROOT/share/spack/setup-env.sh
jn=$(( $(nproc) < 24 ? $(nproc) : 24))
spack -e . concretize -f -j${jn} | tee concretize.log
