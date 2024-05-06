# E4S Release 24.05

May 2024 release of E4S

## Files

* `amd64-gcc-cpu-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems without GPU (amd64)
* `amd64-gcc-cuda-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (amd64)
* `amd64-gcc-rocm-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with AMD GPUs (amd64)
* `amd64-oneapi-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with Intel GPUs (amd64)
* `arm64-gcc-cpu-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems without GPU (arm64)
* `arm64-gcc-cuda-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (arm64)
* `ppc64le-gcc-cpu-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems without GPUs (ppc64le)
* `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (ppc64le)

Alongside the Spack environments listed above there are `concretize.log` files which show the exact versions and variants of the concretized environment. This includes both the root specs and the entire set of dependencies needed to build them.

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 24.05 uses Spack branch `e4s-24.05`
* https://github.com/spack/spack
* Branch [e4s-24.05](https://github.com/spack/spack/tree/e4s-24.05)


## Spack Build Cache

* https://cache.e4s.io/24.05 (not intended for web browser access; for use as a `spack mirror`)

```
$> spack mirror add E4S https://cache.e4s.io/24.05

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
    * `Ubuntu 22.04, GCC 11.4.0`
    * `ecpe4s/e4s-release-base-cuda-amd64:24.05`

* Model environment for NVIDIA GPUs on ppc64le is:
  * `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml`
  * For `cuda_arch=70`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/e4s-release-base-cuda-ppc64:24.05`

* Model environment for NVIDIA GPUs on arm64 is:
  * `arm64-gcc-cuda-ubuntu22.04/spack.yaml
  * For `cuda_arch=75`, `cuda_arch=80`, `cuda_arch=90`
  * Built and tested using:
    * `Ubuntu 22.04, GCC 11.4.0`
    * `ecpe4s/e4s-release-base-cuda-arm64:24.05`

* Model environment for AMD GPUs on x86_64 is:
  * `amd64-gcc-rocm-ubuntu22.04/spack.yaml`
  * For `amdgpu_target=gfx908` and `amdgpu_target=gfx90a`
  * Built and tested using:
    * `Ubuntu 22.04, GCC 11.4.0`
    * `ecpe4s/e4s-release-base-rocm-amd64:24.05`

* Model environment for Intel GPUs on x86_64 is:
  * `amd64-oneapi-ubuntu22.04/spack.yaml`
  * Built and tested using:
    * `Ubuntu 22.04, OneAPI 2024.0.1`
    * `ecpe4s/e4s-release-base-oneapi-amd64:24.05`
    * Derived from Intel's official `intel/hpckit:2024.0.1-devel-ubuntu22.04` image

## Example output of `spack find`

Here is what `spack find` would show following the installation of the `amd64-gcc-cuda-ubuntu22.04/spack.yaml` with the `cuda_arch=80` specs enabled.

```
root@0741a576c1d4:/# spack find -x
-- linux-ubuntu22.04-x86_64 / gcc@11.4.0 ------------------------
adios@1.13.1         chai@2024.02.0         flit@2.1.0            hpctoolkit@2024.01.1   magma@2.8.0             papi@7.1.0              py-warpx@23.08          tasmanian@8.0
adios2@2.7.1         charliecloud@0.37      flux-core@0.61.2      hpx@1.9.1              mercury@2.3.1           papyrus@1.0.2           qthreads@1.18           tau@2.33.2
adios2@2.10.0        conduit@0.9.1          flux-core@0.61.2      hpx@1.9.1              metall@0.25             parallel-netcdf@1.12.3  quantum-espresso@7.3.1  tau@2.33.2
alquimia@1.1.0       cp2k@2024.1            fortrilinos@2.3.0     hypre@2.31.0           mfem@4.6.0              paraview@5.12.0         raja@2024.02.0          trilinos@13.0.1
aml@0.2.1            cuda@11.8.0            fpm@0.10.0            hypre@2.31.0           mfem@4.6.0              paraview@5.12.0         raja@2024.02.0          trilinos@15.1.1
amrex@24.04          cuda@12.2.0            gasnet@2023.9.0       kokkos@4.3.00          mgard@2023-12-09        parsec@3.0.2209         rempi@1.1.0             trilinos@15.1.1
amrex@24.04          cusz@0.3.1             ginkgo@1.7.0          kokkos@4.3.00          mpark-variant@1.4.0     parsec@3.0.2209         scr@3.0.1               turbine@1.3.0
arborx@1.6           darshan-runtime@3.4.4  ginkgo@1.7.0          kokkos-kernels@4.3.00  mpich@4.1.2             pdt@3.25.2              slate@2023.11.05        umap@2.1.0
arborx@1.6           darshan-util@3.4.4     globalarrays@5.8.2    kokkos-kernels@4.3.00  mpifileutils@0.11.1     petsc@3.21.0            slate@2023.11.05        umpire@2024.02.0
argobots@1.2         datatransferkit@3.1.1  glvis@4.2             laghos@3.1             nccmp@1.9.1.0           petsc@3.21.0            slepc@3.21.0            umpire@2024.02.0
ascent@0.9.2         dealii@9.5.1           gmp@6.2.1             lammps@20230802.3      nco@5.1.9               phist@1.12.0            slepc@3.21.0            unifyfs@2.0
axom@0.9.0           dealii@9.5.1           gotcha@1.0.6          lammps@20230802.3      nek5000@19.0            plasma@23.8.2           stc@0.9.0               upcxx@2023.9.0
axom@0.9.0           dyninst@13.0.0         gptune@4.0.0          lbann@0.104            nekbone@17.0            plumed@2.9.0            strumpack@7.2.0         upcxx@2023.9.0
bolt@2.0             e4s-alc@1.0.1          gromacs@2024.1        lbann@0.104            netcdf-fortran@4.6.1    precice@3.1.1           strumpack@7.2.0         variorum@0.7.0
boost@1.79.0         e4s-cl@1.0.3           gromacs@2024.1        legion@24.03.0         netlib-scalapack@2.2.0  pruners-ninja@1.0.1     sundials@7.0.0          veloc@1.7
bricks@2023.08.25    ecp-data-vis-sdk@1.0   h5bench@1.4           legion@24.03.0         nrm@0.1.0               pumi@2.2.8              sundials@7.0.0          visit@3.3.3
bricks@2023.08.25    ecp-data-vis-sdk@1.0   hdf5@1.12.3           libcatalyst@2.0.0-rc4  nvhpc@24.3              py-cinemasci@1.3        superlu@5.3.0           vtk-m@2.0.0
butterflypack@2.4.0  exago@1.6.0            hdf5-vol-async@1.7    libnrm@0.1.0           omega-h@9.34.13         py-deephyper@0.6.0      superlu-dist@8.2.1      vtk-m@2.1.0
cabana@0.6.0         exago@1.6.0            hdf5-vol-cache@v1.1   libpressio@0.95.1      omega-h@9.34.13         py-h5py@3.11.0          superlu-dist@8.2.1      wannier90@3.1.0
cabana@0.6.0         exaworks@0.1.0         hdf5-vol-log@1.4.0    libpressio@0.95.1      openfoam@2312           py-jupyterhub@1.4.1     swig@4.0.2-fortran      xyce@7.8.0
caliper@2.10.0       faodel@1.2108.1        heffte@2.4.0          libquo@1.4             openmpi@5.0.3           py-libensemble@1.2.2    sz@2.1.12.5             zfp@0.5.5
caliper@2.10.0       flecsi@2.2.1           heffte@2.4.0          libunwind@1.6.2        openpmd-api@0.15.2      py-petsc4py@3.21.0      sz3@3.1.7               zfp@0.5.5
chai@2024.02.0       flecsi@2.2.1           hpctoolkit@2024.01.1  loki@0.1.7             papi@7.1.0              py-torch@2.2.2          tasmanian@8.0
==> 183 installed packages
```
