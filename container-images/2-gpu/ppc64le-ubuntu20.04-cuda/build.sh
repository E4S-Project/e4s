#!/bin/bash -e

. ../../../image-refs.env
. ../../_common/utilities.sh

require_env REGISTRY

name=e4s-cuda-base-ppc64le
version=11.2.2
source_image=${RUNNER_SOURCE_IMAGE:-$UBUNTU_PPC64LE_RUNNER_IMAGE}
output_image="${REGISTRY}/${name}:${BUILD_TAG:-$version-$(date +%s)}"
downloads=${DOWNLOAD_PATH:-$(realpath ./downloads)}

mkdir -p $downloads

artifacts=(
 "https://cache.e4s.io/gpu-packages/cuda_11.2.2_460.32.03_linux_ppc64le.run"
 "https://cache.e4s.io/gpu-packages/TensorRT-7.2.0.13.Ubuntu-18.04.ppc64le-gnu.cuda-11.0.cudnn8.0.tar.gz"
 "https://cache.e4s.io/gpu-packages/nccl_2.8.4-1+cuda11.2_ppc64le.txz"
 "https://cache.e4s.io/gpu-packages/cudnn-11.2-linux-ppc64le-v8.1.1.33.tgz"
)

for artifact in "${artifacts[@]}" ; do
  base=$(basename $artifact)
  dir=$(dirname $artifact)
  escaped=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''${base}'''))")
  cmd wget -c -q $dir/$escaped -P $downloads
done

if is_set SAVE_OUTPUT_REF; then
  echo $output_image > $SAVE_OUTPUT_REF
fi

cmd docker build \
 -t "${output_image}" \
 --build-arg SOURCE_IMAGE=$source_image \
 --build-context downloads=$downloads \
 --progress=plain \
 -f ./Dockerfile .
