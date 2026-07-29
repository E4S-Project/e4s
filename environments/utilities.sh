#!/bin/bash -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

utilities_are_available() {
  return 0
}

msg() {
  echo -e "${GREEN}+ $@ ${NC}"
}

cmd() {
  echo -e "${GREEN}+ $@ ${NC}"
  eval $@
}

multi_cmd() {
  local line
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -z "${line//[[:space:]]/}" ]]; then
      continue
    fi
    echo -e "${GREEN}+ $line ${NC}"
    eval $line
  done < <(printf "%s" "$1")
}

is_set() {
  ! [[ -z "${!1+x}" ]];
}

is_empty() {
  [[ -z "${!1}" ]];
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

save() {
  if ! is_set ARTIFACTS ; then
    echo "ARTIFACTS is not set; will not save $@"
    return
  fi
  cmd cp -r $@ $ARTIFACTS/
}