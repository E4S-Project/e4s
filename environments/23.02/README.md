# E4S Release 23.02

February 2023 release of E4S

## Files

* `cuda-x86_64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (ppc64le)
* `cuda-aarch64/spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (aarch64)
* `rocm-x86_64/spack.yaml` -- Model Spack Environment for systems w/ AMD GPUs (x86_64)

Alongside the Spack environments listed above there are `concretize.log` files which show the exact versions and variants of the concretized environment. This includes both the root specs and the entire set of dependencies needed to build them.

*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a fixed version.*


## Spack Version

E4S 23.02 uses Spack branch `e4s-23.02`
* https://github.com/spack/spack
* Branch [e4s-23.02](https://github.com/spack/spack/tree/e4s-23.02)


## Spack Build Cache

* https://cache.e4s.io/23.02 (not intended for web browser access; for use with `spack`)

```
$> spack mirror add E4S https://cache.e4s.io/23.02

$> spack buildcache keys -it
==> Fetching https://cache.e4s.io/23.02/build_cache/_pgp/25645FA2B218FE55B4EF649E4345F04B40005581.pub
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
    * `ecpe4s/ubuntu20.04-runner-x86_64:2023-01-01`

* For NVIDIA GPUs on ppc64le refer to:
  * `cuda-ppc64le/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-ppc64le:2023-01-01`

* For NVIDIA GPUs on aarch64 refer to:
  * `cuda-aarch64/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.1.0`
    * `ecpe4s/ubuntu20.04-runner-aarch64:2023-03-01`

* For AMD GPUs refer to:
  * `rocm-x86_64/spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 11.1.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2023-01-01`

## Example output of `spack find`

Here is what `spack find` would show following the installation of the `cuda-x86_64/spack.yaml` model environment.

If you inspect this environment, you will notice it includes `+cuda` specs built for both `cuda_arch=80` (A100) and `cuda_arch=90` (H100).

```
root@d8d252f1a181:/# spack find -x
```
