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
fi
