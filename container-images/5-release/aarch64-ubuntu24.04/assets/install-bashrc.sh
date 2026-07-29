#!/bin/bash -e

. /etc/e4s/utilities.sh

require_env IMAGE_TARGET
require_env SPACK_CORE_ROOT

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
export TAU_SHARED_LIB_PATH=$(ls -d $TAU_PATH/lib/shared-* | grep -v disable)
export TAU_LIB_PATH=$TAU_PATH/lib
export DYNINST_HASH=$(spack find --format "{HASH} {NAME}" --deps /$TAU_HASH  | grep dyninst)
export DYNINST_HASH=${DYNINST_HASH##*([[:space:]])}
export DYNINST_HASH=$(echo $DYNINST_HASH | cut -d' ' -f1)
export DYNINST_PATH=$(spack location -i /$DYNINST_HASH)
export DYNINST_LIB_PATH=$DYNINST_PATH/lib
export OPENJDK_HASH=$(spack find --format "{HASH} {NAME}" --deps /$TAU_HASH  | grep openjdk)
export OPENJDK_HASH=${OPENJDK_HASH##*([[:space:]])}
export OPENJDK_HASH=$(echo $OPENJDK_HASH | cut -d' ' -f1)
export OPENJDK_PATH=$(spack location -i /$OPENJDK_HASH)


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
envsubst '$SPACK_CORE_ROOT,$TAU_PATH,$TAU_LIB_PATH,$DYNINST_LIB_PATH,$OPENJDK_PATH,$TAU_SHARED_LIB_PATH' < $rc | sponge $rc
cat $rc >> /etc/bash.bashrc



if [[ $IMAGE_TARGET =~ "cuda" ]] ; then
cat <<'EOF' >> /etc/e4s/install-npm-pkgs.sh
#!/bin/bash

mkdir -p ~/.e4s

npm install -g @google/gemini-cli
npm install -g --ignore-scripts @earendil-works/pi-coding-agent

nemoclaw_done=~/.e4s/nemoclaw_installed
if [[ ! -f $nemoclaw_done ]]; then
  nemoclaw_tmpdir=$(mktemp -d)
  git clone --quiet https://github.com/NVIDIA/NemoClaw $nemoclaw_tmpdir
  cd $nemoclaw_tmpdir
  npm install
  touch $nemoclaw_done
fi

openclaw_done=~/.e4s/openclaw_installed
if [[ ! -f $openclaw_done ]]; then
  openclaw_installer=$(mktemp)
  curl -fsSL --proto '=https' --tlsv1.2 https://openclaw.ai/install.sh --output $openclaw_installer
  chmod +x $openclaw_installer
  $openclaw_installer --no-prompt --no-onboard
  touch $openclaw_done
fi
EOF
chmod +x /etc/e4s/install-npm-pkgs.sh

cat <<'EOF' >> /etc/bash.bashrc
julia_global=/opt/julia-central
julia_global_depot=$julia_global/depot
julia_global_load=$julia_global/load
export JULIA_HISTORY="~/.julia/logs/repl_history.jl"
export JULIA_DEPOT_PATH="~/.julia:$julia_global_depot:"
export JULIA_LOAD_PATH=:$julia_global_load
export JULIA_CPU_TARGET='generic;cortex-a57;thunderx2t99;carmel,clone_all;apple-m1,base(3);neoverse-n1,clone_all;neoverse-512tvb,clone_all;neoverse-v1,base(6);neoverse-v2,base(6)'
donefile=/tmp/$(whoami).julia-install
# (/opt/julia-central/julia-cuda-user-setup.sh >/dev/null 2>&1 &)
mkdir -p ~/.e4s/logs
(/etc/e4s/install-npm-pkgs.sh >~/.e4s/logs/e4s-install-npm-pkgs.log 2>&1 &)
EOF
fi