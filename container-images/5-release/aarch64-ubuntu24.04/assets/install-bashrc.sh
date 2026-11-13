#!/bin/bash -e

. /etc/e4s/utilities.sh

require_env IMAGE_TARGET
require_env SPACK_CORE_ROOT
require_env E4S_IID
require_env E4S_VERSION

. $SPACK_CORE_ROOT/share/spack/setup-env.sh
export PARAVIEW_PATH=$(spack location -i paraview+qt)

if [[ $IMAGE_TARGET =~ "cuda" ]]; then
  export TAU_SPEC="tau+julia+cuda+dyninst"
else
  export TAU_SPEC="tau+julia~cuda~rocm+dyninst"
fi
if ! spack find --format "{hash}" $TAU_SPEC >/dev/null 2>&1; then
  _err error: could not find expected TAU spec: $TAU_SPEC
  exit 1
fi
export TAU_HASH=$(spack find --format "{hash}" $TAU_SPEC)
export TAU_PATH=$(spack location -i /$TAU_HASH)
export TAU_LIB_PATH=$(get_lib_dir "$TAU_PATH")
export TAU_SHARED_LIB_PATH=$(ls -d "$TAU_LIB_PATH"/shared-* | grep -v disable)
export DYNINST_HASH=$(spack find --format "{HASH} {NAME}" --deps /$TAU_HASH  | grep dyninst)
export DYNINST_HASH=${DYNINST_HASH##*([[:space:]])}
export DYNINST_HASH=$(echo $DYNINST_HASH | cut -d' ' -f1)
export DYNINST_PATH=$(spack location -i /$DYNINST_HASH)
export DYNINST_LIB_PATH=$(get_lib_dir "$DYNINST_PATH")
export OPENJDK_HASH=$(spack find --format "{HASH} {NAME}" --deps /$TAU_HASH  | grep openjdk)
export OPENJDK_HASH=${OPENJDK_HASH##*([[:space:]])}
export OPENJDK_HASH=$(echo $OPENJDK_HASH | cut -d' ' -f1)
export OPENJDK_PATH=$(spack location -i /$OPENJDK_HASH)

tau_makefiles=("$TAU_LIB_PATH"/Makefile.tau*)

if (( ${#tau_makefiles[@]} != 1 )) || [[ ! -f "${tau_makefiles[0]}" ]]; then
    echo "Error: expected exactly 1 Makefile.tau* in $TAU_LIB_PATH" >&2
    exit 1
fi

export TAU_MAKEFILE="${tau_makefiles[0]}"

rc=$(mktemp)
cat <<'EOF' >$rc

## BEGIN RC-MODIFICATIONS
# Needed to prevent OSError: /lib/aarch64-linux-gnu/libgomp.so.1: cannot allocate memory in static TLS block
# ... when tensorflow is imported first, torch second;
# ... needed for horovod build
export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1

export PATH=/usr/local/julia/bin:$PATH
mkdir -p /tmp/$(whoami) >/dev/null 2>&1
mkdir -p /dev/shm/$(whoami) >/dev/null 2>&1
export XDG_RUNTIME_DIR=/dev/shm/$(whoami)
unset which
export PYTHONWARNINGS="ignore::FutureWarning,ignore::DeprecationWarning,ignore::RuntimeWarning,ignore::UserWarning,ignore::SyntaxWarning"
export PATH=$PATH:$TAU_PATH/bin
export DYNINSTAPI_RT_LIB=$DYNINST_LIB_PATH/libdyninstAPI_RT.so
export TAU=$TAU_LIB_PATH
export TAU_MAKEFILE=$TAU_MAKEFILE
export LD_LIBRARY_PATH=$TAU_LIB_PATH:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$TAU_SHARED_LIB_PATH:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$DYNINST_LIB_PATH:$LD_LIBRARY_PATH
export PATH=$PATH:$PARAVIEW_PATH/bin
export PATH=$PATH:$OPENJDK_PATH/bin
. $SPACK_CORE_ROOT/share/spack/setup-env.sh
# source $HOME/.local/bin/env
module use $SPACK_CORE_ROOT/share/spack/modules/linux-ubuntu24.04-aarch64
module use ~/spack/share/spack/modules/linux-ubuntu24.04-aarch64
# export TIKTOKEN_ENCODINGS_BASE=/etc/encodings
EOF
envsubst '$SPACK_CORE_ROOT,$TAU_PATH,$TAU_LIB_PATH,$TAU_MAKEFILE,$DYNINST_LIB_PATH,$OPENJDK_PATH,$TAU_SHARED_LIB_PATH' < $rc | sponge $rc
cat $rc >> /etc/bash.bashrc



cat <<'EOF' >> /etc/bash.bashrc
export PATH=/usr/local/node/bin:$PATH

is_set() {
  ! [[ -z "${!1+x}" ]];
}

e4s_state_parent=$HOME
e4s_state=$(realpath -m $e4s_state_parent/.e4s)

if is_set E4S_IID && is_set E4S_VERSION; then
  uid=${E4S_IID}-${E4S_VERSION}
  e4s_state=$(realpath -m $e4s_state_parent/.e4s/$uid)
fi

e4s_opt=/opt/e4s

julia_global=$e4s_opt/julia
julia_global_depot=$julia_global/depot
julia_global_load=$julia_global/load

npm_root=$e4s_state/node
npm_global=$npm_root/global

if [[ -w $e4s_opt ]]; then
  julia_dotjulia=$julia_global/.julia
  julia_logs=$julia_dotjulia/logs
  npm_root=$e4s_opt/node
  npm_global=$npm_root/global
else
  mkdir -p $e4s_state &>/dev/null
  julia_state=$e4s_state/julia
  julia_dotjulia=$julia_state/.julia
  julia_logs=$julia_dotjulia/logs
  mkdir -p $julia_state &>/dev/null
  (cp -r $julia_global/.julia $julia_dotjulia &>/dev/null &)
  npm_root=$e4s_state/node
  npm_global=$npm_root/global
  mkdir -p $(dirname $npm_global) &>/dev/null
  (cp -r $e4s_opt/node/global $npm_global &>/dev/null &)
fi

export NPM_CONFIG_USERCONFIG=$npm_root/.npmrc
export NPM_CONFIG_PREFIX=$npm_global
export PATH=$npm_global/bin:$PATH

echo prefix=$npm_global > $npm_root/.npmrc

npm config set fund false --location=global &>/dev/null
npm config set update-notifier false &>/dev/null

mkdir -p $julia_logs &>/dev/null

export JULIA_HISTORY="$julia_logs/repl_history.jl"
export JULIA_DEPOT_PATH="$julia_dotjulia:$julia_global_depot:"
export JULIA_LOAD_PATH=:$julia_global_load
export JULIA_CPU_TARGET='generic;cortex-a57;thunderx2t99;carmel,clone_all;apple-m1,base(3);neoverse-n1,clone_all;neoverse-512tvb,clone_all;neoverse-v1,base(6);neoverse-v2,base(6)'
export MODULEPATH="$HOME/.e4s/${E4S_IID}-${E4S_VERSION}/modules${MODULEPATH:+:$MODULEPATH}"
EOF
