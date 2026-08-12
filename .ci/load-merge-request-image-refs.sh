#!/bin/bash -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

is_set() {
  ! [[ -z "${!1+x}" ]];
}

cmd() {
  echo -e "${GREEN}+ $@ ${NC}"
  eval $@
}

msg() {
  echo -e "${GREEN}+ $@ ${NC}"
}

_err() {
  echo -e "${RED}$@${NC}"
}

require_env() {
  msgs=()
  for vv in "$@" ; do
    if ! is_set $vv ; then
      msgs+=("error: required environment variable is not set: $vv")
    fi
  done

  for msg in "${msgs[@]}" ; do
    _err $msg
  done

  if [[ ${#msgs[@]} -gt 0 ]]; then
    exit 1
  fi
}

is_true() {
  if [[ $1 == "true" ]]; then
    return 0
  fi
  return 1
}

is_false() {
  ! is_true $1
}


require_env \
 CI_MERGE_REQUEST_IID \
 S3_BUCKET \
 S3_ENDPOINT

iid=$CI_MERGE_REQUEST_IID

cmd export AWS_ENDPOINT_URL_S3=$S3_ENDPOINT

if [[ "$(arch)" == "ppc64le" ]]; then
  cmd mc cp --recursive s3/${S3_BUCKET}/mr/${iid}/manifests/ manifests && found=true || found=false
else
  cmd aws s3 cp --recursive s3://${S3_BUCKET}/mr/${iid}/manifests/ manifests && found=true || found=false
fi

if is_false $found; then
  msg No image manifests found for MR $iid
  exit 0
fi

for ff in $(ls manifests); do
  cmd export $ff=$(cat manifests/${ff})
done