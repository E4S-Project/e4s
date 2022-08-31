# E4S Release 22.08

August 2022 release of E4S

## Files

* `cuda-x86_64.spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le.spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (ppc64le)
* `cuda-aarch64.spack.yaml` -- Model Spack Environment for systems w/ NVIDIA GPUs (aarch64)
* `rocm.spack.yaml` -- Model Spack Environment for systems w/ AMD GPUs
* `oneapi.spack.yaml` -- Model Spack Environment for systems w/ Intel GPUs
  
*Specs in the Model Spack Environments may be commented out if we encountered deployment issues or the package doesn't offer a non-branch tracking version.*


## Spack Version

E4S 22.08 uses Spack branch `e4s-22.08`
* https://github.com/spack/spack
* Branch [e4s-22.08](https://github.com/spack/spack/tree/e4s-22.08)


## Spack Build Cache

* https://cache.e4s.io/22.08

```
$> spack mirror add E4S https://cache.e4s.io/22.08
$> spack buildcache keys -it
```

## Model Environments

* For NVIDIA GPUs on x86_64 refer to:
  * `cuda-x86_64.spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2022-08-01`

* For NVIDIA GPUs on ppc64le refer to:
  * `cuda-ppc64le.spack.yaml`
  * Built and tested using:
    * `Ubuntu 18.04, GCC 7.5.0`
    * `ecpe4s/ubuntu18.04-runner-ppc64le:2022-08-01`

* For NVIDIA GPUs on aarch64 refer to:
  * `cuda-aarch64.spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-aarch64:2022-08-01`

* For AMD GPUs refer to:
  * `rocm.spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2022-08-01`

* For OneAPI and Intel GPUs refer to:
  * `oneapi.spack.yaml`
  * Built and tested using:
    * `Ubuntu 20.04, GCC 9.4.0`
    * `ecpe4s/ubuntu20.04-runner-x86_64:2022-08-01`

* Output of `spack find` following installation of `cuda-x86_64.spack.yaml` model environment. Here we've installed all +cuda packages w/ both `cuda_arch=70` (V100) and `cuda_arch=80` (A100).
```
# spack find

```
