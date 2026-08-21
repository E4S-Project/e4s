#!/bin/bash -e

. ../../../image-refs.env
. ../../../vars.env
. ../_common/vars.env

name=ubuntu26.04-runner-aarch64-gcc-13.4
output_image="${REGISTRY:-esw123}/${name}:${BUILD_TAG:-$(date +%s)}"

python_mirror=cache.e4s.io/runners-2026.06/python-pad256
python_s3_endpoint_url=https://s3.us-east.cloud-object-storage.appdomain.cloud
python_path=/opt/python
python_version=3.12.13
spack_core_checkout=v1.2.0
spack_core_repo=https://github.com/spack/spack
spack_core_root=/spack
spack_packages_checkout=v2026.06.0
spack_packages_repo=https://github.com/spack/spack-packages
spack_packages_root=/spack-packages
tools_mirror=cache.e4s.io/runners-2026.06/tools-pad256
tools_path=/opt/tools

common_scripts=$(realpath ../../_common)
. $common_scripts/utilities.sh
. $common_scripts/build-argparse.sh

check_usage_no_pos_args $@

if ! is_true $cache_only ; then
  [[ -f secrets.env ]] && . $(cat secrets.env) >/dev/null 2>&1
  require_env \
    AWS_CONFIG_FILE_PATH \
    SIGNING_KEY_PATH
  build_secrets="\
    --secret id=AWS_CONFIG_FILE,src=$AWS_CONFIG_FILE_PATH \
    --secret id=SIGNING_KEY,src=$SIGNING_KEY_PATH"
else
  build_secrets=""
fi

if is_set SAVE_OUTPUT_REF; then
  echo $output_image > $SAVE_OUTPUT_REF
fi

cmd docker build\
 -t "${output_image}" \
 --build-arg PYTHON_MIRROR=$python_mirror \
 --build-arg PYTHON_PATH=$python_path \
 --build-arg PYTHON_S3_ENDPOINT_URL=$python_s3_endpoint_url \
 --build-arg PYTHON_VERSION=$python_version \
 --build-arg SPACK_CORE_CHECKOUT=$spack_core_checkout \
 --build-arg SPACK_CORE_REPO=$spack_core_repo \
 --build-arg SPACK_CORE_ROOT=$spack_core_root \
 --build-arg SPACK_PACKAGES_CHECKOUT=$spack_packages_checkout \
 --build-arg SPACK_PACKAGES_REPO=$spack_packages_repo \
 --build-arg SPACK_PACKAGES_ROOT=$spack_packages_root \
 --build-arg CACHE_ONLY=$cache_only \
 $build_secrets --progress=plain \
 -f ./Dockerfile \
 --build-context container-common=../../_common \
 --build-context runner-common=../_common \
 .
