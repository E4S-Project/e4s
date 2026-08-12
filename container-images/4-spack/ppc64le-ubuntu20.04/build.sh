#!/bin/bash -e

. ../../../image-refs.env
. ../../../vars.env 

common_scripts=$(realpath ../../_common)
. $common_scripts/utilities.sh
. $common_scripts/build-argparse.sh

set_valid_targets cpu cuda
check_usage $@

require_env \
 s3_bucket \
 s3_endpoint \
 spack_core_checkout \
 spack_core_repo \
 spack_core_root \
 spack_packages_checkout \
 spack_packages_repo \
 spack_packages_root \
 spack_mirror \
 REGISTRY

name=e4s-spack-$target-ppc64le
timestamp=$(date +%s)

builder_source_image=${RUNNER_SOURCE_IMAGE:-$UBUNTU_PPC64LE_RUNNER_IMAGE}

cuda_source_image=${CUDA_MPI_SOURCE_IMAGE:-$UBUNTU_PPC64LE_CUDA_MPI_IMAGE}
cuda_output_tag=$timestamp

cpu_source_image=${CPU_MPI_SOURCE_IMAGE:-$UBUNTU_PPC64LE_CPU_MPI_IMAGE}
cpu_output_tag=$timestamp

case $target in
  "cuda")
    final_image_base=$cuda_source_image
    final_target=cuda-final
    tag=$cuda_output_tag
    ;;
  "cpu")
    final_image_base=$cpu_source_image
    final_target=cpu-final
    tag=$cpu_output_tag
    ;;
esac

output_img="${REGISTRY}/${name}:${tag}"

if is_set SAVE_OUTPUT_REF; then
  echo $output_img > $SAVE_OUTPUT_REF
fi

cmd docker build \
 -t "${output_img}" \
 --build-arg S3_ENDPOINT=$s3_endpoint \
 --build-arg SPACK_CORE_CHECKOUT=$spack_core_checkout \
 --build-arg SPACK_CORE_REPO=$spack_core_repo \
 --build-arg SPACK_CORE_ROOT=$spack_core_root \
 --build-arg SPACK_PACKAGES_CHECKOUT=$spack_packages_checkout \
 --build-arg SPACK_PACKAGES_REPO=$spack_packages_repo \
 --build-arg SPACK_PACKAGES_ROOT=$spack_packages_root \
 --build-arg SPACK_MIRROR=$spack_mirror \
 --build-arg BUILDER_IMAGE=$builder_source_image \
 --build-arg FINAL_IMAGE_BASE=$final_image_base \
 --progress=plain \
 --target $final_target \
 --build-context container-common=../../_common \
 --build-context spack-common=../_common \
 --build-context spack_env=../../../environments/ppc64le \
 -f ./Dockerfile \
 .
