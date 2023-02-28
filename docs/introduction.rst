Introduction
==============

The Extreme-scale Scientific Software Stack (E4S) is a community effort to
provide open source software packages for developing, deploying and running
scientific applications on high-performance computing (HPC) platforms.
E4S provides from-source builds and containers of a broad collection of HPC software packages.

Purpose
--------

E4S exists to accelerate the development, deployment and use of HPC software, lowering the barriers for HPC users. E4S provides containers and turn-key,
from-source builds of more than 80 popular HPC products in programming models, such as MPI; development tools such as HPCToolkit, TAU and PAPI;
math libraries such as PETSc and Trilinos; and Data and Viz tools such as HDF5 and Paraview.

Interoperability Approach
--------------------------


While porting of individual scientific software products is challenging, achieving interoperability between packages is even more difficult.
E4S uses a dual-pronged approach for achieving software interoperability: Spack and SDKs.

`Spack <https://spack.readthedocs.io/en/latest/>`_: E4S uses the Spack packages manager for software delivery. Spack provides the ability to specify versions of software packages that are and are not interoperable.
It is also a common build layer to not only E4S software, but also an enormous number of software packages outside of ECP ST. These features support achieving and maintaining interoperability between ST software packages.

`Software Development Kits (SDKs) <https://xsdk.info/>`_: An ECP ST Software Development Kit is a collection of related ECP ST software products (called packages) where coordination across package teams will improve usability and practices,
and foster community growth among teams that develop similar and complementary capabilities. An SDK is more of a project than a product, although it involves several products. It can also be considered as an association of products and product teams.
The activities that take place inside an SDK promote interoperability (where appropriate and logical) between products. The initial version 0.2 release of E4S contains member packages of one SDK - the Extreme-Scale Scientific Software Development Kit (xSDK).
Future releases will incorporate additional SDKs that will be defined in the coming months.



Distribution
------------

E4S is open source software published under the `MIT License <https://github.com/E4S-Project/e4s/blob/master/LICENSE>`_. E4S can be redistributed and
modified under the terms of this license. E4S packages each have their own open source license.

Contacts
---------

.. csv-table::
    :header: "Name", "Title", "Email"
    :widths:  30, 30, 30

    "Michael A. Heroux", "Project Leader", "maherou@sandia.gov"
    "Sameer Shende", "E4S Lead", "sameer@cs.uoregon.edu"
    "James Willenbring", "SDK Lead", "jmwille@sandia.gov"

References
-----------

.. csv-table::
    :header: "Conference", "Date", "Link"
    :widths:  60, 30, 30
    :class: tight-table
    

     "Getting Started with E4S for Industry and Agencies Workshop", "June, 2021", "`E4S-IAW21 <https://www.exascaleproject.org/event/e4sforindustry/>`_"
     "E4S: Extreme-Scale Scientific Software Stack", "June, 2021", "`BSSW <https://bssw.io/blog_posts/e4s-extreme-scale-scientific-software-stack>`_"
     "E4S Tutorial at ECP Annual Meeting", "April, 2021", "`Video <https://youtu.be/vGKgAXtSFu0>`_"
     "E4S BoF at ECP Annual Meeting", "April, 2021", "`Video <https://youtu.be/5UbIUxYKb6o>`__"
     "State of E4S - July 2020 Update", "July 2020", "`PPTX <https://e4s-project.github.io/E4S_July20.pptx>`__"
     "ECP Software Technology Capability Assessment Report (CAR) Version 1.5", "Feb, 2019", "`PDF <https://www.exascaleproject.org/wp-content/uploads/2019/02/ECP-ST-CAR.pdf>`__"
     "DOE’S E4S Software Stack Takes An Extreme Step Towards Exascale", "Jan, 2019", "`Article <https://www.nextplatform.com/2019/01/22/does-e4s-software-stack-takes-an-extreme-step-towards-exascale/>`_"
     "Extreme-Scale Scientific Software Stack (E4S) Release 0.1", "Nov, 2018", "`Video <https://www.youtube.com/watch?v=nfCXwX_0EBc>`__"

- `E4S 23.02 Release Notes <https://e4s.io/talks/E4S_23.02.pdf>`_
- `E4S 22.11 Release Notes <https://e4s.io/talks/E4S_22.11.pdf>`_
- `E4S 22.08 Release Notes <https://e4s.io/talks/E4S_22.08.pdf>`_
- `E4S 22.05 Release Notes <https://e4s.io/talks/E4S_22.05.pdf>`_
- `E4S 22.02 Release Notes <https://e4s.io/talks/E4S_22.02.pdf>`_
- `E4S 21.11 Release Notes <https://e4s.io/talks/E4S_21.11.pdf>`_
