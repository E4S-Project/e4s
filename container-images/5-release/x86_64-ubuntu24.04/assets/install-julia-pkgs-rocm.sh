#!/bin/bash -e

export mpi_lib=/opt/mpi/pkgs/mpich-5.0.1/lib
export LD_LIBRARY_PATH=$mpi_lib:$LD_LIBRARY_PATH
export PATH=/usr/local/julia/bin:$PATH

export julia_global=/opt/e4s/julia
export julia_global_depot=$julia_global/depot
export julia_global_load=$julia_global/load
export julia_dotjulia=$julia_global/.julia

rm -rf $julia_global_load $julia_global_depot
mkdir -p $julia_global_depot
mkdir -p $julia_global_load

cat <<EOF >$julia_global_load/Project.toml
[deps]
MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"
MPIPreferences = "3da0fdf6-3ccc-4f1b-acd9-58baa6c99267"

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

export JULIA_DEPOT_PATH=$julia_global_depot:
export JULIA_LOAD_PATH=$julia_global_load:
export JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'

julia -e 'using Pkg; Pkg.instantiate()'
julia -e 'using MPI'

export JULIA_DEPOT_PATH=$julia_dotjulia:$julia_global_depot:
export JULIA_LOAD_PATH=:$julia_global_load:
julia -e 'using MPI'
