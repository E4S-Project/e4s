# E4S Release 22.11

November 2022 release of E4S

## Files

* `cuda-x86_64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (ppc64le)
* `cuda-aarch64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (aarch64)
* `rocm-x86_64/spack.yaml` -- Model Spack Environment for systems w/ AMD GPUs (x86_64)
* `oneapi-x86_64/spack.yaml` -- Model Spack Environment for systems w/ Intel GPUs (x86_64)

Alongside the Spack environments listed above there are `concretize.log` files which show the exact versions and variants of the concretized environment. This includes both the root specs and the entire set of dependencies needed to build them.

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 22.11 uses Spack branch `e4s-22.11`
* https://github.com/spack/spack
* Branch [e4s-22.11](https://github.com/spack/spack/tree/e4s-22.11)


## Spack Build Cache

* https://cache.e4s.io/22.11 (not intended for web browser access; for use with `spack`)

```
$> spack mirror add E4S https://cache.e4s.io/22.11

$> spack buildcache keys -it
==> Fetching https://cache.e4s.io/22.11/build_cache/_pgp/25645FA2B218FE55B4EF649E4345F04B40005581.pub
gpg: key 4345F04B40005581: public key "University of Oregon - E4S" imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg: inserting ownertrust of 6
```

## Model Environments

* For NVIDIA GPUs on x86_64 refer to:
  * `cuda-x86_64/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.1.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2022-11-01`

* For NVIDIA GPUs on ppc64le refer to:
  * `cuda-ppc64le/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-ppc64le:2022-11-01`

* For NVIDIA GPUs on aarch64 refer to:
  * `cuda-aarch64/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.1.0`
    * `ecpe4s/ubuntu20.04-runner-aarch64:2022-11-01`

* For AMD GPUs refer to:
  * `rocm-x86_64/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.1.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2022-11-01`

* For OneAPI and Intel GPUs refer to:
  * `oneapi-x86_64/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, OneAPI 2022.1.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64-oneapi:2022-07-01`

## Example output of `spack find`

Here is what `spack find` would show following the installation of the `cuda-x86_64/spack.yaml` model environment.

If you inspect this environment, you will notice it includes `+cuda` specs built for both `cuda_arch=70` (V100) and `cuda_arch=80` (A100).

```
root@d8d252f1a181:/# spack find -x
-- linux-ubuntu20.04-x86_64 / gcc@11.1.0 ------------------------
adios@1.13.1         chai@2022.03.0           h5bench@1.3            mercury@2.1.0           plumed@2.8.0          sundials@6.4.1
adios2@2.8.3         chai@2022.03.0           hdf5-vol-async@1.3     metall@0.21             precice@2.5.0         superlu@5.3.0
adios2@2.8.3         charliecloud@0.29        heffte@2.3.0           mfem@4.5.0              pumi@2.2.7            superlu-dist@8.1.1
alquimia@1.0.10      conduit@0.8.4            heffte@2.3.0           mfem@4.5.0              py-jupyterhub@1.4.1   superlu-dist@8.1.1
aml@0.2.0            cusz@0.3                 heffte@2.3.0           mfem@4.5.0              py-libensemble@0.9.3  superlu-dist@8.1.1
amrex@22.11          cusz@0.3                 hpctoolkit@2022.10.01  mpark-variant@1.4.0     py-petsc4py@3.18.1    swig@4.0.2
amrex@22.11          datatransferkit@3.1-rc3  hpctoolkit@2022.10.01  mpifileutils@0.11.1     py-warpx@22.10        swig@4.0.2-fortran
amrex@22.11          dealii@9.4.0             hpx@1.8.1              nccmp@1.9.0.1           py-warpx@22.10        tasmanian@7.9
arborx@1.3           dealii@9.4.0             hpx@1.8.1              nco@5.0.1               py-warpx@22.10        tasmanian@7.9
arborx@1.3           dyninst@12.2.0           hpx@1.8.1              netlib-scalapack@2.2.0  qthreads@1.16         tasmanian@7.9
arborx@1.3           ecp-data-vis-sdk@1.0     hypre@2.26.0           nrm@0.1.0               quantum-espresso@7.1  tau@2.32
archer@2.0.0         exaworks@0.1.0           hypre@2.26.0           nvhpc@22.9              raja@2022.03.0        tau@2.32
argobots@1.1         flecsi@1.4.2             hypre@2.26.0           omega-h@9.34.13         raja@2022.03.0        trilinos@13.0.1
ascent@0.8.0         flecsi@2.1.0             kokkos@3.7.00          omega-h@9.34.13         raja@2022.03.0        trilinos@13.4.0
ascent@0.8.0         flecsi@2.1.0             kokkos@3.7.00          omega-h@9.34.13         scr@3.0.1             trilinos@13.4.0
axom@0.7.0           flit@2.1.0               kokkos@3.7.00          openmpi@4.1.4           slate@2022.07.00      turbine@1.3.0
bolt@2.0             flux-core@0.44.0         kokkos-kernels@3.7.00  openpmd-api@0.14.5      slate@2022.07.00      umap@2.1.0
bricks@r0.1          flux-core@0.44.0         kokkos-kernels@3.7.00  papi@6.0.0.1            slate@2022.07.00      umpire@2022.03.1
bricks@r0.1          fortrilinos@2.1.0        kokkos-kernels@3.7.00  papi@6.0.0.1            slepc@3.18.1          umpire@2022.03.1
butterflypack@2.2.2  gasnet@2022.9.0          lammps@20220623        papyrus@1.0.2           slepc@3.18.1          umpire@2022.03.1
cabana@0.5.0         ginkgo@1.4.0             legion@21.03.0         parsec@3.0.2209         slepc@3.18.1          upcxx@2022.9.0
cabana@0.5.0         ginkgo@1.4.0             libnrm@0.1.0           pdt@3.25.1              stc@0.9.0             variorum@0.6.0
cabana@0.5.0         ginkgo@1.4.0             libpressio@0.88.0      petsc@3.18.1            strumpack@7.0.1       vtk-m@1.9.0
caliper@2.8.0        globalarrays@5.8         libquo@1.3.1           petsc@3.18.1            strumpack@7.0.1       vtk-m@1.9.0
caliper@2.8.0        gmp@6.2.1                libunwind@1.6.2        petsc@3.18.1            strumpack@7.0.1       wannier90@3.1.0
caliper@2.8.0        gotcha@1.0.4             magma@2.6.2            phist@1.11.2            sundials@6.4.1        zfp@0.5.5
chai@2022.03.0       gptune@3.0.0             magma@2.6.2            plasma@22.9.29          sundials@6.4.1        zfp@0.5.5
==> 162 installed packages
```
