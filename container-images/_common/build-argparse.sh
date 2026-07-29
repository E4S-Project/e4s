#!/bin/bash -e

if ! declare -F utilities_are_available >/dev/null 2>&1; then
  echo error: expected utility functions not found in environment
  exit 1
fi

valid_targets=""

set_valid_targets() {
  valid_targets="$@"
}

check_usage() {
  if is_empty valid_targets; then
    _err "error: check_usage: cannot check usage without valid_targets; valid_targets is empty"
    exit 1
  fi

  usage() {
      export valid_targets
      echo "usage: $0 [--cache-only] <$(echo $valid_targets | tr ' ' '|')>"
      exit 1
  }

  # argument parsing adapted from:
  # StackOverflow user Robert Siemer April 20, 2015
  # https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
  set -o errexit -o pipefail -o noclobber -o nounset
  getopt --test > /dev/null && true
  if [[ $? -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
  fi
  LONGOPTS=cache-only,help
  OPTIONS=h
  PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@") || usage
  eval set -- "$PARSED"
  cache_only=false

  while true; do
    case "$1" in
      --cache-only)
          cache_only=true
          shift
          ;;
      -h|--help)
          usage
          exit 0
          ;;
      --)
          shift
          break
          ;;
      *)
          echo "Programming error"
          exit 3
          ;;
    esac
  done
  set +o noclobber

  if [[ $# -ne 1 ]]; then
    fail=1
  else
    target=$1
    target_is_valid="no"
    for valid_target in $valid_targets; do
      if [[ $target == "$valid_target" ]]; then
        target_is_valid=yes
        break
      fi
    done
    if [[ $target_is_valid == "no" ]]; then
      fail=1
    fi
  fi
  if is_set fail; then
    usage
    exit 1
  fi
}

check_usage_no_pos_args() {
  usage() {
      export valid_targets
      echo "usage: $0 [--cache-only]"
      exit 1
  }

  # argument parsing adapted from:
  # StackOverflow user Robert Siemer April 20, 2015
  # https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
  set -o errexit -o pipefail -o noclobber -o nounset
  getopt --test > /dev/null && true
  if [[ $? -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
  fi
  LONGOPTS=cache-only,help
  OPTIONS=h
  PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@") || usage
  eval set -- "$PARSED"
  cache_only=false

  while true; do
    case "$1" in
      --cache-only)
          cache_only=true
          shift
          ;;
      -h|--help)
          usage
          exit 0
          ;;
      --)
          shift
          break
          ;;
      *)
          echo "Programming error"
          exit 3
          ;;
    esac
  done
  set +o noclobber
}