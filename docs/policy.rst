E4S Community Policy
=====================

E4S Member Policy
-----------------

The policies below are criteria for E4S membership. To qualify for E4S membership, a package must demonstrate compatibility with each of these policies. Under special circumstances, a package may be granted an exception to a policy.

- **P1** *Spack-based Build and Installation* Each E4S member package supports a scriptable `Spack <https://spack.io/>`_ build and production-quality installation in a way that is compatible with other E4S member packages in the same environment. When E4S build, test, or installation issues arise, there is an expectation that teams will collaboratively resolve those issues.

- **P2** *Minimal Validation* Testing Each E4S member package has at least one test that is executable through the E4S validation test suite (https://github.com/E4S-Project/testsuite). This will be a post-installation test that validates the usability of the package. The E4S validation test suite provides basic confidence that a user can compile, install and run every E4S member package. The E4S team can actively participate in the addition of new packages to the suite upon request.

- **P3** *Sustainability* All E4S compatibility changes will be sustainable in that the changes go into the regular development and release versions of the package and should not be in a private release/branch that is provided only for E4S releases.

- **P4** *Documentation* Each E4S member package should have sufficient documentation to support installation and use.

- **P5** *Product Metadata* Each E4S member package team will provide key product information via metadata that is organized in the `E4S DocPortal <https://e4s-project.github.io/DocPortal.html>`_ format. Depending on the filenames where the metadata is located, this may require `minimal setup <https://github.com/E4S-Project/E4S-Documenter/blob/master/README.md>`_.

- **P6** *Public Repository* Each E4S member package will have a public repository, for example at GitHub or Bitbucket, where the development version of the package is available and pull requests can be submitted.

- **P7** *Imported Software* If an E4S member package imports software that is externally developed and maintained, then it must allow installing, building, and linking against a functionally equivalent outside copy of that software. Acceptable ways to accomplish this include (1) forsaking the internal copied version and using an externally-provided implementation or (2) changing the file names and namespaces of all global symbols to allow the internal copy and the external copy to coexist in the same downstream libraries and programs. This pertains primarily to third party support libraries and does not apply to key components of the package that may be independent packages but are also integral components to the package itself.

- **P8** *Error Handling* Each E4S member package will adopt and document a consistent system for signifying error conditions as appropriate for the language and application. For e.g., returning an error condition or throwing an exception. In the case of a command line tool, it should return a sensible exit status on success/failure, so the package can be safely run from within a script.

- **P9** *Test Suite* Each E4S member package will provide a test suite that does not require special system privileges or the purchase of commercial software. This test suite should grow in its comprehensiveness over time. That is, new and modified features should be included in the suite.

Future Revision E4S Community Policies
--------------------------------------

The policies below are being considered for future revisions of the E4S Community Policies. These policies require further refinement or planning prior to adoption. The topics that these policies address provide information about likely subject areas for E4S policies going forward.

Note: FP stands for “future policy”

- **FP1** *Portability* Each E4S member package team will make a best effort at portability to common platforms. Depending on the function of the member package, considerations may include operating systems, compiler toolchains, architectures and accelerators. Lack of support for configurations should be denoted in appropriate Spack packages when possible.

  including standard Linux distributions, common compiler toolchains, and different architectures and accelerators. Consider: self assessed portability score/metric - OS, GPU, etc?

- **FP2** *Flexible Test Selection Support* Each E4S member package will support the ability to specify that specific tests will be run for a given system allocation limit on execution time and node configuration resources. Particular use cases include the ability to a) run a subset of the test suite to complete within a few hours on standard workstation-level hardware b) be runnable in batch-only environments, that is, systems that require the use of PBS or other submission scripts.

- **FP3** *Dependency Version Tracking* Each E4S member package will document the versions of packages with which it can work or upon which it depends, in Spack. Similarly, incompatible versions of packages should also be appropriately tracked in Spack. The developers of E4S member packages will coordinate the needed versions of various packages for each E4S release.

- **FP4** *Memory Testing* Each E4S member package makes it possible to run their test suite under Valgrind in order to test for memory corruption issues. NOTE: The SDK team is planning to refine this policy so as to not specifically single out Valgrind.

- **FP5** *Comprehensive Test Suite* Each E4S member package will provide a comprehensive test suite that can be run by users and does not require special system privileges or the purchase of commercial software.

- **FP6** *Documentation* Each E4S member package should have sufficient documentation to support installation, use, and further development, as assessed periodically by its community of peers.

Library Policies: Apply to linkable libraries and similar products
-------------------------------------------------------------------

Note: FLP stands for “future library policy”

- **FLP1** *User-managed Exception Handling* Each E4S member library package will have no hardwired calls to abort, exit, or MPI_Abort(). Also, no package should have hardwired print statements for error conditions. Each package should document which error codes/exceptions are recoverable, which may result in lost resources (for example, unfreed memory), and which indicate that the process may be in an undefined or totally broken state (for example, after a segmentation violation). It is the responsibility of the calling routine not to simply continue the computation when a “hard” error is returned; the calling routine will likely, by default, call an abort, but again that should be possible to override.

- **FLP2** *User-managed I/O Control* No package should have hardwired print or I/O statements that cannot be turned off through a programmatic interface; output should never be hard-wired to stdout or stderr. It is recommended that packages provide a way for users to turn on output and allow them to direct where it goes. Also, packages may print to stdout by default but only on one process (i.e., root rank “0”). But packages may also be completely silent by default (and require that users turn on outputting in the appropriate way).

- **FLP3** *Symbols and Namespacing* Each E4S member package will use a limited and well-defined symbol, macro, library, and include file name space. For example, there should be no publicly visible include files such as utils.h, or packages named libutil.a or macros named YES or TRUE. Namespacing of include files can be handled either by prepending each include file with a package name, for example <XXXmat.h>, or by placing and referencing all include files in a subdirectory with a package name, for example <XXX/mat.h>. Note that using a -I/XXX/ and referencing via <mat.h> would not be acceptable namespacing.

- **FLP4** *Memory Leaks* Each E4S member package will free all system resources it has acquired as soon as they are no longer needed, including closing open files, freeing memory, freeing MPI communicators, and freeing MPI data types created by the package. In particular, it is important that E4S compatible code not have any growing memory leaks (such as leaking memory during every timestep). Any resources created by the package that should be freed by the user, rather than by the package, must be fully documented. Note: Exceptions are permitted for situations where other software quality considerations are more important.
