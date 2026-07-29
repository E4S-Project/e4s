#!/bin/bash -e

. /etc/e4s/utilities.sh

require_env \
 S3_ENDPOINT \
 SPACK_CORE_ROOT

jn=$(( $(nproc) < 24 ? $(nproc) : 24))

cmd export AWS_CONFIG_FILE=/run/secrets/AWS_CONFIG_FILE
cmd export AWS_ENDPOINT_URL_S3=$S3_ENDPOINT

cmd . $SPACK_CORE_ROOT/share/spack/setup-env.sh
cmd spack env activate -d .
cmd spack mirror add E4S $SPACK_MIRROR
cmd spack buildcache keys -it -y
cmd spack install --cache-only -j$jn -p$jn \
 || cmd spack install --cache-only -j$jn -p$jn

