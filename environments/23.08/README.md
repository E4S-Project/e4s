# E4S Release 23.05

May 2023 release of E4S

## Files

* `cuda-x86_64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (ppc64le)
* `cuda-aarch64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (aarch64)
* `rocm-x86_64/spack.yaml` -- Model Spack Environment for systems w/ AMD GPUs (x86_64)
* `oneapi-x86_64/spack.yaml` -- Model Spack Environment for systems w/ Intel GPUs (x86_64)

Alongside the Spack environments listed above there are `concretize.log` files which show the exact versions and variants of the concretized environment. This includes both the root specs and the entire set of dependencies needed to build them.

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 23.05 uses Spack branch `e4s-23.05`
* https://github.com/spack/spack
* Branch [e4s-23.05](https://github.com/spack/spack/tree/e4s-23.05)


## Spack Build Cache

* https://cache.e4s.io/23.05 (not intended for web browser access; for use as a `spack mirror`)

```
$> spack mirror add E4S https://cache.e4s.io/23.05

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

* Model environment for Intel GPUs on x86_64 is:
  * `oneapi-x86_64/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, OneAPI 2023.1.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64-oneapi:2023-05-10`
    * Derived from Intel's official `intel/oneapi-hpckit:2023.1.0-devel-ubuntu20.04` image

## Example output of `spack find`

Here is what `spack find` would show following the installation of the `cuda-x86_64/spack.yaml` model environment.

If you inspect the `spack.yaml`, you will notice it includes `+cuda` specs built for both `cuda_arch=80` (A100) and `cuda_arch=90` (H100).

```
root@d8d252f1a181:/# spack find -x
-- linux-ubuntu20.04-x86_64 / gcc@11.1.0 ------------------------
adios@1.13.1         caliper@2.9.0            fortrilinos@2.2.0      hypre@2.28.0           mpark-variant@1.4.0     parsec@3.0.2209       raja@2022.10.4      tau@2.32
adios2@2.9.0         caliper@2.9.0            gasnet@2023.3.0        kokkos@4.0.01          mpich@4.1.1             pdt@3.25.1            rempi@1.1.0         tau@2.32
adios2@2.9.0         chai@2022.03.0           ginkgo@1.5.0           kokkos@4.0.01          mpifileutils@0.11.1     petsc@3.19.1          scr@3.0.1           trilinos@13.0.1
alquimia@1.0.10      chai@2022.03.0           ginkgo@1.5.0           kokkos-kernels@3.7.00  nccmp@1.9.0.1           petsc@3.19.1          slate@2022.07.00    trilinos@14.0.0
aml@0.2.0            charliecloud@0.32        globalarrays@5.8.2     kokkos-kernels@3.7.00  nco@5.1.5               phist@1.11.2          slate@2022.07.00    turbine@1.3.0
amrex@23.05          conduit@0.8.7            gmp@6.2.1              lammps@20220623.3      netlib-scalapack@2.2.0  plasma@22.9.29        slepc@3.19.0        umap@2.1.0
amrex@23.05          cusz@0.3                 gotcha@1.0.4           lbann@0.102            nrm@0.1.0               plumed@2.8.2          slepc@3.19.0        umpire@2022.03.1
arborx@1.3           darshan-runtime@3.4.2    gptune@4.0.0           legion@23.03.0         nvhpc@23.3              precice@2.5.0         stc@0.9.0           umpire@2022.03.1
arborx@1.3           darshan-util@3.4.2       h5bench@1.3            libcatalyst@2.0.0-rc3  omega-h@9.34.13         pumi@2.2.7            strumpack@7.1.1     unifyfs@1.0.1
archer@2.0.0         datatransferkit@3.1-rc3  hdf5@1.12.2            libnrm@0.1.0           omega-h@9.34.13         py-cinemasci@1.3      strumpack@7.1.1     upcxx@2023.3.0
argobots@1.1         dyninst@12.3.0           hdf5-vol-async@1.5     libpressio@0.95.1      openfoam@2206           py-h5py@3.7.0         sundials@6.5.1      variorum@0.6.0
ascent@0.9.1         ecp-data-vis-sdk@1.0     hdf5-vol-cache@v1.1    libquo@1.3.1           openmpi@4.1.5           py-jupyterhub@1.4.1   sundials@6.5.1      veloc@1.6
axom@0.7.0           ecp-data-vis-sdk@1.0     hdf5-vol-log@1.4.0     libunwind@1.6.2        openpmd-api@0.15.1      py-libensemble@0.9.3  superlu@5.3.0       visit@3.3.3
bolt@2.0             exaworks@0.1.0           heffte@2.3.0           loki@0.1.7             papi@6.0.0.1            py-petsc4py@3.19.1    superlu-dist@8.1.2  vtk-m@1.9.0
boost@1.79.0         faodel@1.2108.1          heffte@2.3.0           magma@2.7.1            papi@6.0.0.1            py-warpx@23.03        superlu-dist@8.1.2  vtk-m@2.0.0
bricks@r0.1          flecsi@2.1.0             hpctoolkit@2023.03.01  mercury@2.2.0          papyrus@1.0.2           py-warpx@23.03        swig@4.0.2-fortran  wannier90@3.1.0
bricks@r0.1          flecsi@2.1.0             hpctoolkit@2023.03.01  metall@0.25            parallel-netcdf@1.12.3  py-warpx@23.03        sz@2.1.12.2         xyce@7.6.0
butterflypack@2.2.2  flit@2.1.0               hpx@1.9.0              mfem@4.5.2             paraview@5.11.1         qthreads@1.16         sz3@3.1.7           zfp@0.5.5
cabana@0.5.0         flux-core@0.49.0         hpx@1.9.0              mgard@2023-03-31       paraview@5.11.1         quantum-espresso@7.1  tasmanian@7.9       zfp@0.5.5
cabana@0.5.0         flux-core@0.49.0         hypre@2.28.0           mgard@2023-03-31       parsec@3.0.2209         raja@2022.10.4        tasmanian@7.9
==> 159 installed packages
```
