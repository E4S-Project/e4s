#!/bin/bash -e

. ../../../image-refs.env
. ../../_common/utilities.sh

require_env REGISTRY

name=e4s-cuda-base-x86_64
version=v12.9.1
source_image=${RUNNER_SOURCE_IMAGE:-$UBUNTU_X86_64_RUNNER_IMAGE}
output_image="${REGISTRY}/${name}:${BUILD_TAG:-$version-$(date +%s)}"
downloads=${DOWNLOAD_PATH:-$(realpath ./downloads)}

mkdir -p $downloads

runfile_12_9=cuda_12.9.1_575.57.08_linux.run
cmd wget -c -q https://developer.download.nvidia.com/compute/cuda/12.9.1/local_installers/$runfile_12_9 -P $downloads

# https://developer.nvidia.com/cudnn-9-8-0-download-archive?target_os=Linux&target_arch=x86_64&Distribution=Agnostic&cuda_version=12
cudnn_tarball=cudnn-linux-x86_64-9.8.0.87_cuda12-archive.tar.xz
cmd wget -c -q https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/$cudnn_tarball -P $downloads

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
 -f ./Dockerfile .
