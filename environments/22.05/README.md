# E4S Release 22.05

May 2022 release of E4S

## Files

* `cuda-x86_64.spack.yaml` -- Model Spack environment for systems w/ NVIDIA GPUs (x86_64)
* `cuda-ppc64le.spack.yaml` -- Model Spack environment for systems w/ NVIDIA GPUs (ppc64le)
* `rocm.spack.yaml` -- Model Spack environment for systems w/ AMD GPUs
* `oneapi.spack.yaml` -- Model Spack environment for systems w/ Intel GPUs
  
*Specs in the Model Spack Environment may be commented out if we encountered deployment issues or the package doesn't offer a non-branch tracking version.*


## Spack Version

E4S 22.05 uses Spack branch `e4s-22.05`
* https://github.com/spack/spack
* Branch [e4s-22.02](https://github.com/spack/spack/tree/e4s-22.05)


## Spack Build Cache

* https://cache.e4s.io/22.05

```
$> spack mirror add E4S https://cache.e4s.io/22.05
$> spack buildcache keys -it
```

## Model Environment

* Built and tested on Ubuntu 20.04 w/ GCC 9.4.0 for x86_64
* Built and tested on Ubuntu 18.04 w/ GCC 7.5.0 for ppc64le
* Docker container images:
  * `ecpe4s/ubuntu20.04-runner-x86_64:2022-05-01`
  * `ecpe4s/ubuntu18.04-runner-ppc64le:2022-05-01`
* Output of `spack find` following installation of `cuda-x86_64.spack.yaml` model environment
```
# spack find
```
