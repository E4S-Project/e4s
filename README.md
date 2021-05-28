## E4S Release 21.05

May 2021 release of E4S

### Files

* `spack.yaml` -- Model Spack environment
  
*Specs in the Model Spack Environment are commented out if (a) there are outstanding build issues or (b) if they track branches and are not available in versioned form*


### Spack Version

E4S 21.05 uses Spack branch `e4s-21.05`
* https://github.com/spack/spack
* Branch `e4s-21.05`


### Facility Adaptation Examples

* [NERSC Cori - Intel 19.1.3.304](https://github.com/spack/spack-configs/blob/main/UOREGON/E4S-21.05-Facility-Examples/NERSC-Cori/intel-spack.yaml)
* [NERSC Cori - GCC 9.3.0](https://github.com/spack/spack-configs/blob/main/UOREGON/E4S-21.05-Facility-Examples/NERSC-Cori/gcc-spack.yaml)
* [Frank Jupiter - GCC 9.3.0](https://github.com/spack/spack-configs/blob/main/UOREGON/E4S-21.05-Facility-Examples/Frank-Jupiter/spack.yaml)

### Packages

| Package         | Version   | Group     |
|-----------------|-----------|-----------|
| adios           | 1.13.1    | data+viz  |
| adios2          | 2.7.1     | data+viz  |
| aml             | 0.1.0     | pmr core  |
| amrex           | 21.05     |           |
| arborx          | 1.0       | math      |
| archer          | 2.0.0     |           |
| argobots        | 1.1       |           |
| ascent          | 0.7.1     | data+viz  |
| axom            | 0.5.0     |           |
| bolt            | 2.0       | dev tools |
| cabana          | 0.3.0     |           |
| caliper         | 2.5.0     | dev tools |
| chai            | 2.3.0     |           |
| conduit         | 0.7.2     |           |
| darshan-runtime | 3.3.0     | data+viz  |
| darshan-util    | 3.3.0     | data+viz  |
| dyninst         | 11.0.0    | dev tools |
| faodel          | 1.1906.1  | data+viz  |
| flecsi          | 1.4       | math      |
| flit            | 2.1.0     | dev tools |
| fortrilinos     | 2.0.0     | math      |
| gasnet          | 2021.3.0  | pmr core  |
| ginkgo          | 1.3.0     | math      |
| globalarrays    | 5.8       |           |
| gmp             | 6.2.1     |           |
| gotcha          | 1.0.3     | dev tools |
| hdf5            | 1.10.7    | data+viz  |
| heffte          | 2.0.0     |           |
| hpctoolkit      | 2021.03.1 | dev tools |
| hpx             | 1.6.0     |           |
| hypre           | 2.20.0    | math      |
| kokkos          | 3.4.00    | pmr core  |
| kokkos-kernels  | 3.2.00    | pmr core  |
| legion          | 21.03.0   | pmr core  |
| libnrm          | 0.1.0     | pmr core  |
| libquo          | 1.3.1     | dev tools |
| libunwind       | 1.5.0     |           |
| llvm-doe        | doe       | dev tools |
| loki            | 0.1.7     |           |
| magma           | 2.5.4     | math      |
| mercury         | 2.0.1     | data+viz  |
| metall          | 0.13      |           |
| mfem            | 4.2.0     | math      |
| mpark-variant   | 1.4.0     |           |
| mpifileutils    | 0.11      | dev tools |
| ninja           | 1.10.2    | dev tools |
| nrm             | 0.1.0     |           |
| omega-h         | 9.32.5    | math      |
| openmpi         | 4.0.5     | pmr core  |
| openpmd-api     | 0.13.4    |           |
| papi            | 6.0.0.1   | dev tools |
| papyrus         | 1.0.1     | dev tools |
| parallel-netcdf | 1.12.1    | data+viz  |
| pdt             | 3.25.1    |           |
| petsc           | 3.15.0    | math      |
| phist           | 1.9.4     | math      |
| plasma          | 20.9.20   | math      |
| precice         | 2.2.1     | math      |
| pumi            | 2.2.5     | math      |
| py-jupyterhub   | 1.0.0     | dev tools |
| py-libensemble  | 0.7.1     | math      |
| py-petsc4py     | 3.15.0    | math      |
| py-warpx        | 21.05     |           |
| qt              | 5.15.2    |           |
| qthreads        | 1.16      | pmr core  |
| qwt             | 6.1.6     |           |
| raja            | 0.13.0    | pmr core  |
| rempi           | 1.1.0     | dev tools |
| scr             | 3.0rc1    | data+viz  |
| slate           | 2021.05.2 | math      |
| slepc           | 3.15.0    | data+viz  |
| stc             | 0.9.0     |           |
| strumpack       | 5.1.1     | math      |
| sundials        | 5.7.0     | math      |
| superlu         | 5.2.1     | math      |
| superlu-dist    | 6.4.0     | math      |
| swig            | 4.0.2-f   |           |
| sz              | 2.1.11.1  | data+viz  |
| tasmanian       | 7.5       | math      |
| tau             | 2.30.1    | dev tools |
| trilinos        | 13.0.1    | math      |
| turbine         | 1.3.0     |           |
| umap            | 2.1.0     | pmr core  |
| umpire          | 4.1.2     | pmr core  |
| unifyfs         | 0.9.1     | data+viz  |
| upcxx           | 2021.3.0  | pmr core  |
| zfp             | 0.5.5     | data+viz  |
