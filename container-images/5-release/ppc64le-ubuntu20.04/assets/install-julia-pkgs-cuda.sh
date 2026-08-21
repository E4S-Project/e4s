#!/bin/bash -e

export mpi_root=/opt/mpi/pkgs/mpich-5.0.1
export mpi_lib=$mpi_root/lib
export LD_LIBRARY_PATH=$mpi_lib:$LD_LIBRARY_PATH
export PATH=/usr/local/julia/bin:$PATH
export PATH=/usr/local/cuda-11.2/bin:$PATH
export julia_global=/opt/julia-central
export julia_global_depot=$julia_global/depot
export julia_global_load=$julia_global/load
rm -rf $julia_global_load $julia_global_depot
mkdir -p $julia_global_depot
mkdir -p $julia_global_load

julia -e 'using Pkg; Pkg.add("MPIPreferences")'
julia --project -e 'using MPIPreferences; MPIPreferences.use_system_binary()'
julia --project -e 'using Pkg; Pkg.instantiate()'
julia -e 'using Pkg; Pkg.add("MPI")'
julia -e 'using MPI; print(MPI.Get_library_version())' | grep -i mpich >/dev/null 2>&1

# julia -e 'using Pkg; Pkg.add("CUDA")'
# julia -e 'using CUDA; CUDA.set_runtime_version!(v"11.2"; local_toolkit=true)'
# julia -e 'using CUDA; CUDA.precompile_runtime()'
