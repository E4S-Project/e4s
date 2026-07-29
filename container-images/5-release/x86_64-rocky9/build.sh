#!/bin/bash -e

. ../../../image-refs.env
. ../../../vars.env

common_scripts=$(realpath ../../_common)
. $common_scripts/utilities.sh
. $common_scripts/build-argparse.sh

set_valid_targets \
 cpu \
 cuda-90 \
 cuda-120
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

[[ -f secrets.env ]] && . $(cat secrets.env) >/dev/null 2>&1
require_env \
  AWS_CONFIG_FILE

pretty_date=$(printf '%(%Y.%m.%d)T' -1)
timestamp=$(date +%s)
common_tag=${BUILD_TAG:-26.06.$timestamp}
arch_tag=x86_64

generic_base_image=${RUNNER_SOURCE_IMAGE:-$ROCKY_X86_64_RUNNER_IMAGE}
cuda_base_image=${CUDA_MPI_SOURCE_IMAGE:-$ROCKY_X86_64_CUDA_MPI_IMAGE}
cpu_base_image=${CPU_MPI_SOURCE_IMAGE:-$ROCKY_X86_64_CPU_MPI_IMAGE}

case $target in
  "cuda"*)
    runtime="cuda"
    arch=$(echo $target | cut -d- -f2)
    name=e4s-${runtime}-rocky-${arch_tag}
    tag=${runtime}${arch}-${common_tag}
    final_base_image=$cuda_base_image
    ;;
  "cpu")
    runtime="cpu"
    arch=$(echo $target | cut -d- -f2)
    name=e4s-${runtime}-rocky-${arch_tag}
    tag=${common_tag}
    final_base_image=$cpu_base_image
    ;;
esac

download_dir=./assets/downloads # ${DOWNLOAD_PATH:-./assets/downloads}
lockdir=$download_dir/.lock
cleanup() {
  rm -rf $lockdir
}
trap cleanup EXIT INT TERM
py_tarball=blank
mkdir -p $download_dir
if [[ $target =~ "cuda" ]]; then
  if mkdir $lockdir; then
    py_tarball=ml-1-20260527-1838-rocky9-py312-cu130.tgz
    cmd wget -q -c -P $download_dir https://cache.e4s.io/$py_tarball
    rm -rf $lockdir
  fi
elif [[ $target =~ "cpu" ]]; then
  if mkdir $lockdir; then
    py_tarball=ml-1-20260607-1244-rocky9-x86_64-py312-cpu.tgz
    cmd wget -q -c -P $download_dir https://cache.e4s.io/$py_tarball
    rm -rf $lockdir
  fi
fi

output_image="${REGISTRY}/${name}:${tag}"

if is_set SAVE_OUTPUT_REF; then
  echo $output_image > $SAVE_OUTPUT_REF
fi

cmd docker build \
 --build-arg IMAGE_TARGET="$target" \
 --build-arg FINAL_BASE_IMAGE="$final_base_image" \
 --build-arg CPU_BASE_IMAGE="$cpu_base_image" \
 --build-arg CUDA_BASE_IMAGE="$cuda_base_image" \
 --build-arg GENERIC_BASE_IMAGE="$generic_base_image" \
 --build-arg S3_ENDPOINT=$s3_endpoint \
 --build-arg SPACK_CORE_CHECKOUT=$spack_core_checkout \
 --build-arg SPACK_CORE_REPO=$spack_core_repo \
 --build-arg SPACK_CORE_ROOT=$spack_core_root \
 --build-arg SPACK_PACKAGES_CHECKOUT=$spack_packages_checkout \
 --build-arg SPACK_PACKAGES_REPO=$spack_packages_repo \
 --build-arg SPACK_PACKAGES_ROOT=$spack_packages_root \
 --build-arg SPACK_MIRROR=$spack_mirror \
 --build-arg PY_TARBALL=$py_tarball \
 --target final-$target \
 --build-context container-common=../../_common \
 --build-context release-common=../_common \
 --build-context rocky-common=../_common_rocky \
 --build-context spack-common=../../4-spack/_common \
 --build-context spack-env=../../../environments/$arch_tag \
 -t "${output_image}" \
 --secret id=AWS_CONFIG_FILE,src=$AWS_CONFIG_FILE \
 --progress=plain \
 -f Dockerfile \
 assets
