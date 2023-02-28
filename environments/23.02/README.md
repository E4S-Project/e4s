# E4S Release 23.02

February 2023 release of E4S

## Files

* `cuda-x86_64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (ppc64le)
* `cuda-aarch64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (aarch64)
* `rocm-x86_64/spack.yaml` -- Model Spack Environment for systems w/ AMD GPUs (x86_64)

Alongside the Spack environments listed above there are `concretize.log` files which show the exact versions and variants of the concretized environment. This includes both the root specs and the entire set of dependencies needed to build them.

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 23.02 uses Spack branch `e4s-23.02`
* https://github.com/spack/spack
* Branch [e4s-23.02](https://github.com/spack/spack/tree/e4s-23.02)


## Spack Build Cache

* https://cache.e4s.io/23.02 (not intended for web browser access; for use with `spack`)

```
$> spack mirror add E4S https://cache.e4s.io/23.02

$> spack buildcache keys -it
==> Fetching https://cache.e4s.io/23.02/build_cache/_pgp/25645FA2B218FE55B4EF649E4345F04B40005581.pub
gpg: key 4345F04B40005581: public key "University of Oregon - E4S" imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg: inserting ownertrust of 6
```

## Model Environments

* Model environment for NVIDIA GPUs on x86_64 is:
  * `cuda-x86_64/spack.yaml`
  * For `cuda_arch=80` and `cuda_arch=90`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.1.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2023-01-01`

* Model environment for NVIDIA GPUs on ppc64le is:
  * `cuda-ppc64le/spack.yaml`
  * For `cuda_arch=70`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-ppc64le:2023-01-01`

* Model environment for NVIDIA GPUs on aarch64 is:
  * `cuda-aarch64/spack.yaml`
  * For `cuda_arch=75` and `cuda_arch=80`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.1.0`
    * `ecpe4s/ubuntu20.04-runner-aarch64:2023-02-01`

* Model environment for AMD GPUs on x86_64 is:
  * `rocm-x86_64/spack.yaml`
  * For `amdgpu_target=gfx908` and `amdgpu_target=gfx90a`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.1.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2023-01-01`

## Example output of `spack find`

Here is what `spack find` would show following the installation of the `cuda-x86_64/spack.yaml` model environment.

If you inspect this environment, you will notice it includes `+cuda` specs built for both `cuda_arch=80` (A100) and `cuda_arch=90` (H100).

```
root@d8d252f1a181:/# spack find -x
-- linux-ubuntu20.04-x86_64 / gcc@11.1.0 ------------------------
adios@1.13.1         cabana@0.5.0             ecp-data-vis-sdk@1.0  gptune@3.0.0           kokkos-kernels@3.7.00  nccmp@1.9.0.1           petsc@3.18.3          qthreads@1.16         sundials@6.4.1      umap@2.1.0
adios2@2.8.3         cabana@0.5.0             exaworks@0.1.0        h5bench@1.3            kokkos-kernels@3.7.00  nco@5.0.6               petsc@3.18.3          quantum-espresso@7.1  sundials@6.4.1      umpire@2022.03.1
alquimia@1.0.10      caliper@2.9.0            faodel@1.2108.1       hdf5@1.12.2            lammps@20221103        netlib-scalapack@2.2.0  petsc@3.18.3          raja@2022.03.0        superlu@5.3.0       umpire@2022.03.1
aml@0.2.0            caliper@2.9.0            flecsi@1.4.2          hdf5-vol-async@1.4     legion@21.03.0         nrm@0.1.0               phist@1.11.2          raja@2022.03.0        superlu-dist@8.1.2  umpire@2022.03.1
amrex@23.02          caliper@2.9.0            flecsi@2.1.0          heffte@2.3.0           libcatalyst@2.0.0-rc3  nvhpc@23.1              plasma@22.9.29        raja@2022.03.0        superlu-dist@8.1.2  unifyfs@1.0.1
amrex@23.02          chai@2022.03.0           flecsi@2.1.0          heffte@2.3.0           libnrm@0.1.0           omega-h@9.34.13         plumed@2.8.1          scr@3.0.1             superlu-dist@8.1.2  upcxx@2022.9.0
arborx@1.3           chai@2022.03.0           flit@2.1.0            heffte@2.3.0           libpressio@0.90.2      omega-h@9.34.13         precice@2.5.0         slate@2022.07.00      swig@4.0.2-fortran  variorum@0.6.0
arborx@1.3           chai@2022.03.0           flux-core@0.47.0      hpctoolkit@2022.10.01  libquo@1.3.1           omega-h@9.34.13         pumi@2.2.7            slate@2022.07.00      swig@4.1.1          veloc@1.6
archer@2.0.0         charliecloud@0.30        flux-core@0.47.0      hpctoolkit@2022.10.01  libunwind@1.6.2        openmpi@4.1.4           py-cinemasci@1.3      slate@2022.07.00      sz@2.1.12.2         visit@3.2.2
argobots@1.1         conduit@0.8.6            fortrilinos@2.2.0     hpx@1.8.1              magma@2.7.0            openpmd-api@0.14.5      py-jupyterhub@1.4.1   slepc@3.18.2          tasmanian@7.9       vtk-m@1.7.1
ascent@0.8.0         darshan-runtime@3.4.2    gasnet@2022.9.2       hpx@1.8.1              mercury@2.2.0          papi@6.0.0.1            py-libensemble@0.9.3  slepc@3.18.2          tasmanian@7.9       wannier90@3.1.0
ascent@0.8.0         darshan-util@3.4.2       ginkgo@1.5.0          hpx@1.8.1              metall@0.23.1          papi@6.0.0.1            py-petsc4py@3.18.3    slepc@3.18.2          tasmanian@7.9       zfp@0.5.5
axom@0.7.0           datatransferkit@3.1-rc3  ginkgo@1.5.0          hypre@2.27.0           mfem@4.5.0             papyrus@1.0.2           py-torch@1.13.1       stc@0.9.0             tau@2.32
bolt@2.0             dealii@9.4.0             ginkgo@1.5.0          hypre@2.27.0           mfem@4.5.0             parallel-netcdf@1.12.3  py-torch@1.13.1       strumpack@7.0.1       tau@2.32
bricks@r0.1          dealii@9.4.0             globalarrays@5.8      hypre@2.27.0           mfem@4.5.0             paraview@5.11.0         py-warpx@23.01        strumpack@7.0.1       trilinos@13.0.1
bricks@r0.1          dyninst@12.2.1           gmp@6.2.1             kokkos@3.7.01          mpark-variant@1.4.0    parsec@3.0.2209         py-warpx@23.01        strumpack@7.0.1       trilinos@13.4.1
butterflypack@2.2.2  ecp-data-vis-sdk@1.0     gotcha@1.0.4          kokkos@3.7.01          mpifileutils@0.11.1    pdt@3.25.1              py-warpx@23.01        sundials@6.4.1        turbine@1.3.0
==> 165 installed packages
```
