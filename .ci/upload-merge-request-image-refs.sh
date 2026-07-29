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

require_env \
 CI_MERGE_REQUEST_IID \
 IMAGE_LABEL \
 S3_BUCKET \
 S3_ENDPOINT \
 OUTPUT_IMAGE

iid=$CI_MERGE_REQUEST_IID

cmd export AWS_ENDPOINT_URL_S3=$S3_ENDPOINT

cmd touch $IMAGE_LABEL
cmd 'echo $OUTPUT_IMAGE > $IMAGE_LABEL'
cmd cat $IMAGE_LABEL

if [[ "$(arch)" == "ppc64le" ]]; then
  cmd mc cp $IMAGE_LABEL s3/${S3_BUCKET}/mr/${iid}/
else
  cmd aws s3 cp $IMAGE_LABEL s3://${S3_BUCKET}/mr/${iid}/
fi
