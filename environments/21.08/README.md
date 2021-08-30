# E4S Release 21.08

August 2021 release of E4S

## Files

* `spack.yaml` -- Model Spack environment
  
*Specs in the Model Spack Environment are commented out if (a) there are outstanding build issues or (b) if their Spack package does not offer a versioned installation option*


## Spack Version

E4S 21.08 uses Spack branch `e4s-21.08`
* https://github.com/spack/spack
* Branch [e4s-21.08](https://github.com/spack/spack/tree/e4s-21.08)


## Spack Build Cache

* https://cache.e4s.io
* https://cache.e4s.io/21.08

```
$> spack mirror add E4S https://cache.e4s.io/21.08
$> spack buildcache keys -it
```