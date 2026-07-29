#!/bin/bash -e

. ../../../image-refs.env

require_env REGISTRY

name=e4s-cuda-base-ubuntu26.04-aarch64
version=v12.9.1
source_image=${RUNNER_SOURCE_IMAGE:-ecpe4s/ubuntu26.04-runner-aarch64-gcc-13.4:1783203976}
output_image="${REGISTRY}/${name}:${BUILD_TAG:-$version-$(date +%s)}"
downloads=${DOWNLOAD_PATH:-$(realpath ./downloads)}

mkdir -p $downloads

. ../../_common/utilities.sh

runfile_12_9=cuda_12.9.1_575.57.08_linux_sbsa.run
cmd wget -c -q https://developer.download.nvidia.com/compute/cuda/12.9.1/local_installers/$runfile_12_9 -P $downloads

# https://developer.nvidia.com/cudnn-9-10-2-download-archive?target_os=Linux&target_arch=arm64-sbsa&Compilation=Native&Distribution=Agnostic&cuda_version=12
cudnn_tarball=cudnn-linux-sbsa-9.10.2.21_cuda12-archive.tar.xz
cmd wget -c -q https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-9.10.2.21_cuda12-archive.tar.xz  -P $downloads

if is_set SAVE_OUTPUT_REF; then
  echo $output_image > $SAVE_OUTPUT_REF
fi

cmd docker build \
 -t "${output_image}" \
 --build-arg RUNFILE_12_9=$runfile_12_9 \
 --build-arg CUDNN_TARBALL=$cudnn_tarball \
 --build-arg SOURCE_IMAGE=$source_image \
 --build-context downloads=$downloads \
 --progress=plain \
 -f ./Dockerfile \
 --build-context gpu-common=../_common \
 .
