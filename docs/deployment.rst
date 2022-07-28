E4S Deployments
===============

These deployments are maintained by `ParaTools <https://www.paratools.com/>`_ and may not be officially supported by facility staff.

JLSE
----------

**ParaTools Deployment: E4S 22.05**

For more information on JLSE please see https://www.jlse.anl.gov.

This deployment is built using Spack at branch `e4s-22.05` and system-provided OneAPI and MPI.

.. code-block:: console

    $arcticus> . /soft/ecp/ParaTools/E4S/22.05/module-use.sh
    $arcticus> module avail
    adios/1.13.1-oneapi-2022.1.0-mpi           kokkos-kernels/3.6.00-oneapi-2022.1.0       py-jupyterhub/1.4.1-oneapi-2022.1.0
    adios2/2.8.0-oneapi-2022.1.0-mpi           kokkos-kernels/3.6.00-oneapi-2022.1.0-sycl  py-libensemble/0.9.1-oneapi-2022.1.0-mpi
    alquimia/1.0.9-oneapi-2022.1.0-mpi         kokkos/3.6.00-oneapi-2022.1.0               py-petsc4py/3.17.1-oneapi-2022.1.0-mpi
    aml/0.1.0-oneapi-2022.1.0                  kokkos/3.6.00-oneapi-2022.1.0-sycl          qthreads/1.16-oneapi-2022.1.0
    amrex/22.05-oneapi-2022.1.0-mpi            lammps/20220107-oneapi-2022.1.0-mpi         raja/0.14.0-oneapi-2022.1.0
    arborx/1.2-oneapi-2022.1.0-mpi             legion/21.03.0-oneapi-2022.1.0              slate/2021.05.02-oneapi-2022.1.0-mpi
    argobots/1.1-oneapi-2022.1.0               libnrm/0.1.0-oneapi-2022.1.0-mpi            slepc/3.17.1-oneapi-2022.1.0-mpi
    bolt/2.0-oneapi-2022.1.0                   libquo/1.3.1-oneapi-2022.1.0-mpi            stc/0.9.0-oneapi-2022.1.0-mpi
    cabana/0.4.0-oneapi-2022.1.0-mpi           libunwind/1.6.2-oneapi-2022.1.0             sundials/6.2.0-oneapi-2022.1.0-mpi
    chai/2.4.0-oneapi-2022.1.0                 loki/0.1.7-oneapi-2022.1.0                  superlu-dist/7.2.0-oneapi-2022.1.0-mpi
    charliecloud/0.26-oneapi-2022.1.0          mercury/2.1.0-oneapi-2022.1.0-mpi           superlu/5.3.0-oneapi-2022.1.0
    conduit/0.8.3-oneapi-2022.1.0-mpi          metall/0.20-oneapi-2022.1.0-mpi             swig/4.0.2-fortran-oneapi-2022.1.0
    darshan-runtime/3.3.1-oneapi-2022.1.0-mpi  mfem/4.4.0-oneapi-2022.1.0-mpi              swig/4.0.2-oneapi-2022.1.0
    darshan-util/3.3.1-oneapi-2022.1.0         mpark-variant/1.4.0-oneapi-2022.1.0         sz/2.1.12-oneapi-2022.1.0
    faodel/1.2108.1-oneapi-2022.1.0-mpi        mpifileutils/0.11.1-oneapi-2022.1.0-mpi     tasmanian/7.7-oneapi-2022.1.0-mpi
    flit/2.1.0-oneapi-2022.1.0                 nccmp/1.9.0.1-oneapi-2022.1.0-mpi           tau/2.31.1-oneapi-2022.1.0-mpi
    fortrilinos/2.0.0-oneapi-2022.1.0-mpi      nco/5.0.1-oneapi-2022.1.0-mpi               tau/2.31.1-oneapi-2022.1.0-mpi-level-zero
    gasnet/2022.3.0-oneapi-2022.1.0            netlib-scalapack/2.2.0-oneapi-2022.1.0-mpi  trilinos/13.0.1-oneapi-2022.1.0-mpi
    ginkgo/1.4.0-oneapi-2022.1.0               papyrus/1.0.2-oneapi-2022.1.0-mpi           turbine/1.3.0-oneapi-2022.1.0-mpi
    globalarrays/5.8-oneapi-2022.1.0-mpi       parsec/3.0.2012-oneapi-2022.1.0-mpi         umap/2.1.0-oneapi-2022.1.0
    gmp/6.2.1-oneapi-2022.1.0                  petsc/3.17.1-oneapi-2022.1.0-mpi            umpire/6.0.0-oneapi-2022.1.0
    gotcha/1.0.3-oneapi-2022.1.0               plasma/21.8.29-oneapi-2022.1.0              upcxx/2022.3.0-oneapi-2022.1.0-mpi
    hdf5/1.10.7-oneapi-2022.1.0-mpi            plumed/2.6.3-oneapi-2022.1.0-mpi            veloc/1.5-oneapi-2022.1.0-mpi
    heffte/2.2.0-oneapi-2022.1.0-mpi           precice/2.4.0-oneapi-2022.1.0-mpi           wannier90/3.1.0-oneapi-2022.1.0-mpi
    hypre/2.24.0-oneapi-2022.1.0-mpi           pumi/2.2.7-oneapi-2022.1.0-mpi              zfp/0.5.5-oneapi-2022.1.0


Crusher
----------

**ParaTools Deployment: E4S 22.05 / PrgEnv-gnu**

This deployment is built using Spack at branch `e4s-22.05` and the following facility-provided external packages:

* PrgEnv-gnu
* gcc/11.2.0
* cray-mpich
* ROCm 5.1.0

The exact Spack environment used to build this configuration is available here:

* /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-gnu/spack.yaml

.. code-block:: console

    $crusher> . /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-gnu/module-use.sh
    $crusher> module avail
        ------------------------------- /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-gnu/spack/share/spack/lmod/cray-sles15-x86_64/cray-mpich/8.1.16-u3ebvcw/Core -------------------------------
       adios/1.13.1                   dyninst/12.1.0        (D)    lammps/20220107        (D)    parallel-netcdf/1.12.2 (D)    py-warpx/22.05-dimsRZ   (D)    tau/2.31.1-rocm
       adios2/2.8.0                   exaworks/0.1.0               libquo/1.3.1           (D)    paraview/5.10.1               slate/2021.05.02        (D)    tau/2.31.1          (D)
       amrex/22.05-rocm               faodel/1.2108.1       (D)    mercury/2.1.0          (D)    parsec/3.0.2012        (D)    slepc/3.17.1-rocm              trilinos/13.0.1
       amrex/22.05             (D)    flecsi/1.4.2          (D)    metall/0.20            (D)    petsc/3.17.1-rocm             slepc/3.17.1            (D)    turbine/1.3.0       (D)
       arborx/1.2-rocm                fortrilinos/2.0.0     (D)    mfem/4.4.0-rocm               petsc/3.17.1           (D)    stc/0.9.0                      unifyfs/0.9.2
       arborx/1.2              (D)    globalarrays/5.8      (D)    mfem/4.4.0             (D)    phist/1.9.5                   strumpack/6.3.1-rocm           upcxx/2022.3.0-rocm
       axom/0.6.1              (D)    hdf5/1.10.7                  mpifileutils/0.11.1    (D)    precice/2.4.0          (D)    strumpack/6.3.1         (D)    upcxx/2022.3.0      (D)
       butterflypack/2.1.1     (D)    heffte/2.2.0-rocm            nccmp/1.9.0.1          (D)    pumi/2.2.7             (D)    sundials/6.2.0-rocm            veloc/1.5           (D)
       cabana/0.4.0            (D)    heffte/2.2.0          (D)    nco/5.0.1              (D)    py-cinemasci/1.7.0            sundials/6.2.0          (D)
       caliper/2.7.0           (D)    hpctoolkit/2022.04.15 (D)    netlib-scalapack/2.2.0 (D)    py-libensemble/0.9.1          superlu-dist/7.2.0-rocm
       conduit/0.8.3                  hpx/1.7.1-rocm               omega-h/9.34.1         (D)    py-petsc4py/3.17.1            superlu-dist/7.2.0      (D)
       darshan-runtime/3.3.1   (D)    hpx/1.7.1             (D)    openpmd-api/0.14.4     (D)    py-warpx/22.05-dims2          tasmanian/7.7-rocm
       datatransferkit/3.1-rc3 (D)    hypre/2.24.0          (D)    papyrus/1.0.2          (D)    py-warpx/22.05-dims3          tasmanian/7.7           (D)

    -------------------------------------------- /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-gnu/spack/share/spack/lmod/cray-sles15-x86_64/Core --------------------------------------------
       aml/0.1.0       (D)    charliecloud/0.26             gasnet/2022.3.0       (D)    kokkos/3.6.00-rocm         nrm/0.1.0                  qthreads/1.16      (D)    sz/2.1.12         (D)
       archer/2.0.0           cray-mpich/8.1.16    (L,D)    ginkgo/1.4.0-rocm            kokkos/3.6.00       (D)    openmpi/4.1.3              raja/0.14.0-rocm          umap/2.1.0        (D)
       argobots/1.1    (D)    darshan-util/3.3.1   (D)      ginkgo/1.4.0          (D)    legion/21.03.0      (D)    papi/6.0.0.1               raja/0.14.0        (D)    umpire/6.0.0-rocm
       bolt/2.0        (D)    flit/2.1.0           (D)      gmp/6.2.1             (D)    libunwind/1.6.2     (D)    pdt/3.25.1          (D)    superlu/5.3.0      (D)    umpire/6.0.0      (D)
       chai/2.4.0-rocm        flux-core/0.38.0     (D)      gotcha/1.0.3          (D)    magma/2.6.2-rocm    (D)    plasma/21.8.29             swig/4.0.2-fortran        zfp/0.5.5         (D)
       chai/2.4.0      (D)    gasnet/2022.3.0-rocm          kokkos-kernels/3.6.00 (D)    mpark-variant/1.4.0 (D)    py-jupyterhub/1.4.1        swig/4.0.2         (D)

**ParaTools Deployment: E4S 22.05 / PrgEnv-amd**

This deployment is built using Spack at branch `e4s-22.05` and the following facility-provided external packages:

* PrgEnv-amd
* amd/5.1.0
* cray-mpich
* ROCm 5.1.0

The exact Spack environment used to build this configuration is available here:

* /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-amd/spack.yaml

.. code-block:: console

    $crusher> . /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-amd/module-use.sh
    $crusher> module avail
        ------------------------------- /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-amd/spack/share/spack/lmod/cray-sles15-x86_64/cray-mpich/8.1.16-qhzn27v/Core -------------------------------
       adios/1.13.1                   exaworks/0.1.0           hypre/2.24.0        (D)    nco/5.0.1              (D)    pumi/2.2.7           (D)    sundials/6.2.0          (D)    upcxx/2022.3.0-rocm
       amrex/22.05-rocm               faodel/1.2108.1   (D)    lammps/20220107     (D)    netlib-scalapack/2.2.0 (D)    py-cinemasci/1.7.0          superlu-dist/7.2.0-rocm        upcxx/2022.3.0      (D)
       amrex/22.05             (D)    fortrilinos/2.0.0 (D)    libquo/1.3.1        (D)    papyrus/1.0.2          (D)    py-libensemble/0.9.1        superlu-dist/7.2.0      (D)    veloc/1.5           (D)
       arborx/1.2-rocm                globalarrays/5.8  (D)    mercury/2.1.0       (D)    parallel-netcdf/1.12.2 (D)    py-petsc4py/3.17.1          tasmanian/7.7-rocm             vtk-m/1.7.1         (D)
       arborx/1.2              (D)    hdf5/1.10.7              metall/0.20         (D)    parsec/3.0.2012               rempi/1.1.0          (D)    tasmanian/7.7           (D)    wannier90/3.1.0
       cabana/0.4.0            (D)    heffte/2.2.0-rocm        mfem/4.4.0-rocm            petsc/3.17.1-rocm             scr/3.0rc2                  tau/2.31.1-rocm
       caliper/2.7.0                  heffte/2.2.0      (D)    mfem/4.4.0          (D)    petsc/3.17.1           (D)    slate/2021.05.02            tau/2.31.1              (D)
       darshan-runtime/3.3.1          hpx/1.7.1-rocm           mpifileutils/0.11.1 (D)    plumed/2.6.3           (D)    stc/0.9.0                   trilinos/13.0.1         (D)
       datatransferkit/3.1-rc3 (D)    hpx/1.7.1         (D)    nccmp/1.9.0.1       (D)    precice/2.4.0          (D)    sundials/6.2.0-rocm         turbine/1.3.0           (D)

    -------------------------------------------- /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-amd/spack/share/spack/lmod/cray-sles15-x86_64/Core --------------------------------------------
       aml/0.1.0         (D)    cray-mpich/8.1.16    (L,D)    ginkgo/1.4.0-rocm            kokkos/3.6.00       (D)    nrm/0.1.0                  raja/0.14.0-rocm          umap/2.1.0        (D)
       argobots/1.1      (D)    darshan-util/3.3.1   (D)      ginkgo/1.4.0          (D)    legion/21.03.0      (D)    openmpi/4.1.3              raja/0.14.0        (D)    umpire/6.0.0-rocm
       bolt/2.0          (D)    flit/2.1.0           (D)      gmp/6.2.1             (D)    libunwind/1.6.2     (D)    papi/6.0.0.1               superlu/5.3.0      (D)    umpire/6.0.0      (D)
       chai/2.4.0-rocm          flux-core/0.38.0     (D)      gotcha/1.0.3          (D)    loki/0.1.7          (D)    pdt/3.25.1          (D)    swig/4.0.2-fortran        zfp/0.5.5         (D)
       chai/2.4.0        (D)    gasnet/2022.3.0-rocm          kokkos-kernels/3.6.00 (D)    magma/2.6.2-rocm           py-jupyterhub/1.4.1        swig/4.0.2         (D)
       charliecloud/0.26        gasnet/2022.3.0      (D)      kokkos/3.6.00-rocm           mpark-variant/1.4.0 (D)    qthreads/1.16       (D)    sz/2.1.12          (D)

**ParaTools Deployment: E4S 22.05 / PrgEnv-cray**

This deployment is built using Spack at branch `e4s-22.05` and the following facility-provided external packages:

* PrgEnv-cray
* cce/14.0.0
* cray-mpich
* ROCm 5.1.0

The exact Spack environment used to build this configuration is available here:

* /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-cray/spack.yaml

.. code-block:: console

    $crusher> . /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-cray/module-use.sh
    $crusher> module avail
        ------------------------------ /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-cray/spack/share/spack/lmod/cray-sles15-x86_64/cray-mpich/8.1.16-pq2h7mx/Core -------------------------------
       adios/1.13.1            conduit/0.8.3           (D)    heffte/2.2.0-rocm        mfem/4.4.0-rocm               petsc/3.17.1-rocm           sundials/6.2.0-rocm            unifyfs/0.9.2
       adios2/2.8.0     (D)    darshan-runtime/3.3.1   (D)    heffte/2.2.0      (D)    mfem/4.4.0             (D)    petsc/3.17.1         (D)    sundials/6.2.0          (D)    upcxx/2022.3.0-rocm
       amrex/22.05-rocm        datatransferkit/3.1-rc3 (D)    hpx/1.7.1-rocm           mpifileutils/0.11.1    (D)    plumed/2.6.3         (D)    superlu-dist/7.2.0-rocm        upcxx/2022.3.0      (D)
       amrex/22.05      (D)    faodel/1.2108.1         (D)    hpx/1.7.1         (D)    nccmp/1.9.0.1          (D)    precice/2.4.0        (D)    superlu-dist/7.2.0      (D)    veloc/1.5           (D)
       arborx/1.2-rocm         flecsi/1.4.2            (D)    hypre/2.24.0      (D)    nco/5.0.1              (D)    pumi/2.2.7           (D)    tasmanian/7.7-rocm             vtk-m/1.7.1         (D)
       arborx/1.2       (D)    fortrilinos/2.0.0       (D)    libquo/1.3.1      (D)    openpmd-api/0.14.4     (D)    py-libensemble/0.9.1        tasmanian/7.7           (D)
       ascent/0.8.0     (D)    globalarrays/5.8               mercury/2.1.0     (D)    papyrus/1.0.2          (D)    py-petsc4py/3.17.1          trilinos/13.0.1         (D)
       axom/0.6.1       (D)    hdf5/1.10.7                    metall/0.20       (D)    parallel-netcdf/1.12.2 (D)    stc/0.9.0                   turbine/1.3.0           (D)

    ------------------------------------------- /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/PrgEnv-cray/spack/share/spack/lmod/cray-sles15-x86_64/Core --------------------------------------------
       aml/0.1.0         (D)    cray-mpich/8.1.16    (L,D)    ginkgo/1.4.0-rocm            kokkos/3.6.00       (D)    openmpi/4.1.3              raja/0.14.0        (D)    umpire/6.0.0-rocm
       argobots/1.1      (D)    darshan-util/3.3.1   (D)      ginkgo/1.4.0          (D)    legion/21.03.0      (D)    papi/6.0.0.1               superlu/5.3.0      (D)    umpire/6.0.0      (D)
       bolt/2.0          (D)    flit/2.1.0           (D)      gmp/6.2.1             (D)    libunwind/1.6.2     (D)    pdt/3.25.1          (D)    swig/4.0.2-fortran        variorum/0.4.1
       chai/2.4.0-rocm          flux-core/0.38.0     (D)      gotcha/1.0.3          (D)    loki/0.1.7          (D)    py-jupyterhub/1.4.1        swig/4.0.2         (D)    zfp/0.5.5         (D)
       chai/2.4.0        (D)    gasnet/2022.3.0-rocm          kokkos-kernels/3.6.00 (D)    magma/2.6.2-rocm    (D)    qthreads/1.16       (D)    sz/2.1.12          (D)
       charliecloud/0.26        gasnet/2022.3.0      (D)      kokkos/3.6.00-rocm           mpark-variant/1.4.0 (D)    raja/0.14.0-rocm           umap/2.1.0         (D)

**ParaTools Deployment: E4S 22.05 / PrgEnv-gnu w/ MVAPICH2**

This deployment is built using Spack at branch `e4s-22.05`, MVAPICH2, and the following facility-provided external packages:

* PrgEnv-gnu
* gcc/11.2.0
* ROCm 5.1.0

The exact Spack environment used to build this configuration is available here:

* /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/mvapich2/spack.yaml

.. code-block:: console

    $crusher> . . /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/mvapich2/module-use.sh
    $crusher> module avail
        ---------------------------------- /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/mvapich2/spack/share/spack/lmod/cray-sles15-x86_64/mvapich2/3.0a-tdq2ett/Core ----------------------------------
       adios/1.13.1                 datatransferkit/3.1-rc3 (D)    hypre/2.24.0           (D)    openpmd-api/0.14.4     (D)    py-warpx/22.05-dims2           superlu-dist/7.2.0 (D)
       adios2/2.8.0                 dyninst/12.1.0          (D)    lammps/20220107        (D)    papyrus/1.0.2          (D)    py-warpx/22.05-dims3           tasmanian/7.7-rocm
       amrex/22.05-rocm             exaworks/0.1.0                 libquo/1.3.1           (D)    parallel-netcdf/1.12.2 (D)    py-warpx/22.05-dimsRZ   (D)    tasmanian/7.7      (D)
       amrex/22.05           (D)    faodel/1.2108.1         (D)    mercury/2.1.0          (D)    paraview/5.10.1               slate/2021.05.02        (D)    tau/2.31.1-rocm
       arborx/1.2-rocm              fortrilinos/2.0.0       (D)    metall/0.20            (D)    parsec/3.0.2012        (D)    slepc/3.17.1-rocm              tau/2.31.1         (D)
       arborx/1.2            (D)    globalarrays/5.8        (D)    mfem/4.4.0-rocm               petsc/3.17.1-rocm             slepc/3.17.1            (D)    trilinos/13.0.1
       axom/0.6.1            (D)    hdf5/1.10.7                    mfem/4.4.0             (D)    petsc/3.17.1           (D)    stc/0.9.0                      turbine/1.3.0      (D)
       butterflypack/2.1.1   (D)    heffte/2.2.0-rocm              mpifileutils/0.11.1    (D)    precice/2.4.0          (D)    strumpack/6.3.1-rocm           unifyfs/0.9.2
       cabana/0.4.0          (D)    heffte/2.2.0            (D)    nccmp/1.9.0.1          (D)    pumi/2.2.7             (D)    strumpack/6.3.1         (D)    veloc/1.5          (D)
       caliper/2.7.0         (D)    hpctoolkit/2022.04.15   (D)    nco/5.0.1              (D)    py-cinemasci/1.7.0            sundials/6.2.0-rocm
       conduit/0.8.3                hpx/1.7.1-rocm                 netlib-scalapack/2.2.0 (D)    py-libensemble/0.9.1          sundials/6.2.0          (D)
       darshan-runtime/3.3.1 (D)    hpx/1.7.1               (D)    omega-h/9.34.1         (D)    py-petsc4py/3.17.1            superlu-dist/7.2.0-rocm

    --------------------------------------------- /gpfs/alpine/csc439/world-shared/E4S/ParaTools/22.05/mvapich2/spack/share/spack/lmod/cray-sles15-x86_64/Core ---------------------------------------------
       aml/0.1.0       (D)    charliecloud/0.26           ginkgo/1.4.0-rocm            kokkos/3.6.00       (D)    nrm/0.1.0                  raja/0.14.0-rocm          umap/2.1.0        (D)
       archer/2.0.0           darshan-util/3.3.1   (D)    ginkgo/1.4.0          (D)    legion/21.03.0      (D)    papi/6.0.0.1               raja/0.14.0        (D)    umpire/6.0.0-rocm
       argobots/1.1    (D)    flit/2.1.0           (D)    gmp/6.2.1             (D)    libunwind/1.6.2     (D)    pdt/3.25.1          (D)    superlu/5.3.0      (D)    umpire/6.0.0      (D)
       bolt/2.0        (D)    flux-core/0.38.0     (D)    gotcha/1.0.3          (D)    magma/2.6.2-rocm    (D)    plasma/21.8.29             swig/4.0.2-fortran        zfp/0.5.5         (D)
       chai/2.4.0-rocm        gasnet/2022.3.0-rocm        kokkos-kernels/3.6.00 (D)    mpark-variant/1.4.0 (D)    py-jupyterhub/1.4.1        swig/4.0.2         (D)
       chai/2.4.0      (D)    gasnet/2022.3.0      (D)    kokkos/3.6.00-rocm           mvapich2/3.0a       (L)    qthreads/1.16       (D)    sz/2.1.12          (D)
>>>>>>> 6d5c0ff... Update deployment.rst

Perlmutter
----------

`Perlmutter <https://docs.nersc.gov/systems/perlmutter/system_details/>`__ is HPE Cray EX Super Computer at `National Energy Research Scientific Computing Center (NERSC) <https://nersc.gov/>`_ which is a comprised both of CPU-only and GPU-accelerated nodes. We have deployed E4S on Perlmutter which can seen upon system access. Please refer to https://docs.nersc.gov/connect/ for details on how to connect to Perlmutter.

The E4S deployments can be accessed via **module**. Available E4S deployments are shown below.


**ParaTools Deployment: E4S 22.05**

.. code-block:: console

    $perlmutter> module use /global/cfs/cdirs/m3896/shared/modulefiles/
    $perlmutter> module avail E4S
    ------------------- /global/cfs/cdirs/m3896/shared/modulefiles -----------------
        e4s/22.05/mvapich2    e4s/22.05/PrgEnv-gnu (D)
        

The **e4s/22.05/mvapich2** module provides an E4S deployment with mpi provided by `mvapich2 <https://mvapich.cse.ohio-state.edu/>`_. 

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

The **e4s/22.05/PrgEnv-gnu** module provides an E4S deployment with mpi provided by the system software environment.

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
