## E4S October 2020 Release

| Package         | Version   | SW Group  |
|-----------------|-----------|-----------|
| adios           | 1.13.1    | data+viz  |
| adios2          | 2.6.0     | data+viz  |
| aml             | 0.1.0     | pmr core  |
| arborx          | 0.9-beta  | math      |
| axom            | 0.3.3     |           |
| bolt            | 1.0       | dev tools |
| caliper         | 2.4.0     | dev tools |
| darshan-runtime | 3.2.1     | data+viz  |
| darshan-util    | 3.2.1     | data+viz  |
| dyninst         | 10.2.1    | dev tools |
| faodel          | 1.1906.1  | data+viz  |
| flecsi          | 1         | math      |
| flit            | 2.1.0     | dev tools |
| gasnet          | 2020.3.0  | pmr core  |
| ginkgo          | 1.2.0     | math      |
| globalarrays    | 5.7       |           |
| gotcha          | 1.0.3     | dev tools |
| hdf5            | 1.10.6    | data+viz  |
| hpctoolkit      | 2020.08.3 | dev tools |
| hpx             | 1.5.1     |           |
| hypre           | 2.20.0    | math      |
| kokkos          | 3.2.00    | pmr core  |
| kokkos-kernels  | 3.2.00    | pmr core  |
| legion          | 20.03.0   | pmr core  |
| libnrm          | 0.1.0     | pmr core  |
| libquo          | 1.3.1     | dev tools |
| magma           | 2.5.3     | math      |
| mercury         | 1.0.1     | data+viz  |
| mfem            | 4.1.0     | math      |
| ninja           | 1.10.1    | dev tools |
| omega-h         | 9.29.0    | math      |
| openmpi         | 3.1.6     | pmr core  |
| openpmd-api     | 0.12.0    |           |
| papi            | 6.0.0.1   | dev tools |
| parallel-netcdf | 1.12.1    | data+viz  |
| pdt             | 3.25.1    |           |
| petsc           | 3.14.0    | math      |
| phist           | 1.9.1     | math      |
| plasma          | 20.9.20   | math      |
| precice         | 2.1.0     | math      |
| pumi            | 2.2.2     | math      |
| py-jupyterhub   | 1.0.0     | dev tools |
| py-libensemble  | 0.7.0     | math      |
| py-petsc4py     | 3.13.0    | math      |
| qthreads        | 1.14      | pmr core  |
| raja            | 0.12.1    | pmr core  |
| rempi           | 1.1.0     | dev tools |
| scr             | 2.0.0     | data+viz  |
| slepc           | 3.14.0    | data+viz  |
| stc             | 0.8.3     |           |
| strumpack       | 4.0.0     | math      |
| sundials        | 5.4.0     | math      |
| superlu         | 5.2.1     | math      |
| superlu-dist    | 6.3.1     | math      |
| swig            | 4.0.2     | math      |
| sz              | 2.1.10    | data+viz  |
| tasmanian       | 7.3       | math      |
| tau             | 2.29      | dev tools |
| trilinos        | 13.0.0    | math      |
| turbine         | 1.2.3     |           |
| umap            | 2.1.0     | pmr core  |
| umpire          | 4.0.1     | pmr core  |
| unifyfs         | 0.9.0     | data+viz  |
| upcxx           | 2020.3.0  | pmr core  |
| veloc           | 1.4       | data+viz  |
| zfp             | 0.5.5     | data+viz  |
|                 |           |           |
| ascent          | develop   | data+viz  |
| mpifileutils    | develop   | dev tools |
| papyrus         | develop   | dev tools |
| slate           | develop   | math      |
|                 |           |           |
### Etc
The file `spack-packages.txt` contains a list of Spack packages that are in E4S. Most of the packages contained therein are known to build using default variant concretizations on `x86_64` and `ppc64le`, and are built regularly as part of CI. Due to the plethora of variants available for each package, as well as the diversity of systems which may be targetted, we are not able to guarantee that all variants of these packages build on all target systems.

Most, if not all, of these packages are listed on the [E4S Product Info](https://e4s-project.github.io/Resources/ProductInfo.html) page. Use that page to find links to each product's website.

Known build issues should be posted to the [Spack GitHub Issues](https://github.com/spack/spack/issues) page.

<b>This package list is not final</b>. It is a work-in-progress and is intended to serve as a starting point for those looking to use Spack to build E4S packages.
