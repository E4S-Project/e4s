# E4S Release 24.02

February 2024 release of E4S

## Files

* `amd64-gcc-cpu-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems without GPU (amd64)
* `amd64-gcc-cuda-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (amd64)
* `amd64-gcc-rocm-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems with AMD GPUs (amd64)
* `amd64-oneapi-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with Intel GPUs (amd64)
* `arm64-gcc-cpu-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems without GPU (arm64)
* `arm64-gcc-cuda-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (arm64)
* `ppc64le-gcc-cpu-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems without GPUs (ppc64le)
* `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (ppc64le)

Alongside the Spack environments listed above there are `concretize.log` files which show the exact versions and variants of the concretized environment. This includes both the root specs and the entire set of dependencies needed to build them.

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 24.02 uses Spack branch `e4s-24.02`
* https://github.com/spack/spack
* Branch [e4s-24.02](https://github.com/spack/spack/tree/e4s-24.02)


## Spack Build Cache

* https://cache.e4s.io/24.02 (not intended for web browser access; for use as a `spack mirror`)

```
$> spack mirror add E4S https://cache.e4s.io/24.02

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
  * `amd64-gcc-cuda-ubuntu20.04/spack.yaml`
  * For `cuda_arch=80` and `cuda_arch=90`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.4.0`
    * `ecpe4s/ubuntu20.04-runner-amd64-gcc-11.4-mpi-base:2023.08.20`

* Model environment for NVIDIA GPUs on ppc64le is:
  * `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml`
  * For `cuda_arch=70`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-ppc64-gcc-11.4-mpi-base:2023.08.20`

* Model environment for NVIDIA GPUs on arm64 is:
  * `arm64-gcc-cuda-ubuntu20.04/spack.yaml
  * For `cuda_arch=75`, `cuda_arch=80`, `cuda_arch=90`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.4.0`
    * `ecpe4s/ubuntu20.04-runner-arm64-gcc-11.4-mpi-base:2023.08.20`

* Model environment for AMD GPUs on x86_64 is:
  * `amd64-gcc-rocm-ubuntu20.04/spack.yaml`
  * For `amdgpu_target=gfx908` and `amdgpu_target=gfx90a`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.4.0`
    * `ecpe4s/ubuntu20.04-runner-amd64-gcc-11.4-rocm5.4.3-mpi-base:2023.08.20`

* Model environment for Intel GPUs on x86_64 is:
  * `amd64-oneapi-ubuntu22.04/spack.yaml`
  * Built and tested using:
    * `Ubuntu 22.04, OneAPI 2024.0.1`
    * `ecpe4s/ubuntu22.04-runner-amd64-oneapi-2024.0.1:2024.01.22`
    * Derived from Intel's official `intel/hpckit:2024.0.1-devel-ubuntu22.04` image

## Example output of `spack find`

Here is what `spack find` would show following the installation of the `amd64-gcc-cuda-ubuntu20.04/spack.yaml` with the `cuda_arch=80` specs enabled.

```
root@0741a576c1d4:/# spack find -x
-- linux-ubuntu20.04-x86_64 / gcc@11.4.0 ------------------------
adios@1.13.1         chai@2022.03.0         flux-core@0.58.0      hpx@1.9.1              metall@0.25             paraview@5.11.2       raja@2022.10.4      trilinos@13.0.1
adios2@2.7.1         chai@2022.03.0         flux-core@0.58.0      hypre@2.30.0           mfem@4.6.0              paraview@5.11.2       rempi@1.1.0         trilinos@14.4.0
adios2@2.9.2         charliecloud@0.35      fortrilinos@2.3.0     hypre@2.30.0           mfem@4.6.0              parsec@3.0.2209       scr@3.0.1           trilinos@15.0.0
alquimia@1.1.0       conduit@0.8.8          gasnet@2023.9.0       kokkos@4.2.00          mgard@2023-03-31        parsec@3.0.2209       slate@2023.08.25    turbine@1.3.0
aml@0.2.1            cp2k@2024.1            ginkgo@1.7.0          kokkos@4.2.00          mgard@2023-03-31        pdt@3.25.2            slate@2023.08.25    umap@2.1.0
amrex@24.01          cuda@11.8.0            ginkgo@1.7.0          kokkos-kernels@4.2.00  mpark-variant@1.4.0     petsc@3.20.3          slepc@3.20.1        umpire@2022.10.0
amrex@24.01          cusz@0.3.1             globalarrays@5.8.2    kokkos-kernels@4.2.00  mpich@4.1.2             petsc@3.20.3          slepc@3.20.1        umpire@2022.10.0
arborx@1.5           darshan-runtime@3.4.4  gmp@6.2.1             lammps@20230802.2      mpifileutils@0.11.1     phist@1.12.0          stc@0.9.0           unifyfs@2.0
arborx@1.5           darshan-util@3.4.4     gotcha@1.0.5          lammps@20230802.2      nccmp@1.9.1.0           plasma@23.8.2         strumpack@7.2.0     upcxx@2023.9.0
argobots@1.1         datatransferkit@3.1.1  gptune@4.0.0          lbann@0.104            nco@5.1.6               plumed@2.9.0          strumpack@7.2.0     upcxx@2023.9.0
ascent@0.9.2         dealii@9.5.1           gromacs@2023.3        lbann@0.104            netlib-scalapack@2.2.0  precice@2.5.0         sundials@6.7.0      variorum@0.7.0
axom@0.8.1           dealii@9.5.1           gromacs@2023.3        legion@23.06.0         nrm@0.1.0               pruners-ninja@1.0.1   sundials@6.7.0      veloc@1.7
axom@0.8.1           dyninst@12.3.0         h5bench@1.4           legion@23.06.0         nvhpc@23.11             pumi@2.2.8            superlu@5.3.0       visit@3.3.3
bolt@2.0             ecp-data-vis-sdk@1.0   hdf5@1.12.3           libcatalyst@2.0.0-rc4  omega-h@9.34.13         py-cinemasci@1.3      superlu-dist@8.2.1  vtk-m@2.0.0
boost@1.79.0         ecp-data-vis-sdk@1.0   hdf5-vol-async@1.7    libnrm@0.1.0           omega-h@9.34.13         py-h5py@3.8.0         superlu-dist@8.2.1  vtk-m@2.1.0
bricks@2023.08.25    exago@1.6.0            hdf5-vol-cache@v1.1   libpressio@0.95.1      openfoam@2312           py-jupyterhub@1.4.1   swig@4.0.2-fortran  wannier90@3.1.0
bricks@2023.08.25    exago@1.6.0            hdf5-vol-log@1.4.0    libpressio@0.95.1      openmpi@5.0.1           py-libensemble@1.1.0  sz@2.1.12.5         xyce@7.8.0
butterflypack@2.4.0  exaworks@0.1.0         heffte@2.4.0          libquo@1.3.1           openpmd-api@0.15.2      py-petsc4py@3.20.2    sz3@3.1.7           zfp@0.5.5
cabana@0.6.0         faodel@1.2108.1        heffte@2.4.0          libunwind@1.6.2        papi@7.1.0              py-warpx@23.08        tasmanian@8.0       zfp@0.5.5
cabana@0.6.0         flecsi@2.2.1           hpctoolkit@2023.08.1  loki@0.1.7             papi@7.1.0              qthreads@1.18         tasmanian@8.0
caliper@2.10.0       flecsi@2.2.1           hpctoolkit@2023.08.1  magma@2.7.2            papyrus@1.0.2           quantum-espresso@7.3  tau@2.33.1
caliper@2.10.0       flit@2.1.0             hpx@1.9.1             mercury@2.3.1          parallel-netcdf@1.12.3  raja@2022.10.4        tau@2.33.1
==> 173 installed packages
```
