# E4S Release 23.11

November 2023 release of E4S

## Files

* `cuda-x86_64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (ppc64le)
* `cuda-aarch64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (aarch64)
* `rocm-x86_64/spack.yaml` -- Model Spack Environment for systems w/ AMD GPUs (x86_64)
* `oneapi-x86_64/spack.yaml` -- Model Spack Environment for systems w/ Intel GPUs (x86_64)

Alongside the Spack environments listed above there are `concretize.log` files which show the exact versions and variants of the concretized environment. This includes both the root specs and the entire set of dependencies needed to build them.

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 23.11 uses Spack branch `e4s-23.11`
* https://github.com/spack/spack
* Branch [e4s-23.11](https://github.com/spack/spack/tree/e4s-23.11)


## Spack Build Cache

* https://cache.e4s.io/23.11 (not intended for web browser access; for use as a `spack mirror`)

```
$> spack mirror add E4S https://cache.e4s.io/23.11

$> spack buildcache keys -it
gpg: key 4345F04B40005581: public key "University of Oregon - E4S" imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg: inserting ownertrust of 6

$> spack buildcache list -al
...
```

## Model Environments

* Model environment for NVIDIA GPUs on x86_64 is:
  * `cuda-x86_64/spack.yaml`
  * For `cuda_arch=80` and `cuda_arch=90`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.4.0`
    * `ecpe4s/ubuntu20.04-runner-amd64-gcc-11.4-mpi-base:2023.08.20`

* Model environment for NVIDIA GPUs on ppc64le is:
  * `cuda-ppc64le/spack.yaml`
  * For `cuda_arch=70`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-ppc64-gcc-11.4-mpi-base:2023.08.20`

* Model environment for NVIDIA GPUs on aarch64 is:
  * `cuda-aarch64/spack.yaml`
  * For `cuda_arch=75`, `cuda_arch=80`, `cuda_arch=90`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.4.0`
    * `ecpe4s/ubuntu20.04-runner-arm64-gcc-11.4-mpi-base:2023.08.20`

* Model environment for AMD GPUs on x86_64 is:
  * `rocm-x86_64/spack.yaml`
  * For `amdgpu_target=gfx908` and `amdgpu_target=gfx90a`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.4.0`
    * `ecpe4s/ubuntu20.04-runner-amd64-gcc-11.4-rocm5.4.3-mpi-base:2023.08.20`

* Model environment for Intel GPUs on x86_64 is:
  * `oneapi-x86_64/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, OneAPI 2023.2.1`
    * `ecpe4s/ubuntu20.04-runner-amd64-oneapi-2023.2.1-mpi-base:2023.08.20`
    * Derived from Intel's official `intel/oneapi-hpckit:2023.2.1-devel-ubuntu20.04` image

## Example output of `spack find`

Here is what `spack find` would show following the installation of the `cuda-x86_64/spack.yaml` with the `cuda_arch=80` specs enabled.

Note that many packages represented twice in the output below, such as `kokkos@4.1.00`, the reason is because both `kokkos@4.1.00 ~cuda` and `kokkos@4.1.00 +cuda` are installed.

```
root@0741a576c1d4:/# spack find -x
-- linux-ubuntu20.04-x86_64 / gcc@11.4.0 ------------------------
adios@1.13.1         chai@2022.03.0         fortrilinos@2.3.0     hypre@2.29.0           mgard@2023-03-31        parsec@3.0.2209       scr@3.0.1           trilinos@14.4.0
adios2@2.9.1         charliecloud@0.34      gasnet@2023.3.0       kokkos@4.1.00          mgard@2023-03-31        pdt@3.25.1            slate@2023.08.25    turbine@1.3.0
adios2@2.9.1         conduit@0.8.8          ginkgo@1.6.0          kokkos@4.1.00          mpark-variant@1.4.0     petsc@3.20.1          slate@2023.08.25    umap@2.1.0
alquimia@1.1.0       cuda@11.8.0            ginkgo@1.6.0          kokkos-kernels@4.0.00  mpich@4.1.2             petsc@3.20.1          slepc@3.20.0        umpire@2022.10.0
aml@0.2.1            cusz@0.3.1             globalarrays@5.8.2    kokkos-kernels@4.0.00  mpifileutils@0.11.1     phist@1.12.0          slepc@3.20.0        umpire@2022.10.0
amrex@23.11          darshan-runtime@3.4.4  gmp@6.2.1             lammps@20230802        nccmp@1.9.1.0           plasma@23.8.2         stc@0.9.0           unifyfs@1.1
amrex@23.11          darshan-util@3.4.4     gotcha@1.0.4          lammps@20230802        nco@5.1.6               plumed@2.9.0          strumpack@7.2.0     upcxx@2023.3.0
arborx@1.4.1         datatransferkit@3.1.1  gptune@4.0.0          lbann@0.102            netlib-scalapack@2.2.0  precice@2.5.0         strumpack@7.2.0     upcxx@2023.3.0
arborx@1.4.1         dealii@9.4.2           h5bench@1.4           legion@23.06.0         nrm@0.1.0               pruners-ninja@1.0.1   sundials@6.6.1      variorum@0.7.0
argobots@1.1         dealii@9.4.2           hdf5@1.12.2           legion@23.06.0         nvhpc@23.9              pumi@2.2.8            sundials@6.6.1      veloc@1.7
ascent@0.9.1         dyninst@12.3.0         hdf5@1.14.3           libcatalyst@2.0.0-rc4  omega-h@9.34.13         py-cinemasci@1.3      superlu@5.3.0       visit@3.3.3
axom@0.8.1           ecp-data-vis-sdk@1.0   hdf5-vol-async@1.7    libnrm@0.1.0           omega-h@9.34.13         py-h5py@3.8.0         superlu-dist@8.1.2  vtk-m@1.9.0
bolt@2.0             ecp-data-vis-sdk@1.0   hdf5-vol-cache@v1.1   libpressio@0.95.1      openfoam@2306           py-jupyterhub@1.4.1   superlu-dist@8.1.2  vtk-m@2.0.0
boost@1.79.0         exago@1.6.0            hdf5-vol-log@1.4.0    libpressio@0.95.1      openmpi@4.1.6           py-libensemble@1.0.0  swig@4.0.2-fortran  wannier90@3.1.0
bricks@2023.08.25    exago@1.6.0            hdf5-vol-log@1.4.0    libquo@1.3.1           openpmd-api@0.15.2      py-petsc4py@3.20.1    sz@2.1.12.5         xyce@7.7.0
bricks@2023.08.25    exaworks@0.1.0         heffte@2.4.0          libunwind@1.6.2        papi@6.0.0.1            py-torch@2.1.0        sz3@3.1.7           zfp@0.5.5
butterflypack@2.4.0  faodel@1.2108.1        heffte@2.4.0          loki@0.1.7             papi@6.0.0.1            py-warpx@23.08        tasmanian@8.0       zfp@0.5.5
cabana@0.6.0         flecsi@2.2.1           hpctoolkit@2023.08.1  magma@2.7.2            papyrus@1.0.2           qthreads@1.18         tasmanian@8.0
cabana@0.6.0         flecsi@2.2.1           hpctoolkit@2023.08.1  mercury@2.3.1          parallel-netcdf@1.12.3  quantum-espresso@7.2  tau@2.33
caliper@2.10.0       flit@2.1.0             hpx@1.9.1             metall@0.25            paraview@5.11.2         raja@2022.10.4        tau@2.33
caliper@2.10.0       flux-core@0.55.0       hpx@1.9.1             mfem@4.6.0             paraview@5.11.2         raja@2022.10.4        trilinos@13.0.1
chai@2022.03.0       flux-core@0.55.0       hypre@2.29.0          mfem@4.6.0             parsec@3.0.2209         rempi@1.1.0           trilinos@14.4.0
==> 171 installed packages
```
