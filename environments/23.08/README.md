# E4S Release 23.08

August 2023 release of E4S

## Files

* `cuda-x86_64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (ppc64le)
* `cuda-aarch64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (aarch64)
* `rocm-x86_64/spack.yaml` -- Model Spack Environment for systems w/ AMD GPUs (x86_64)
* `oneapi-x86_64/spack.yaml` -- Model Spack Environment for systems w/ Intel GPUs (x86_64)

Alongside the Spack environments listed above there are `concretize.log` files which show the exact versions and variants of the concretized environment. This includes both the root specs and the entire set of dependencies needed to build them.

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 23.08 uses Spack branch `e4s-23.08`
* https://github.com/spack/spack
* Branch [e4s-23.08](https://github.com/spack/spack/tree/e4s-23.08)


## Spack Build Cache

* https://cache.e4s.io/23.08 (not intended for web browser access; for use as a `spack mirror`)

```
$> spack mirror add E4S https://cache.e4s.io/23.08

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


```
root@2cf0ba0183ed:/# spack find -x
-- linux-ubuntu20.04-x86_64 / gcc@11.4.0 ------------------------
adios@1.13.1         caliper@2.10.0           flecsi@2.2.1         heffte@2.3.0           libpressio@0.95.1       nvhpc@23.7              plumed@2.9.0           slepc@3.19.1        turbine@1.3.0
adios2@2.9.1         caliper@2.10.0           flit@2.1.0           hpctoolkit@2023.03.01  libpressio@0.95.1       omega-h@9.34.13         precice@2.5.0          slepc@3.19.1        umap@2.1.0
adios2@2.9.1         chai@2022.03.0           flux-core@0.53.0     hpctoolkit@2023.03.01  libquo@1.3.1            omega-h@9.34.13         pruners-ninja@1.0.1    stc@0.9.0           umpire@2022.03.1
alquimia@1.0.10      chai@2022.03.0           flux-core@0.53.0     hpx@1.9.1              libunwind@1.6.2         openfoam@2306           pumi@2.2.7             strumpack@7.1.3     umpire@2022.03.1
aml@0.2.1            charliecloud@0.33        fortrilinos@2.3.0    hpx@1.9.1              loki@0.1.7              openmpi@4.1.5           py-cinemasci@1.3       strumpack@7.1.3     unifyfs@1.1
amrex@23.08          conduit@0.8.8            gasnet@2023.3.0      hypre@2.29.0           magma@2.7.1             openpmd-api@0.15.1      py-h5py@3.8.0          sundials@6.5.1      upcxx@2023.3.0
amrex@23.08          cuda@11.8.0              ginkgo@1.6.0         hypre@2.29.0           mercury@2.3.0           papi@6.0.0.1            py-jupyterhub@1.4.1    sundials@6.5.1      upcxx@2023.3.0
arborx@1.4.1         cusz@0.3.1               ginkgo@1.6.0         kokkos@4.1.00          metall@0.25             papi@6.0.0.1            py-libensemble@0.10.2  superlu@5.3.0       variorum@0.6.0
arborx@1.4.1         darshan-runtime@3.4.4    globalarrays@5.8.2   kokkos@4.1.00          mfem@4.5.2              papyrus@1.0.2           py-petsc4py@3.19.4     superlu-dist@8.1.2  veloc@1.6
argobots@1.1         darshan-util@3.4.4       gmp@6.2.1            kokkos-kernels@4.0.00  mfem@4.5.2              parallel-netcdf@1.12.3  py-torch@2.0.1         superlu-dist@8.1.2  visit@3.3.3
ascent@0.9.1         datatransferkit@3.1-rc3  gotcha@1.0.4         kokkos-kernels@4.0.00  mgard@2023-03-31        paraview@5.11.1         py-warpx@23.08         swig@4.0.2-fortran  vtk-m@1.9.0
axom@0.7.0           dealii@9.4.2             gptune@4.0.0         lammps@20230802        mgard@2023-03-31        paraview@5.11.1         qthreads@1.18          sz@2.1.12.5         vtk-m@2.0.0
bolt@2.0             dealii@9.4.2             h5bench@1.4          lammps@20230802        mpark-variant@1.4.0     parsec@3.0.2209         quantum-espresso@7.2   sz3@3.1.7           wannier90@3.1.0
boost@1.79.0         dyninst@12.3.0           hdf5@1.12.2          lbann@0.102            mpich@4.1.2             parsec@3.0.2209         raja@2022.10.4         tasmanian@7.9       xyce@7.6.0
bricks@r0.1          ecp-data-vis-sdk@1.0     hdf5@1.12.2          legion@23.06.0         mpifileutils@0.11.1     pdt@3.25.1              raja@2022.10.4         tasmanian@7.9       zfp@0.5.5
bricks@r0.1          ecp-data-vis-sdk@1.0     hdf5-vol-async@1.7   legion@23.06.0         nccmp@1.9.1.0           petsc@3.19.4            rempi@1.1.0            tau@2.32.1          zfp@0.5.5
butterflypack@2.2.2  exaworks@0.1.0           hdf5-vol-cache@v1.1  libcatalyst@2.0.0-rc3  nco@5.1.6               petsc@3.19.4            scr@3.0.1              tau@2.32.1
cabana@0.5.0         faodel@1.2108.1          hdf5-vol-log@1.4.0   libcatalyst@2.0.0-rc3  netlib-scalapack@2.2.0  phist@1.11.2            slate@2022.07.00       trilinos@14.4.0
cabana@0.5.0         flecsi@2.2.1             heffte@2.3.0         libnrm@0.1.0           nrm@0.1.0               plasma@22.9.29          slate@2022.07.00       trilinos@14.4.0
==> 168 installed packages
```
