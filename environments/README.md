# E4S Release 25.06

June 2025 release of E4S

## Files

* `amd64-gcc-cpu-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems without GPU (amd64)
* `amd64-gcc-cuda-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (amd64)
* `amd64-gcc-rocm-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with AMD GPUs (amd64)
* `amd64-oneapi-ubuntu22.04/spack.yaml` -- Model Spack Environment for systems with Intel GPUs (amd64)
* `arm64-gcc-cpu-ubuntu24.04/spack.yaml` -- Model Spack Environment for systems without GPU (arm64)
* `arm64-gcc-cuda-ubuntu24.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (arm64)
* `ppc64le-gcc-cpu-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems without GPUs (ppc64le)
* `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml` -- Model Spack Environment for systems with NVIDIA GPUs (ppc64le)

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 25.06 uses Spack branch `e4s-25.06`
* https://github.com/spack/spack
* Branch [e4s-25.06](https://github.com/spack/spack/tree/e4s-25.06)


## Spack Build Cache

* https://cache.e4s.io/25.06 (not intended for web browser access; for use as a `spack mirror`)

```
$> spack mirror add E4S https://cache.e4s.io/25.06

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
  * For `cuda_arch=80`, `cuda_arch=90`, `cuda_arch=120`
  * Built and tested using:
    * `Ubuntu 22.04, GCC 11.4.0, CUDA 12.8.0, 11.8.0`
    * `ecpe4s/e4s-release-base-cuda-amd64:25.06`

* Model environment for NVIDIA GPUs on arm64 is:
  * `arm64-gcc-cuda-ubuntu24.04/spack.yaml`
  * For `cuda_arch=75`, `cuda_arch=80`, `cuda_arch=90`
  * Built and tested using:
    * `Ubuntu 24.04, GCC 13.3.0, CUDA 12.8.0`
    * `ecpe4s/e4s-release-base-cuda-arm64:25.06`

* Model environment for AMD GPUs on x86_64 is:
  * `amd64-gcc-rocm-ubuntu22.04/spack.yaml`
  * For `amdgpu_target=gfx908`, `amdgpu_target=gfx90a`, `amdgpu_target=gfx942`
  * Built and tested using:
    * `Ubuntu 22.04, GCC 11.4.0, ROCm 6.3.3`
    * `ecpe4s/e4s-release-base-rocm-amd64:25.06`

* Model environment for Intel GPUs on x86_64 is:
  * `amd64-oneapi-ubuntu22.04/spack.yaml`
  * Built and tested using:
    * `Ubuntu 22.04, OneAPI 2025.1.0`
    * `ecpe4s/e4s-release-base-oneapi-amd64:25.06`

* Model environment for NVIDIA GPUs on ppc64le is:
  * `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml`
  * For `cuda_arch=70`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0, CUDA 11.4.4`
    * `ecpe4s/e4s-release-base-cuda-ppc64:25.06`

## Example output of `spack find`

Here is what `spack find -x` would show following the installation of the `amd64-gcc-{cpu,cuda}-ubuntu22.04/spack.yaml` with the `cuda_arch=90` specs enabled.

```
$> spack find -x
-- linux-ubuntu22.04-x86_64_v3 / gcc@11.4.0 ---------------------
adios@1.13.1         charliecloud@0.38         globalarrays@5.8.2     lammps@20240829.1    netcdf-fortran@4.6.1    py-libensemble@1.4.3    tau@2.34.1
adios2@2.10.2        conduit@0.9.3             glvis@4.2              lammps@20240829.1    netlib-scalapack@2.2.2  py-petsc4py@3.22.4      tau@2.34.1
alquimia@1.1.0       cp2k@2025.1               gmp@6.3.0              lbann@0.104          nrm@0.1.0               qthreads@1.18           trilinos@16.1.0
aml@0.2.1            cp2k@2025.1               gotcha@1.0.7           legion@24.12.0       nwchem@7.2.3            quantum-espresso@7.4.1  trilinos@16.1.0
amrex@25.03          cusz@0.14.0               gptune@4.0.0           legion@24.12.0       omega-h@10.8.6-scorec   raja@2024.07.0          turbine@1.3.0
amrex@25.03          datatransferkit@3.1.1     gromacs@2024.4         libceed@0.12.0       openfoam@2412           raja@2024.07.0          umap@2.1.1
arborx@1.5           dealii@9.6.2              gromacs@2024.4         libceed@0.12.0       openmpi@5.0.6           rempi@1.1.0             umpire@2024.07.0
arborx@1.7           dyninst@13.0.0            h5bench@1.4            libnrm@0.1.0         openpmd-api@0.16.1      scr@3.1.0               umpire@2024.07.0
argobots@1.2         e4s-alc@1.0.2             hdf5-vol-async@1.7     libquo@1.4           papi@7.1.0              slate@2024.10.29        upcxx@2023.9.0
axom@0.10.1          e4s-cl@1.0.4              hdf5-vol-cache@v1.1    libunwind@1.8.1      papi@7.1.0              slate@2024.10.29        upcxx@2023.9.0
axom@0.10.1          exago@1.6.0               hdf5-vol-log@1.4.0     loki@0.1.7           papyrus@1.0.2           slepc@3.22.2            variorum@0.8.0
bolt@2.0             exaworks@0.1.0            heffte@2.4.1           magma@2.9.0          parsec@3.0.2209         slepc@3.22.2            vtk-m@2.2.0
boost@1.87.0         fftx@1.2.0                heffte@2.4.1           mercury@2.4.0        parsec@3.0.2209         stc@0.9.0               wannier90@3.1.0
bricks@2023.08.25    fftx@1.2.0                hpctoolkit@2024.01.1   metall@0.30          pdt@3.25.2              strumpack@8.0.0         warpx@25.03
bricks@2023.08.25    flecsi@2.3.2              hpctoolkit@2024.01.1   mfem@4.7.0           petsc@3.22.4            strumpack@8.0.0         wps@4.5
butterflypack@3.2.0  flecsi@2.3.2              hpx@1.10.0             mfem@4.7.0           petsc@3.22.4            sundials@7.2.1          wrf@4.6.1
cabana@0.7.0         flit@2.1.0                hpx@1.10.0             mgard@2023-12-09     phist@1.12.1            sundials@7.2.1          xyce@7.8.0
cabana@0.7.0         flux-core@0.67.0          hypre@2.32.0           mgard@2023-12-09     plasma@24.8.7           superlu@7.0.0           zfp@1.0.0
caliper@2.12.1       flux-core@0.67.0          hypre@2.32.0           mpark-variant@1.4.0  plumed@2.9.2            superlu-dist@9.1.0
caliper@2.12.1       fortrilinos@2.3.0         kokkos@4.6.01          mpifileutils@0.12    precice@3.1.2           superlu-dist@9.1.0
chai@2024.07.0       fpm@0.10.0                kokkos@4.6.01          nccmp@1.9.1.0        pruners-ninja@1.0.1     swig@4.0.2-fortran
chai@2024.07.0       gasnet@2025.2.0-snapshot  kokkos-kernels@4.6.01  nco@5.3.2            pumi@2.2.9              sz3@3.2.0
chapel@2.4.0         ginkgo@1.9.0              kokkos-kernels@4.6.01  nek5000@19.0         py-h5py@3.12.1          tasmanian@8.1
chapel@2.4.0         ginkgo@1.9.0              laghos@3.1             nekbone@17.0         py-jupyterhub@1.4.1     tasmanian@8.1
==> 162 installed packages
```
