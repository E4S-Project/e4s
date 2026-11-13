#!/bin/bash -e

export mpi_lib=/opt/mpi/pkgs/mpich-5.0.1/lib
export LD_LIBRARY_PATH=$mpi_lib:$LD_LIBRARY_PATH
export PATH=/usr/local/julia/bin:$PATH
export PATH=/usr/local/cuda-12.9/bin:$PATH

export julia_global=/opt/e4s/julia
export julia_global_depot=$julia_global/depot
export julia_global_load=$julia_global/load
export julia_dotjulia=$julia_global/.julia

rm -rf $julia_global_load $julia_global_depot
mkdir -p $julia_global_depot
mkdir -p $julia_global_load

cat <<EOF >$julia_global_load/Project.toml
[deps]
CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
IRTools = "7869d1d1-7146-5819-86e3-90919afe41df"
JACC = "0979c8fe-16a4-4796-9b82-89a9f10403ea"
MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"
MPIPreferences = "3da0fdf6-3ccc-4f1b-acd9-58baa6c99267"

[extras]
CUDA_Runtime_jll = "76a88914-d11a-5bdc-97e0-2f5a05c973a2"

[preferences.CUDA_Runtime_jll]
version = "12.9"
local = "true"

[preferences.MPIPreferences]
__clear__ = ["preloads_env_switch"]
_format = "1.0"
abi = "MPICH"
binary = "system"
cclibs = []
libmpi = "libmpi"
mpiexec = "mpiexec"
preloads = []
EOF

cat <<EOF >$julia_global_load/LocalPreferences.toml
[JACC]
backends = ["threads", "cuda"]
default_backend = "cuda"

    [JACC.placement]
    cuda = "deps"
EOF

export JULIA_DEPOT_PATH=$julia_global_depot:
export JULIA_LOAD_PATH=$julia_global_load:
export JULIA_CPU_TARGET="generic;cortex-a57;thunderx2t99;carmel,clone_all;apple-m1,base(3);neoverse-n1,clone_all;neoverse-512tvb,clone_all;neoverse-v1,base(6);neoverse-v2,base(6)"

julia -e 'using Pkg; Pkg.instantiate()'
julia -e 'using CUDA; using MPI'

export JULIA_DEPOT_PATH=$julia_dotjulia:$julia_global_depot:
export JULIA_LOAD_PATH=:$julia_global_load:
julia -e 'using CUDA; using MPI'
