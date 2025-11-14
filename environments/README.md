# E4S Release 25.11

November 2025 release of E4S

## Files

* `x86_64-gcc-cpu-ubuntu24.04/spack.yaml` -- Spack Environment for Ubuntu systems wo/ GPU (x86_64)
* `x86_64-gcc-cpu-rocky9.6/spack.yaml` -- Spack Environment for Rocky systems wo/ GPU (x86_64)
* `x86_64-gcc-cuda-ubuntu24.04/spack.yaml` -- Spack Environment for Ubuntu systems with NVIDIA GPUs (x86_64)
* `x86_64-gcc-cuda-rocky9.6/spack.yaml` -- Spack Environment for Rocky systems with NVIDIA GPUs (x86_64)
* `x86_64-gcc-rocm-ubuntu24.04/spack.yaml` -- Spack Environment for Ubuntu systems with AMD GPUs (x86_64)
* `x86_64-oneapi-ubuntu24.04/spack.yaml` -- Spack Environment for Ubuntu systems with Intel GPUs (x86_64)
* `aarch64-gcc-cpu-ubuntu24.04/spack.yaml` -- Spack Environment for Ubuntu systems without GPU (aarch64)
* `aarch64-gcc-cpu-rocky9.6/spack.yaml` -- Spack Environment for Rocky systems without GPU (aarch64)
* `aarch64-gcc-cuda-ubuntu24.04/spack.yaml` -- Spack Environment for Ubuntu systems with NVIDIA GPUs (aarch64)
* `aarch64-gcc-cuda-rocky9.6/spack.yaml` -- Spack Environment for Rocky systems with NVIDIA GPUs (aarch64)
* `ppc64le-gcc-cpu-ubuntu20.04/spack.yaml` -- Spack Environment for Ubuntu systems without GPUs (ppc64le)
* `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml` -- Spack Environment for Ubuntu systems with NVIDIA GPUs (ppc64le)

*Specs in the Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 25.11 uses the following versions of Spack Core and Spack Packages
* Spack Core `v1.0.2` (https://github.com/spack/spack)
* Spack Packages tag `e4s-25.11` (https://github.com/spack/spack-packages)


## Spack Build Cache

* https://cache.e4s.io/25.11 (not intended for web browser access; for use as a `spack mirror`)

```
$> spack mirror add E4S https://cache.e4s.io/25.11

$> spack buildcache keys -it
gpg: key 4345F04B40005581: public key "University of Oregon - E4S" imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg: inserting ownertrust of 6

$> spack buildcache list -al
...
```

## Model Environments

* Model environments for NVIDIA GPUs on x86_64 is:
  * `x86_64-gcc-cuda-ubuntu24.04/spack.yaml`
  * For `cuda_arch=80`, `cuda_arch=90`, `cuda_arch=120`
  * Built and tested using:
    * `Ubuntu 24.04, GCC 13.3.0, CUDA 12.9
    * `ecpe4s/e4s-mpi-cuda-x86_64:v4.3.1-v12.9.1-1762471956`

* Model environment for NVIDIA GPUs on aarch64 is:
  * `aarch64-gcc-cuda-ubuntu24.04/spack.yaml`
  * For `cuda_arch=80`, `cuda_arch=90`, `cuda_arch=120`
  * Built and tested using:
    * `Ubuntu 24.04, GCC 13.3.0, CUDA 12.9`
    * `ecpe4s/e4s-mpi-cuda-aarch64:v4.3.1-v12.9.1-1761673584`

* Model environment for AMD GPUs on x86_64 is:
  * `x86_64-gcc-rocm-ubuntu24.04/spack.yaml`
  * For `amdgpu_target=gfx908`, `amdgpu_target=gfx90a`, `amdgpu_target=gfx942`
  * Built and tested using:
    * `Ubuntu 24.04, GCC 13.3.0, ROCm 6.4.3`
    * `ecpe4s/e4s-mpi-rocm-x86_64:v4.3.1-v6.4.3-1762472541`

* Model environment for Intel GPUs on x86_64 is:
  * `x86_64-oneapi-ubuntu24.04/spack.yaml`
  * Built and tested using:
    * `Ubuntu 24.04, OneAPI 2025.2`
    * `ecpe4s/e4s-mpi-oneapi-x86_64:v2025.2-1762472549`

* Model environment for NVIDIA GPUs on ppc64le is:
  * `ppc64le-gcc-cuda-ubuntu20.04/spack.yaml`
  * For `cuda_arch=70`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0, CUDA 11.4`
    * `ecpe4s/e4s-mpi-cuda-ppc64le:v4.3.1-v11.2.2-1761859241`

## Example output of `spack find`

Here is what `spack find -x` would show following the installation of the `x86_64-gcc-cpu-ubuntu24.04/spack.yaml`

```
root@14fbc19def0e:/# spack find -x --no-groups
adios@1.13.1         cp2k@2025.2            gotcha@1.0.8           libcatalyst@2.0.0        nrm@0.1.0               py-h5py@3.14.0        sz3@3.2.0
adios2@2.10.2        darshan-runtime@3.4.7  gptune@4.0.0           libceed@0.12.0           omega-h@10.8.6-scorec   py-jupyterhub@1.4.1   tasmanian@8.1
alquimia@1.1.0       darshan-util@3.4.7     gromacs@2025.3         libnrm@0.1.0             openfoam@2412           py-libensemble@1.5.0  tau@2.35
aml@0.2.1            datatransferkit@3.1.1  h5bench@1.4            libquo@1.4               openmpi@5.0.8           py-petsc4py@3.24.0    trilinos@16.1.0
amrex@25.10          dyninst@13.0.0         hdf5@1.14.6            libunwind@1.8.3          openpmd-api@0.16.1      qthreads@1.18         turbine@1.3.0
arborx@2.0.1         e4s-alc@1.0.3          hdf5-vol-async@1.7     loki@0.1.7               papi@7.2.0              quantum-espresso@7.5  umap@2.1.1
argobots@1.2         e4s-cl@1.0.5           hdf5-vol-cache@v1.1    metall@0.30              papyrus@1.0.2           raja@2025.03.0        umpire@2025.03.0
ascent@0.9.5         exago@1.6.0            hdf5-vol-log@1.4.0     mfem@4.8.0               parallel-netcdf@1.14.1  rempi@1.1.0           upcxx@2023.9.0
axom@0.10.1          faodel@1.2108.1        heffte@2.4.1           mgard@compat-2023-12-09  parsec@4.0.2411         scr@3.1.0             variorum@0.8.0
boost@1.88.0         fftx@1.2.0             hpctoolkit@2025.0.1    mpark-variant@1.4.0      pdt@3.25.2              slate@2025.05.28      veloc@1.7
bricks@2023.08.25    flecsi@2.4.1           hpx@1.11.0             mpich@4.3.1              petsc@3.24.0            slepc@3.24.0          vtk-m@2.3.0
butterflypack@3.2.0  flit@2.1.0             hypre@2.33.0           mpifileutils@0.12        phist@1.12.1            stc@0.9.0             wannier90@3.1.0
cabana@0.7.0         fpm@0.10.0             kokkos@4.7.01          nccmp@1.9.1.0            plasma@24.8.7           strumpack@8.0.0       warpx@25.04
caliper@2.12.1       gasnet@2025.8.0        kokkos-kernels@4.7.01  nco@5.3.4                plumed@2.9.2            sundials@7.5.0        wps@4.5
chai@2025.03.0       ginkgo@1.10.0          laghos@3.1             nek5000@19.0             precice@3.3.0           superlu@7.0.0         wrf@4.6.1
chapel@2.6.0         globalarrays@5.8.2     lammps@20250722        nekbone@17.0             pruners-ninja@1.0.1     superlu-dist@9.1.0    xyce@7.10.0
charliecloud@0.40    glvis@4.4              lbann@0.104            netcdf-fortran@4.6.2     pumi@2.2.9              swig@4.0.2-fortran    zfp@1.0.1
conduit@0.9.5        gmp@6.3.0              legion@25.03.0         netlib-scalapack@2.2.2   py-cinemasci@1.7.0      sz@2.1.12.5
```


