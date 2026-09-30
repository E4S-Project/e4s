#!/bin/bash -e

. ../../../image-refs.env
. ../../../vars.env
. ../_common/vars.env

common_scripts=$(realpath ../../_common)
. $common_scripts/utilities.sh
. $common_scripts/build-argparse.sh

set_valid_targets cpu cuda
check_usage $@

require_env \
 REGISTRY \
 s3_bucket \
 s3_endpoint \
 spack_core_checkout \
 spack_core_repo \
 spack_core_root \
 spack_packages_checkout \
 spack_packages_repo \
 spack_packages_root \
 mpich_mirror \
 mpich_path \
 mpich_version

name=e4s-mpi-$target-aarch64
timestamp=$(date +%s)

builder_source_image=${RUNNER_SOURCE_IMAGE:-$UBUNTU_AARCH64_RUNNER_IMAGE}
cuda_source_image=${CUDA_SOURCE_IMAGE:-$UBUNTU_AARCH64_CUDA_IMAGE}
cpu_source_image=$builder_source_image

final_target=mpich-final
case $target in
  "cuda")
    final_image_base=$cuda_source_image
    if ! docker image inspect $final_image_base >/dev/null 2>&1; then docker pull $final_image_base; fi
    cuda_version=$(docker inspect --format '{{ index .Config.Labels "E4S_CUDA_VERSION" }}' $final_image_base)
    if [[ -z "$cuda_version" ]]; then
      _err error: image is missing expected label E4S_CUDA_VERSION
      _err error: $final_image_base does not have the expected label
    fi
    tag=v$mpich_version-$cuda_version-$timestamp
    ;;
  "cpu")
    final_image_base=$cpu_source_image
    tag=v$mpich_version-$timestamp
    ;;
esac

output_image="${REGISTRY}/${name}:${tag}"

[[ -f secrets.env ]] && . $(cat secrets.env) >/dev/null 2>&1
require_env \
  AWS_CONFIG_FILE \
  SIGNING_KEY

if is_set SAVE_OUTPUT_REF; then
  echo $output_image > $SAVE_OUTPUT_REF
fi

cmd docker build \
 -t "${output_image}" \
 --build-arg S3_ENDPOINT=$s3_endpoint \
 --build-arg SPACK_CORE_CHECKOUT=$spack_core_checkout \
 --build-arg SPACK_CORE_REPO=$spack_core_repo \
 --build-arg SPACK_CORE_ROOT=$spack_core_root \
 --build-arg SPACK_PACKAGES_CHECKOUT=$spack_packages_checkout \
 --build-arg SPACK_PACKAGES_REPO=$spack_packages_repo \
 --build-arg SPACK_PACKAGES_ROOT=$spack_packages_root \
 --build-arg MPICH_MIRROR=$mpich_mirror \
 --build-arg MPICH_PATH=$mpich_path \
 --build-arg MPICH_VERSION=$mpich_version \
 --build-arg BUILDER_IMAGE=$builder_source_image \
 --build-arg FINAL_IMAGE_BASE=$final_image_base \
 --build-arg CACHE_ONLY=$cache_only \
 --secret id=AWS_CONFIG_FILE,src=$AWS_CONFIG_FILE \
 --secret id=SIGNING_KEY,src=$SIGNING_KEY \
 --progress=plain \
 --progress=plain \
 --target $final_target \
 -f ./Dockerfile \
 --build-context container-common=../../_common \
 --build-context mpi-common=../_common \
 .
