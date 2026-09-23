#!/bin/bash -e

export SIF_PREFETCH_PATH=~lpeyrala/e4s-images/ci
export SIF_PATH=${SIF_PREFETCH_PATH}/${SIF}
echo "-----------------"
echo SIF Prefetch Path: $SIF_PREFETCH_PATH
echo Test SIF: $SIF 
echo Test target: $TEST_TARGET
echo "-----------------"

if [[ -f $SIF_PATH ]]; then
  echo Found SIF: $SIF_PATH
else
  echo error: SIF not found in prefetch location: $SIF_PATH
  echo skipping SIF test...
  exit -1
fi

detect_backend() {
  local name
  name=$(basename "$1" | tr '[:upper:]' '[:lower:]')

  if [[ "$name" == *cuda* || "$name" == *nvidia* ]]; then
    echo cuda
  elif [[ "$name" == *rocm* || "$name" == *hip* || "$name" == *amdgpu* ]]; then
    echo rocm
  elif [[ "$name" == *intel* || "$name" == *oneapi* ]]; then
    echo oneapi
  else
    echo cpu
  fi
}

BACKEND=$(detect_backend "$SIF_PATH")
echo "Detected backend: $BACKEND"

case "$BACKEND" in
  cuda)
    SINGULARITY_FLAGS="--nv"
    ;;
  rocm)
    SINGULARITY_FLAGS="--rocm"
    ;;
  oneapi)
    #TBD
    SINGULARITY_FLAGS=""
    ;;  
  cpu)
    SINGULARITY_FLAGS=""
    ;;
  *)
    echo "error: unrecognized backend '$BACKEND' for SIF: $SIF_PATH"
    exit 1
    ;;
esac

SINGULARITY_FLAGS="--writable-tmpfs --cleanenv ${SINGULARITY_FLAGS}"

echo "Singularity flags: $SINGULARITY_FLAGS"
echo "-----------------"

export SIF_BACKEND=$BACKEND
export SINGULARITY_FLAGS
export BASH_FLAGS="-lic"

#Pass these through to singularity since we've turned off the global environment
export SINGULARITYENV_TEST_TARGET="$TEST_TARGET"
export SINGULARITYENV_ARTIFACTS="$ARTIFACTS"
export SINGULARITYENV_AWS_CONFIG_FILE="$AWS_CONFIG_FILE"
export SINGULARITYENV_AWS_ENDPOINT_URL_S3="$AWS_ENDPOINT_URL_S3"

set -x
SPACK_COUNT=$(singularity exec $SINGULARITY_FLAGS "$SIF_PATH" bash $BASH_FLAGS 'spack find -x | grep -v "^--" | grep -c "^[a-zA-Z0-9]"' || true)
set +x

if [ "$SPACK_COUNT" -lt 5 ]; then
  echo "ERROR: Spack found fewer than 5 packages ($SPACK_COUNT found):"
  singularity exec $SINGULARITY_FLAGS "$SIF_PATH" bash $BASH_FLAGS 'spack find -x'
  exit 1
fi

(set -x; singularity exec $SINGULARITY_FLAGS "$SIF_PATH" bash $BASH_FLAGS ./run-tests.sh)

