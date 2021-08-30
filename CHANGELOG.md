CHANGELOG
=========

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
