#!/bin/bash -e

export LD_LIBRARY_PATH=/opt/intel/oneapi/umf/0.11/lib:$LD_LIBRARY_PATH
export PATH=/usr/local/julia/bin:$PATH

export mpi_root=/opt/mpi/pkgs/mpich-5.0.1
export mpi_lib=$mpi_root/lib
export LD_LIBRARY_PATH=$mpi_lib:$LD_LIBRARY_PATH
export PATH=/usr/local/julia/bin:$PATH
export PATH=/usr/local/cuda-12.9/bin:$PATH
export julia_global=/opt/julia-central
export julia_global_depot=$julia_global/depot
export julia_global_load=$julia_global/load
rm -rf $julia_global_load $julia_global_depot
mkdir -p $julia_global_depot
mkdir -p $julia_global_load

export JULIA_DEPOT_PATH=$julia_global_depot:
export JULIA_LOAD_PATH=$julia_global_load:
export JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'

julia -e 'using Pkg; Pkg.add("MPIPreferences")'
julia --project -e 'using MPIPreferences; MPIPreferences.use_system_binary()'
julia --project -e 'using Pkg; Pkg.instantiate()'
julia -e 'using Pkg; Pkg.add("MPI")'
julia -e 'using MPI; print(MPI.Get_library_version())' | grep -i intel >/dev/null 2>&1
julia -e 'using Pkg; Pkg.add("oneAPI")'
