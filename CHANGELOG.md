CHANGELOG
=========

v22.05 (May, 2022)
----------------------

- Using Spack branch [e4s-22.05](https://github.com/spack/spack/tree/e4s-22.05) based on Spack v0.18.0-dev
  - `Sun May 15 06:59:11 2022 -0400`
- Package added to E4S: `bricks` and `bricks +cuda`
- Replace `ninja` with `pruners-ninja`
- Release separate environments for NVIDIA, ROCm, and Intel GPU

v21.11 (Nov, 2021)
----------------------

- Using Spack branch [e4s-21.11](https://github.com/spack/spack/tree/e4s-21.11) based on Spack v0.17.0
  - `spack@v0.17.0`
  - `Fri Nov 5 17:11:18 2021 -0700`

- Packages added:
  - `alquimia`
  - `butterflypack`
  - `catalyst`
  - `py-cinemasci`

- Using Spack 0.17.0's new ASP-based concretizer, `clingo`

- Updated `packages:` preferences in environment
  - Removed unnecessary package preferences
  - Allow concretizer to select latest versions
  - Prefer `cuda@11.4.2` for x86_64 model environment
  - Prefer `cuda@11.0.2` for ppc64le model environment

- CUDA compute capability
  - x86_64: build for `cuda_arch=80` (A100)
  - ppc64le: build for `cuda_arch=70` (V100)

- AMD: building for `gfx908` (MI100)

- Enabled additional `+cuda` variants
  - `flecsi +cuda`
  - `heffte +cuda`
  - `petsc +cuda`
  - `slepc +cuda`
  - `trilinos +cuda` (introduced via newly-released `trilinos@13.2.0`
  - `upcxx +cuda` (introduced via newly-released `upcxx@2021.9.0`)
  - `vtk-m +cuda`

- Enabled additional `+rocm` variants
  - `amrex +rocm`
  - `ginkgo +rocm`
  - `heffte +rocm`
  - `magma +rocm`
  - `mfem +rocm`
  - `slate +rocm`
  - `strumpack +rocm`

- Uses `ROCM 4.3.1` stack

For more details see [E4S 21.11 release notes](https://www.dropbox.com/s/pfqefakku4f76zb/E4S_21.11.pptx)

v21.08 (Aug, 2021)
----------------------

- Using Spack branch [e4s-21.08](https://github.com/spack/spack/tree/e4s-21.08)
  - `spack@develop`
  - Branched from commit [f444303ce5c1fd274192dbc10e6783ddd601e0bd](https://github.com/spack/spack/commit/f444303ce5c1fd274192dbc10e6783ddd601e0bd)
  - `Tue Aug 17 16:19:31 2021 +0200`

- Packages added:
  - `charliecloud`
  - `datatransferkit`
  - `flit`
  - `flux-core`
  - `geopm`
  - `nvhpc`
  - `PaRSEC` (+cuda and ~cuda)
  - `phist`
  - `veloc`
  - `vtk-m`

- Packages commented out due to build issues:
  - `STRUMPACK +rocm` ([Issue #25433](https://github.com/spack/spack/issues/25433))

- `HDF5 1.12.0` is being used by a number of packages that were previously using HDF 1.10.7
- `OpenBLAS 0.3.17` is now the preferred BLAS provider where previously it was version 0.3.10
- `Trilinos` is being used with most variants turned on, thereby requiring only a single install of trilinos where previously three were required to satisfy the environment's concretization
