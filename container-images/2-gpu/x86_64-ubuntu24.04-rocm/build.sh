#!/bin/bash -e

. ../../../image-refs.env
. ../../_common/utilities.sh

require_env REGISTRY

name=e4s-rocm-base-x86_64
version=v7.2.3
source_image=${RUNNER_SOURCE_IMAGE:-$UBUNTU_X86_64_RUNNER_IMAGE}
output_image="${REGISTRY}/${name}:${BUILD_TAG:-$version-$(date +%s)}"

if is_set SAVE_OUTPUT_REF; then
  echo $output_image > $SAVE_OUTPUT_REF
fi

cmd docker build \
 -t "${output_image}" \
 --build-arg SOURCE_IMAGE=$source_image \
 --progress=plain \
 -f ./Dockerfile .
