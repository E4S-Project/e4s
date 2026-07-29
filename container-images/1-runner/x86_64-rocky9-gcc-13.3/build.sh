#!/bin/bash -e

. ../../../image-refs.env
. ../../../vars.env
. ../vars.env

common_scripts=$(realpath ../../_common)
. $common_scripts/utilities.sh
. $common_scripts/build-argparse.sh

require_env \
 REGISTRY \
 s3_bucket \
 s3_endpoint \
 python_mirror \
 python_path \
 python_version \
 spack_core_checkout \
 spack_core_repo \
 spack_core_root \
 spack_packages_checkout \
 spack_packages_repo \
 spack_packages_root \
 tools_mirror \
 tools_path

name=rocky9-runner-x86_64-gcc-13.3
output_image="${REGISTRY}/${name}:${BUILD_TAG:-$(date +%s)}"

check_usage_no_pos_args $@

[[ -f secrets.env ]] && . $(cat secrets.env) >/dev/null 2>&1
require_env \
  AWS_CONFIG_FILE \
  SIGNING_KEY

if is_set SAVE_OUTPUT_REF; then
  echo $output_image > $SAVE_OUTPUT_REF
fi

cmd docker build \
 -t "${output_image}" \
 --build-arg PYTHON_MIRROR=$python_mirror \
 --build-arg PYTHON_PATH=$python_path \
 --build-arg PYTHON_VERSION=$python_version \
 --build-arg S3_ENDPOINT=$s3_endpoint \
 --build-arg SPACK_CORE_CHECKOUT=$spack_core_checkout \
 --build-arg SPACK_CORE_REPO=$spack_core_repo \
 --build-arg SPACK_CORE_ROOT=$spack_core_root \
 --build-arg SPACK_PACKAGES_CHECKOUT=$spack_packages_checkout \
 --build-arg SPACK_PACKAGES_REPO=$spack_packages_repo \
 --build-arg SPACK_PACKAGES_ROOT=$spack_packages_root \
 --build-arg TOOLS_MIRROR=$tools_mirror \
 --build-arg TOOLS_PATH=$tools_path \
 --build-arg CACHE_ONLY=$cache_only \
 --secret id=AWS_CONFIG_FILE,src=$AWS_CONFIG_FILE \
 --secret id=SIGNING_KEY,src=$SIGNING_KEY \
 --progress=plain \
 -f ./Dockerfile \
 --build-context container-common=../../_common \
 --build-context runner-common=../_common \
 .
