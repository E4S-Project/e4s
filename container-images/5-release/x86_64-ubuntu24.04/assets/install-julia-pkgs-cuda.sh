#!/bin/bash -e

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
export JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'

julia -e 'using Pkg; Pkg.instantiate()'
# julia -e 'import JACC; JACC.set_backend("cuda")'
julia -e 'using MPI; print(MPI.Get_library_version())' 
# julia -e 'using CUDA; print(CUDA.versioninfo())'
# ERROR: CUDA driver not functional
# Stacktrace:
#  [1] error(s::String)
#    @ Base ./error.jl:44
#  [2] functional
#    @ /opt/julia-central/depot/packages/CUDACore/sIGRL/src/initialization.jl:47 [inlined]
#  [3] versioninfo(io::Base.PipeEndpoint)
#    @ CUDATools /opt/julia-central/depot/packages/CUDATools/7RKWP/src/utilities.jl:8
#  [4] top-level scope
#    @ none:1
#  [5] eval(m::Module, e::Any)
#    @ Core ./boot.jl:489
#  [6] exec_options(opts::Base.JLOptions)
#    @ Base ./client.jl:283
#  [7] _start()
#    @ Base ./client.jl:550

# julia - <<EOF
# import JACC
# JACC.@init_backend

# function axpy(i, alpha, x, y)
#   @inbounds x[i] += alpha * y[i]
# end

# N = 100_000
# alpha = 2.0
# x = JACC.zeros(Float32, N)
# y = JACC.array(fill(Float32(5), N))
# JACC.parallel_for(N, axpy, alpha, x, y)
# a = JACC.parallel_reduce(x)
# println("Result: ", a)
# EOF

export julia_setup_script=/opt/julia-central/julia-cuda-user-setup.sh
cat <<EOF >$julia_setup_script
export mpi_root=/opt/mpi/pkgs/mpich-5.0.1
export mpi_lib=$mpi_root/lib

export PATH=/usr/local/julia/bin:$PATH
export PATH=/usr/local/cuda-12.9/bin:$PATH
export LD_LIBRARY_PATH=$mpi_lib:$LD_LIBRARY_PATH
export julia_global=/opt/julia-central
export julia_global_depot=$julia_global/depot
export julia_global_load=$julia_global/load

export JULIA_DEPOT_PATH="~/.julia:$julia_global_depot:"
export JULIA_LOAD_PATH=:$julia_global_load
export JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'

julia -e 'using CUDA; CUDA.precompile_runtime()'
julia -e 'using MPI; using CUDA; using JACC'
EOF
chmod +x $julia_setup_script
