# E4S Release 22.02

February 2022 release of E4S

## Files

* `spack.yaml` -- Model Spack environment, for x86_64
  
*Specs in the Model Spack Environment are commented out if (a) there are outstanding build issues or (b) if their Spack package does not offer a versioned installation option*


## Spack Version

E4S 22.02 uses Spack branch `e4s-22.02`
* https://github.com/spack/spack
* Branch [e4s-21.02](https://github.com/spack/spack/tree/e4s-22.02)


## Spack Build Cache

* https://cache.e4s.io/22.02

```
$> spack mirror add E4S https://cache.e4s.io/22.02
$> spack buildcache keys -it
```

## Model Environment

* Built and tested on Ubuntu 20.04 w/ GCC 9.3.0 for most packages, GCC 11.1.0 for `LLVM@13` for x86_64
* Built and tested on Ubuntu 18.04 w/ GCC 7.5.0 for most packages, GCC 11.1.0 for `LLVM@13` for ppc64le
* Docker container images:
  * `ecpe4s/ubuntu20.04-runner-x86_64:2022-02-01`
  * `ecpe4s/ubuntu18.04-runner-ppc64le:2022-02-01`
* Output of `spack find` for x86_64 model environment
```
# spack find
...
```
