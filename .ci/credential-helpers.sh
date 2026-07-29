#!/bin/bash -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

is_set() {
  ! [[ -z "${!1+x}" ]];
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

aws_env_to_aws_disk() {
    if [ "$#" -ne 1 ]; then
      _err "${FUNCNAME[0]}: error: expected exactly 1 command line argument"
      _err "usage: ${FUNCNAME[0]} <CONFIG_DIR>"
      return 1
    fi
    require_env AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
    mkdir -p $1
    export AWS_CONFIG_FILE=$1/config
    printf "[default]\naws_access_key_id=$AWS_ACCESS_KEY_ID\naws_secret_access_key=$AWS_SECRET_ACCESS_KEY\naws_session_token=$AWS_SESSION_TOKEN\n" > $AWS_CONFIG_FILE
}

aws_env_to_minio_disk() {
    if [ "$#" -ne 1 ]; then
      _err "${FUNCNAME[0]}: error: expected exactly 1 command line argument"
      _err "usage: ${FUNCNAME[0]} <CONFIG_DIR>"
      return 1
    fi
    require_env AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_ENDPOINT_URL_S3
    export MC_CONFIG_DIR=$1
cat <<EOF >$1/config.json
{
	"version": "10",
	"aliases": {
		"s3": {
			"url": "$AWS_ENDPOINT_URL_S3",
			"accessKey": "$AWS_ACCESS_KEY_ID",
			"secretKey": "$AWS_SECRET_ACCESS_KEY",
            "sessionToken": "$AWS_SESSION_TOKEN",
			"api": "s3v4",
			"path": "auto"
		}
	}
}
EOF
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}

clear_aws_env_credentials() {
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}
