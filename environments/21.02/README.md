# E4S Release 21.02

February 2021 release of E4S (21.02)

## Files

* `spack-commit-ref.txt` -- Spack commit reference
* `spack.yaml` -- Spack Environment containing `packages:` and `specs:`
  - `packages:` version preferences for non-root specs
  - `specs:` version-pinned root specs comprising this release of E4S
  
*Packages in E4S but not available in versioned form are commented out*

## Spack

E4S 21.02 is based on Spack tag `e4s-21.02`
* https://github.com/spack/spack
* Tag: [e4s-21.02](https://github.com/spack/spack/releases/tag/e4s-21.02) 

## Packages

| Package         | Version   | Group     |
|-----------------|-----------|-----------|
| adios           | 1.13.1    | data+viz  |
| adios2          | 2.7.1     | data+viz  |
| aml             | 0.1.0     | pmr core  |
| amrex           | 21.02     |           |
| arborx          | 0.9-beta  | math      |
| argobots        | 1.0       |           |
| ascent          | 0.6.0     | data+viz  |
| axom            | 0.4.0     |           |
| bolt            | 2.0       | dev tools |
| caliper         | 2.5.0     | dev tools |
| darshan-runtime | 3.2.1     | data+viz  |
| darshan-util    | 3.2.1     | data+viz  |
| dyninst         | 10.2.1    | dev tools |
| faodel          | 1.1906.1  | data+viz  |
| flecsi          | 1.4       | math      |
| flit            | 2.1.0     | dev tools |
| fortrilinos     | 2.0.0     | math      |
| gasnet          | 2020.3.0  | pmr core  |
| ginkgo          | 1.3.0     | math      |
| globalarrays    | 5.8       |           |
| gotcha          | 1.0.3     | dev tools |
| hdf5            | 1.10.7    | data+viz  |
| hpctoolkit      | 2020.08.3 | dev tools |
| hpx             | 1.6.0     |           |
| hypre           | 2.20.0    | math      |
| kokkos          | 3.2.00    | pmr core  |
| kokkos-kernels  | 3.2.00    | pmr core  |
| legion          | 20.03.0   | pmr core  |
| libnrm          | 0.1.0     | pmr core  |
| libquo          | 1.3.1     | dev tools |
| magma           | 2.5.4     | math      |
| mercury         | 2.0.0     | data+viz  |
| mfem            | 4.2.0     | math      |
| mpifileutils    | 0.10.1    | dev tools |
| ninja           | 1.10.2    | dev tools |
| omega-h         | 9.32.5    | math      |
| openmpi         | 4.0.5     | pmr core  |
| openpmd-api     | 0.13.2    |           |
| papi            | 6.0.0.1   | dev tools |
| papyrus         | 1.0.1     | dev tools |
| parallel-netcdf | 1.12.1    | data+viz  |
| pdt             | 3.25.1    |           |
| petsc           | 3.14.4    | math      |
| phist           | 1.9.3     | math      |
| plasma          | 20.9.20   | math      |
| precice         | 2.2.0     | math      |
| pumi            | 2.2.5     | math      |
| py-jupyterhub   | 1.0.0     | dev tools |
| py-libensemble  | 0.7.1     | math      |
| py-petsc4py     | 3.14.1    | math      |
| qthreads        | 1.16      | pmr core  |
| raja            | 0.13.0    | pmr core  |
| rempi           | 1.1.0     | dev tools |
| scr             | 2.0.0     | data+viz  |
| slate           | 2020.10.0 | math      |
| slepc           | 3.14.2    | data+viz  |
| stc             | 0.8.3     |           |
| strumpack       | 5.1.1     | math      |
| sundials        | 5.7.0     | math      |
| superlu         | 5.2.1     | math      |
| superlu-dist    | 6.4.0     | math      |
| swig            | 4.0.2-f   |           |
| sz              | 2.1.11.1  | data+viz  |
| tasmanian       | 7.3       | math      |
| tau             | 2.30.1    | dev tools |
| trilinos        | 13.0.1    | math      |
| turbine         | 1.2.3     |           |
| umap            | 2.1.0     | pmr core  |
| umpire          | 4.1.2     | pmr core  |
| unifyfs         | 0.9.1     | data+viz  |
| upcxx           | 2020.10.0 | pmr core  |
| veloc           | 1.4       | data+viz  |
| zfp             | 0.5.5     | data+viz  |
|                 |           |           |
| llvm-doe        | doe       | dev tools |