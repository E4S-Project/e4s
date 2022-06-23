E4S Facility Deployments
========================

Perlmutter
----------

**Paratools Deployment**

.. code-block:: console

    $perlmutter> module use /global/cfs/cdirs/m3896/shared/modulefiles/
    $perlmutter> module avail E4S
    ------------------- /global/cfs/cdirs/m3896/shared/modulefiles -----------------
        e4s/22.05/mvapich2    e4s/22.05/PrgEnv-gnu (D)
        

The mvapich2 module provides an E4S deployment with mpi provied by mvapich2. 

.. code-block:: console

    $perlmutter> module load e4s/22.05/mvapich2

    ...

    $perlmutter> module avail
    
    --------------------------------- /global/cfs/cdirs/m3896/shared/ParaTools/E4S/22.05/mvapich2/spack/share/spack/lmod/cray-sles15-x86_64/mvapich2/2.3.6-1-rslz3cc/Core ----------------------------------
    adios/1.13.1                 datatransferkit/3.1-rc3           hpx/1.7.1-cuda80                    nco/5.0.1                     py-cinemasci/1.7.0                    strumpack/6.3.1-openmp
    adios2/2.8.0-cuda80          dyninst/12.1.0-openmp             hpx/1.7.1                    (D)    netlib-scalapack/2.2.0        py-libensemble/0.9.1                  sundials/6.2.0
    adios2/2.8.0          (D)    exaworks/0.1.0                    hypre/2.24.0                        omega-h/9.34.1                py-petsc4py/3.17.1                    superlu-dist/7.2.0
    amrex/22.05                  faodel/1.2108.1                   kokkos-kernels/3.6.00-cuda80        openpmd-api/0.14.4            py-warpx/22.05-dims2                  tasmanian/7.7-openmp
    arborx/1.2                   flecsi/1.4.2                      kokkos/3.6.00-cuda80                papyrus/1.0.2                 py-warpx/22.05-dims3                  tau/2.31
    axom/0.6.1-openmp            fortrilinos/2.0.0                 lammps/20220107-openmp              parallel-netcdf/1.12.2        py-warpx/22.05-dimsRZ          (D)    tau/2.31.1-cuda        (D)
    butterflypack/2.1.1          globalarrays/5.8                  libquo/1.3.1                        parsec/3.0.2012               scr/3.0rc2                            trilinos/13.0.1
    cabana/0.4.0                 hdf5/1.10.7                       mercury/2.1.0                       petsc/3.17.1-cuda80           slate/2021.05.02-cuda80-openmp        turbine/1.3.0
    caliper/2.7.0-cuda80         heffte/2.2.0-cuda80               metall/0.20                         petsc/3.17.1           (D)    slate/2021.05.02-openmp        (D)    unifyfs/0.9.2
    caliper/2.7.0         (D)    heffte/2.2.0               (D)    mfem/4.4.0                          phist/1.9.5-openmp            slepc/3.17.1-cuda80                   veloc/1.5
    conduit/0.8.3                hpctoolkit/2022.04.15-cuda        mpifileutils/0.11.1                 precice/2.4.0                 slepc/3.17.1                   (D)
    darshan-runtime/3.3.1        hpctoolkit/2022.04.15      (D)    nccmp/1.9.0.1                       pumi/2.2.7                    stc/0.9.0
    
    ---------------------------------------------- /global/cfs/cdirs/m3896/shared/ParaTools/E4S/22.05/mvapich2/spack/share/spack/lmod/cray-sles15-x86_64/Core ----------------------------------------------
    aml/0.1.0                 flit/2.1.0                        kokkos-kernels/3.6.00-openmp (D)      nrm/0.1.0              qthreads/1.16                    umpire/6.0.0
    archer/2.0.0              flux-core/0.38.0-cuda             kokkos/3.6.00-openmp         (D)      nvhpc/22.3             raja/0.14.0-cuda80-openmp        zfp/0.5.5-cuda80
    argobots/1.1              flux-core/0.38.0           (D)    legion/21.03.0-cuda80-cuda            openmpi/4.1.3          raja/0.14.0-openmp        (D)    zfp/0.5.5        (D)
    bolt/2.0                  gasnet/2022.3.0                   legion/21.03.0               (D)      papi/6.0.0.1-cuda      superlu/5.3.0
    chai/2.4.0                ginkgo/1.4.0-cuda80-openmp        libunwind/1.6.2                       papi/6.0.0.1           swig/4.0.2-fortran
    charliecloud/0.26         ginkgo/1.4.0-openmp        (D)    magma/2.6.2-cuda80                    pdt/3.25.1             swig/4.0.2                (D)
    cmake/3.23.1       (D)    gmp/6.2.1                         mpark-variant/1.4.0                   plasma/21.8.29         sz/2.1.12
    darshan-util/3.3.1        gotcha/1.0.3                      mvapich2/2.3.6-1             (L,D)    py-jupyterhub/1.4.1    umap/2.1.0
    ...

The PrgEnv-gnu module provides an E4S deployment with mpi provided by the system software environment.

.. code-block:: console

    $perlmutter> module load e4s/22.05/PrgEnv-gnu
    
    ...
    
    $perlmutter> module avail
    
    ...
    
    -------------------------------- /global/cfs/cdirs/m3896/shared/ParaTools/E4S/22.05/PrgEnv-gnu/spack/share/spack/lmod/cray-sles15-x86_64/cray-mpich/8.1.15-royouxy/Core --------------------------------
    adios/1.13.1                   exaworks/0.1.0                      lammps/20220107-openmp        petsc/3.17.1                   (D)    strumpack/6.3.1-cuda80-openmp
    adios2/2.8.0-cuda80            faodel/1.2108.1                     libquo/1.3.1                  phist/1.9.5-openmp                    strumpack/6.3.1-openmp        (D)
    adios2/2.8.0            (D)    flecsi/1.4.2                        mercury/2.1.0                 precice/2.4.0                         sundials/6.2.0-cuda80
    amrex/22.05                    fortrilinos/2.0.0                   metall/0.20                   pumi/2.2.7                            sundials/6.2.0                (D)
    arborx/1.2-cuda80              globalarrays/5.8                    mfem/4.4.0-cuda80             py-cinemasci/1.7.0                    superlu-dist/7.2.0-cuda80
    arborx/1.2              (D)    hdf5/1.10.7                         mfem/4.4.0             (D)    py-libensemble/0.9.1                  tasmanian/7.7-cuda80-openmp
    axom/0.6.1-openmp              heffte/2.2.0-cuda80                 mpifileutils/0.11.1           py-petsc4py/3.17.1                    tasmanian/7.7-openmp          (D)
    butterflypack/2.1.1            heffte/2.2.0                 (D)    nccmp/1.9.0.1                 py-warpx/22.05-dims2                  tau/2.31
    cabana/0.4.0-cuda80            hpctoolkit/2022.04.15-cuda          nco/5.0.1                     py-warpx/22.05-dims3                  tau/2.31.1-cuda               (D)
    cabana/0.4.0            (D)    hpctoolkit/2022.04.15        (D)    omega-h/9.34.1                py-warpx/22.05-dimsRZ          (D)    unifyfs/0.9.2
    caliper/2.7.0-cuda80           hpx/1.7.1-cuda80                    openpmd-api/0.14.4            scr/3.0rc2                            veloc/1.5
    caliper/2.7.0           (D)    hpx/1.7.1                    (D)    papyrus/1.0.2                 slate/2021.05.02-cuda80-openmp
    darshan-runtime/3.3.1          hypre/2.24.0-cuda80                 parallel-netcdf/1.12.2        slate/2021.05.02-openmp        (D)
    datatransferkit/3.1-rc3        hypre/2.24.0                 (D)    parsec/3.0.2012               slepc/3.17.1-cuda80
    dyninst/12.1.0-openmp          kokkos-kernels/3.6.00-cuda80        petsc/3.17.1-cuda80           slepc/3.17.1                   (D)
    
    --------------------------------------------- /global/cfs/cdirs/m3896/shared/ParaTools/E4S/22.05/PrgEnv-gnu/spack/share/spack/lmod/cray-sles15-x86_64/Core ---------------------------------------------
    aml/0.1.0                charliecloud/0.26              flux-core/0.38.0           (D)    kokkos-kernels/3.6.00-openmp (D)    nrm/0.1.0              qthreads/1.16
    archer/2.0.0             cmake/3.23.1          (D)      gasnet/2022.3.0                   kokkos/3.6.00-openmp                nvhpc/22.3             raja/0.14.0-cuda80-openmp
    argobots/1.1             cray-mpich/8.1.15     (L,D)    ginkgo/1.4.0-cuda80-openmp        legion/21.03.0-cuda80-cuda          papi/6.0.0.1-cuda      superlu/5.3.0
    bolt/2.0                 darshan-util/3.3.1             ginkgo/1.4.0-openmp        (D)    legion/21.03.0               (D)    pdt/3.25.1             swig/4.0.2-fortran
    chai/2.4.0-cuda80        flit/2.1.0                     gmp/6.2.1                         magma/2.6.2-cuda80                  plasma/21.8.29         umap/2.1.0
    chai/2.4.0        (D)    flux-core/0.38.0-cuda          gotcha/1.0.3                      mpark-variant/1.4.0                 py-jupyterhub/1.4.1    zfp/0.5.5-cuda80
    ...