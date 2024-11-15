# E4S Release 24.11

November 2024 release of E4S

## Files

* `amd64-gcc-cpu-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems without GPU (amd64)
* `amd64-gcc-cuda-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (amd64)
* `amd64-gcc-rocm-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with AMD GPUs (amd64)
* `amd64-oneapi-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with Intel GPUs (amd64)
* `arm64-gcc-cpu-ubuntu24.04/spack.yaml` -- Model Spack Environment for systems without GPU (arm64)
* `arm64-gcc-cuda-ubuntu24.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (arm64)
* `ppc64le-gcc-cpu-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems without GPUs (ppc64le)
* `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (ppc64le)

Alongside the Spack environments listed above there are `concretize.log` files which show the exact versions and variants of the concretized environment. This includes both the root specs and the entire set of dependencies needed to build them.

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 24.11 uses Spack branch `e4s-24.11`
* https://github.com/spack/spack
* Branch [e4s-24.11](https://github.com/spack/spack/tree/e4s-24.11)


## Spack Build Cache

* https://cache.e4s.io/24.11 (not intended for web browser access; for use as a `spack mirror`)

```
$> spack mirror add E4S https://cache.e4s.io/24.11

$> spack buildcache keys -it
gpg: key 4345F04B40005581: public key "University of Oregon - E4S" imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg: inserting ownertrust of 6

$> spack buildcache list -al
...
```

## Model Environments

* Model environment for NVIDIA GPUs on amd64 is:
  * `amd64-gcc-cuda-ubuntu22.04/spack.yaml`
  * For `cuda_arch=80` and `cuda_arch=90`
  * Built and tested using:
    * `Ubuntu 22.04, GCC 11.4.0, CUDA 12.2.0, 11.8.0`
    * `ecpe4s/e4s-release-base-cuda-amd64:24.11`

* Model environment for NVIDIA GPUs on ppc64le is:
  * `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml`
  * For `cuda_arch=70`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0, CUDA 11.4.4`
    * `ecpe4s/e4s-release-base-cuda-ppc64:24.11`

* Model environment for NVIDIA GPUs on arm64 is:
  * `arm64-gcc-cuda-ubuntu24.04/spack.yaml`
  * For `cuda_arch=75`, `cuda_arch=80`, `cuda_arch=90`
  * Built and tested using:
    * `Ubuntu 24.04, GCC 13.2.0, CUDA 12.6.2`
    * `ecpe4s/e4s-release-base-cuda-arm64:24.11`

* Model environment for AMD GPUs on x86_64 is:
  * `amd64-gcc-rocm-ubuntu22.04/spack.yaml`
  * For `amdgpu_target=gfx908` and `amdgpu_target=gfx90a`
  * Built and tested using:
    * `Ubuntu 22.04, GCC 11.4.0, ROCm 6.2.1`
    * `ecpe4s/e4s-release-base-rocm-amd64:24.11`

* Model environment for Intel GPUs on x86_64 is:
  * `amd64-oneapi-ubuntu22.04/spack.yaml`
  * Built and tested using:
    * `Ubuntu 22.04, OneAPI 2024.2.1`
    * `ecpe4s/e4s-release-base-oneapi-amd64:24.11`
    * Derived from Intel's official `intel/hpckit:2024.2.1-devel-ubuntu22.04` image

## Example output of `spack find`

Here is what `spack find` would show following the installation of the `amd64-gcc-{cpu,cuda}-ubuntu22.04/spack.yaml` with the `cuda_arch=80` specs enabled.

```
root@a1f28a5540c6:/# spack find -x
-- linux-ubuntu22.04-x86_64 / gcc@11.4.0 ------------------------
adios@1.13.1         caliper@2.11.0         exaworks@0.1.0      h5bench@1.4            legion@24.09.0       nek5000@19.0            petsc@3.22.0            slepc@3.22.0        umap@2.1.1
adios2@2.7.1         chai@2024.07.0         faodel@1.2108.1     hdf5@1.12.3            legion@24.09.0       nekbone@17.0            phist@1.12.1            slepc@3.22.0        umpire@2024.07.0
adios2@2.10.1        chai@2024.07.0         fftx@1.2.0          hdf5-vol-async@1.7     libcatalyst@2.0.0    netcdf-fortran@4.6.1    plasma@24.8.7           stc@0.9.0           umpire@2024.07.0
alquimia@1.1.0       chapel@2.2.0           fftx@1.2.0          hdf5-vol-cache@v1.1    libnrm@0.1.0         netlib-scalapack@2.2.0  plumed@2.9.2            strumpack@7.2.0     unifyfs@2.0
aml@0.2.1            chapel@2.2.0           flecsi@2.3.0        hdf5-vol-log@1.4.0     libpressio@0.99.4    nrm@0.1.0               precice@3.1.2           strumpack@7.2.0     upcxx@2023.9.0
amrex@24.10          charliecloud@0.38      flecsi@2.3.0        heffte@2.4.0           libpressio@0.99.4    nvhpc@24.9              pruners-ninja@1.0.1     sundials@7.1.1      upcxx@2023.9.0
amrex@24.10          conduit@0.9.2          flit@2.1.0          heffte@2.4.0           libquo@1.4           nwchem@7.2.3            pumi@2.2.8              sundials@7.1.1      variorum@0.8.0
arborx@1.7           cp2k@2024.3            flux-core@0.66.0    hpctoolkit@2024.01.1   libunwind@1.6.2      omega-h@9.34.13         py-cinemasci@1.3        superlu@5.3.0       veloc@1.7
arborx@1.7           cusz@0.6.0             flux-core@0.66.0    hpctoolkit@2024.01.1   loki@0.1.7           openfoam@2312           py-deephyper@0.6.0      superlu-dist@8.2.1  visit@3.3.3
argobots@1.2         darshan-runtime@3.4.5  fortrilinos@2.3.0   hpx@1.10.0             magma@2.8.0          openmpi@5.0.5           py-h5py@3.11.0          superlu-dist@8.2.1  vtk-m@2.2.0
ascent@0.9.3         darshan-util@3.4.5     fpm@0.10.0          hpx@1.10.0             mercury@2.3.1        openpmd-api@0.16.0      py-jupyterhub@1.4.1     swig@4.0.2-fortran  vtk-m@2.2.0
axom@0.9.0           datatransferkit@3.1.1  gasnet@2024.5.0     hypre@2.32.0           metall@0.28          papi@7.1.0              py-libensemble@1.4.2    sz@2.1.12.5         wannier90@3.1.0
axom@0.9.0           dealii@9.5.1           ginkgo@1.8.0        hypre@2.32.0           mfem@4.7.0           papi@7.1.0              py-petsc4py@3.22.0      sz3@3.2.0           wps@4.5
bolt@2.0             dealii@9.5.1           ginkgo@1.8.0        kokkos@4.4.01          mfem@4.7.0           papyrus@1.0.2           qthreads@1.18           tasmanian@8.0       wrf@4.5.2
boost@1.79.0         dyninst@13.0.0         globalarrays@5.8.2  kokkos@4.4.01          mgard@2023-12-09     parallel-netcdf@1.12.3  quantum-espresso@7.3.1  tasmanian@8.0       xyce@7.8.0
bricks@2023.08.25    e4s-alc@1.0.2          glvis@4.2           kokkos-kernels@4.4.01  mgard@2023-12-09     paraview@5.13.1         raja@2024.07.0          tau@2.34            zfp@0.5.5
bricks@2023.08.25    e4s-cl@1.0.4           gmp@6.3.0           kokkos-kernels@4.4.01  mpark-variant@1.4.0  paraview@5.13.1         raja@2024.07.0          tau@2.34            zfp@0.5.5
butterflypack@2.4.0  ecp-data-vis-sdk@1.0   gotcha@1.0.7        laghos@3.1             mpich@4.2.3          parsec@3.0.2209         rempi@1.1.0             trilinos@13.0.1
cabana@0.7.0         ecp-data-vis-sdk@1.0   gptune@4.0.0        lammps@20240829        mpifileutils@0.11.1  parsec@3.0.2209         scr@3.0.1               trilinos@16.0.0
cabana@0.7.0         exago@1.6.0            gromacs@2024.3      lammps@20240829        nccmp@1.9.1.0        pdt@3.25.2              slate@2024.05.31        trilinos@16.0.0
caliper@2.11.0       exago@1.6.0            gromacs@2024.3      lbann@0.104            nco@5.2.4            petsc@3.22.0            slate@2024.05.31        turbine@1.3.0
==> 185 installed packages
```
