#!/bin/bash -e

. /etc/e4s/utilities.sh

require_env SPACK_CORE_ROOT

. $SPACK_CORE_ROOT/share/spack/setup-env.sh
export PARAVIEW_PATH=$(spack location -i paraview+qt~cuda)
if [[ $IMAGE_TARGET =~ "cuda" ]]; then
  export TAU_SPEC="tau+cuda"
else
  export TAU_SPEC="tau~cuda~rocm"
fi
if ! spack find --format "{hash}" $TAU_SPEC >/dev/null 2>&1; then
  _err error: could not find expected TAU spec: $TAU_SPEC
  exit 1
fi
export TAU_HASH=$(spack find --format "{hash}" $TAU_SPEC)
export TAU_PATH=$(spack location -i /$TAU_HASH)
export TAU_SHARED_LIB_PATH=$(ls -d $TAU_PATH/lib/shared-* | grep -v disable)
export TAU_LIB_PATH=$TAU_PATH/lib
# export DYNINST_HASH=$(spack find --format "{HASH} {NAME}" --deps /$TAU_HASH  | grep dyninst)
# export DYNINST_HASH=${DYNINST_HASH##*([[:space:]])}
# export DYNINST_HASH=$(echo $DYNINST_HASH | cut -d' ' -f1)
# export DYNINST_PATH=$(spack location -i /$DYNINST_HASH)
export OPENJDK_HASH=$(spack find --format "{HASH} {NAME}" --deps /$TAU_HASH  | grep openjdk)
export OPENJDK_HASH=${OPENJDK_HASH##*([[:space:]])}
export OPENJDK_HASH=$(echo $OPENJDK_HASH | cut -d' ' -f1)
export OPENJDK_PATH=$(spack location -i /$OPENJDK_HASH)

apt update -y
apt install -y moreutils

rc=/tmp/bash.bashrc

cat <<'EOF' >$rc

## BEGIN RC-MODIFICATIONS

mkdir -p /tmp/$(whoami) >/dev/null 2>&1
mkdir -p /dev/shm/$(whoami) >/dev/null 2>&1
export JULIA_HISTORY=~/.julia/logs/repl_history.jl
export JULIA_DEPOT_PATH=/tmp/$(whoami):$JULIA_DEPOT_PATH:~/.julia:/root/.julia

# Needed to prevent OSError: /lib/powerpc64le-linux-gnu/libgomp.so.1: cannot allocate memory in static TLS block
# ... when tensorflow is imported first, torch second;
# ... needed for horovod build
export LD_PRELOAD=/lib/powerpc64le-linux-gnu/libgomp.so.1

export XDG_RUNTIME_DIR=/dev/shm/$(whoami)
export JULIA_CPU_TARGET='pwr8'
unset which

export PYTHONWARNINGS="ignore::FutureWarning,ignore::DeprecationWarning,ignore::RuntimeWarning,ignore::UserWarning"

export PATH=$PATH:/usr/local/codium/bin
export PATH=$PATH:$TAU_PATH/bin
export TAU=$TAU_LIB_PATH
export LD_LIBRARY_PATH=$TAU_LIB_PATH:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$TAU_SHARED_LIB_PATH:$LD_LIBRARY_PATH
export PATH=$PATH:$OPENJDK_PATH/bin
export PATH=$PATH:$PARAVIEW_PATH/bin

. $SPACK_CORE_ROOT/share/spack/setup-env.sh
# source $HOME/.local/bin/env

module use $SPACK_CORE_ROOT/share/spack/modules/linux-ubuntu20.04-ppc64le
module load mpich
EOF

envsubst '$SPACK_CORE_ROOT,$TAU_PATH,$TAU_LIB_PATH,$PARAVIEW_PATH,$OPENJDK_PATH,$TAU_SHARED_LIB_PATH' < $rc | sponge $rc

cat $rc >> /etc/bash.bashrc
