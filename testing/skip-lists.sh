#!/bin/bash

#SPACK SKIP TESTS
SKIP_TESTS_ALL_CPU="adios2 openpmd-api umap plumed e4s-alc warpx"
SKIP_TESTS_ALL_CUDA="heffte-cuda adios2-cuda papi-cuda"
SKIP_TESTS_ALL_ROCM=""

SKIP_TESTS_aarch64_rocky_cpu="cabana zfp charliecloud e4s-cl gptune hdf5 hdf5-vol-async umap wps wrf hpx nwchem"
SKIP_TESTS_aarch64_rocky_cuda_90="cabana-cuda"
SKIP_TESTS_aarch64_rocky_cuda_120=""
SKIP_TESTS_aarch64_ubuntu_cpu="cabana charliecloud darshan-util e4s-cl gptune hdf5 hdf5-vol-async plasma wps wrf hpx"
SKIP_TESTS_aarch64_ubuntu_cuda_90="cabana-cuda"
SKIP_TESTS_aarch64_ubuntu_cuda_120=""

#dyninst: static initialization segfaults with libtbbmalloc_proxy. Rebuild without tbb and/or report to devs
SKIP_TESTS_ppc64le_ubuntu_cpu="arborx axom boost dyninst libunwind mercury raja bricks butterflypack darshan-util e4s-alc e4s-cl gasnet hdf5 hdf5-vol-async py-libensemble unifyfs warpx wps wrf libceed cabana"
SKIP_TESTS_ppc64le_ubuntu_cuda_70="cabana-cuda"

SKIP_TESTS_x86_64_rocky_cpu="plasma cabana dyninst charliecloud e4s-cl gptune hdf5 hdf5-vol-async variorum warpx wps wrf flecsi nwchem"
SKIP_TESTS_x86_64_rocky_cuda_90="cabana-cuda flecsi-cuda"
SKIP_TESTS_x86_64_rocky_cuda_120="flecsi-cuda"
SKIP_TESTS_x86_64_ubuntu_cpu="plasma cabana variorum charliecloud darshan-util e4s-cl gptune hdf5 hdf5-vol-async warpx wps wrf flecsi"
SKIP_TESTS_x86_64_ubuntu_cuda_80="libceed-cuda cabana-cuda flecsi-cuda"
SKIP_TESTS_x86_64_ubuntu_cuda_90="petsc-cuda cabana-cuda flecsi-cuda"
SKIP_TESTS_x86_64_ubuntu_cuda_120="sundials-cuda flecsi-cuda"

SKIP_TESTS_x86_64_ubuntu_oneapi="cabana charliecloud fortrilinos hpx variorum hdf5-vol-async mercury nekbone plumed stc turbine umap unifyfs"

SKIP_TESTS_x86_64_ubuntu_rocm_90a="heffte-rocm tasmanian-rocm cabana-rocm strumpack-rocm"
SKIP_TESTS_x86_64_ubuntu_rocm_942="amrex-rocm heffte-rocm slate-rocm tasmanian-rocm cabana-rocm strumpack-rocm"

#NON-SPACK SKIP TESTS
SKIP_NONSPACK_aarch64_rocky_cuda_90="tensorflow-cuda"
SKIP_NONSPACK_aarch64_rocky_cuda_120="tensorflow-cuda cv2 jax"
SKIP_NONSPACK_aarch64_ubuntu_cuda_90="tensorflow-cuda"
SKIP_NONSPACK_aarch64_ubuntu_cuda_120="tensorflow-cuda jax"
SKIP_NONSPACK_aarch64_ubuntu_cpu="tensorflow-cuda"

SKIP_NONSPACK_ppc64le_ubuntu_cpu="pytorch pytorch-cuda tensorflow tensorflow-cuda"
SKIP_NONSPACK_ppc64le_ubuntu_cuda_70="pytorch-cuda"

SKIP_NONSPACK_x86_64_ubuntu_cuda_80="tensorflow"
SKIP_NONSPACK_x86_64_ubuntu_cuda_90="tensorflow"
SKIP_NONSPACK_x86_64_ubuntu_rocm_90a="jax tensorflow"
SKIP_NONSPACK_x86_64_ubuntu_rocm_942="jax"
