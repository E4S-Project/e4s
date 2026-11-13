# check=skip=InvalidDefaultArgInFrom

ARG CPU_BASE_IMAGE
ARG CUDA_BASE_IMAGE
ARG FINAL_BASE_IMAGE
ARG GENERIC_BASE_IMAGE
ARG ONEAPI_BASE_IMAGE
ARG ROCM_BASE_IMAGE

## Clone spack core repo
FROM $GENERIC_BASE_IMAGE AS spack-core

ARG SPACK_CORE_CHECKOUT
ARG SPACK_CORE_REPO
ARG SPACK_CORE_ROOT

RUN git clone --quiet $SPACK_CORE_REPO $SPACK_CORE_ROOT \
 && git -C $SPACK_CORE_ROOT checkout --quiet $SPACK_CORE_CHECKOUT


## Clone spack-packages repo
FROM $GENERIC_BASE_IMAGE AS spack-packages

ARG SPACK_PACKAGES_CHECKOUT
ARG SPACK_PACKAGES_REPO
ARG SPACK_PACKAGES_ROOT

RUN git clone --quiet $SPACK_PACKAGES_REPO $SPACK_PACKAGES_ROOT \
 && git -C $SPACK_PACKAGES_ROOT checkout --quiet $SPACK_PACKAGES_CHECKOUT


## Complete spack setup (spack core + spack-packages)
FROM $GENERIC_BASE_IMAGE AS spack-complete

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-core $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-packages $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && export SPACK_DISABLE_LOCAL_CONFIG=1 \
 && spack repo set --destination $SPACK_PACKAGES_ROOT builtin \
 && spack config --scope site add "config:db_lock_timeout:480" \
 && spack config --scope site add "config:connect_timeout:60"


## ETC
FROM $GENERIC_BASE_IMAGE AS etc
COPY --from=container-common /utilities.sh /etc/e4s/
COPY --from=release-common /install-spack-packages.sh /etc/e4s/
COPY --from=release-common /concretize-spack-env.sh /etc/e4s/
COPY --from=release-common /modules.yaml /etc/spack/


FROM $GENERIC_BASE_IMAGE AS etc-spack-cpu
COPY --from=spack-env gnu/_config/packages.yaml /etc/spack


FROM $GENERIC_BASE_IMAGE AS etc-spack-cuda
COPY --from=spack-common merge-spack-packages.py /tmp/
COPY --from=spack-env gnu/_config/packages.yaml /tmp/packages-1.yaml
COPY --from=spack-env gnu/cuda/_config/packages.yaml /tmp/packages-2.yaml
RUN mkdir -p /etc/spack \
 && python3 \
      /tmp/merge-spack-packages.py \
      /tmp/packages-1.yaml /tmp/packages-2.yaml \
       | tee /etc/spack/packages.yaml


FROM $GENERIC_BASE_IMAGE AS etc-spack-rocm
COPY --from=spack-common merge-spack-packages.py /tmp/
COPY --from=spack-env gnu/_config/packages.yaml /etc/spack/packages.yaml
COPY --from=spack-env gnu/_config/packages.yaml /tmp/packages-1.yaml
COPY --from=spack-env gnu/rocm/_config/packages.yaml /tmp/packages-2.yaml
RUN mkdir -p /etc/spack \
 && python3 \
      /tmp/merge-spack-packages.py \
      /tmp/packages-1.yaml /tmp/packages-2.yaml \
       | tee /etc/spack/packages.yaml


FROM $GENERIC_BASE_IMAGE AS etc-spack-oneapi
COPY --from=spack-env oneapi/_config/packages.yaml /etc/spack/


## CUDA-120 SPACK CONCRETIZE
FROM $CUDA_BASE_IMAGE AS spack-cuda-120-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cuda/_config /etc/e4s/cuda/_config
COPY --from=spack-env gnu/cuda/120 /etc/e4s/cuda/120
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/cuda/120
RUN /etc/e4s/concretize-spack-env.sh


## CUDA-90 SPACK CONCRETIZE
FROM $CUDA_BASE_IMAGE AS spack-cuda-90-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cuda/_config /etc/e4s/cuda/_config
COPY --from=spack-env gnu/cuda/90 /etc/e4s/cuda/90
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/cuda/90
RUN /etc/e4s/concretize-spack-env.sh



## CUDA-80 SPACK CONCRETIZE
FROM $CUDA_BASE_IMAGE AS spack-cuda-80-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cuda/_config /etc/e4s/cuda/_config
COPY --from=spack-env gnu/cuda/80 /etc/e4s/cuda/80
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/cuda/80
RUN /etc/e4s/concretize-spack-env.sh



## CUDA-NOARCH SPACK CONCRETIZE
FROM $CUDA_BASE_IMAGE AS spack-cuda-notarget-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cuda/_config /etc/e4s/cuda/_config
COPY --from=spack-env gnu/cuda/notarget /etc/e4s/cuda/notarget
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/cuda/notarget
RUN /etc/e4s/concretize-spack-env.sh


## ROCM-950 SPACK CONCRETIZE
FROM $ROCM_BASE_IMAGE AS spack-rocm-950-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/rocm/_config /etc/e4s/rocm/_config
COPY --from=spack-env gnu/rocm/gfx950 /etc/e4s/rocm/gfx950
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/rocm/gfx950
RUN /etc/e4s/concretize-spack-env.sh


## ROCM-942 SPACK CONCRETIZE
FROM $ROCM_BASE_IMAGE AS spack-rocm-942-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/rocm/_config /etc/e4s/rocm/_config
COPY --from=spack-env gnu/rocm/gfx942 /etc/e4s/rocm/gfx942
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/rocm/gfx942
RUN /etc/e4s/concretize-spack-env.sh


## ROCM-90a SPACK CONCRETIZE
FROM $ROCM_BASE_IMAGE AS spack-rocm-90a-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/rocm/_config /etc/e4s/rocm/_config
COPY --from=spack-env gnu/rocm/gfx90a /etc/e4s/rocm/gfx90a
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/rocm/gfx90a
RUN /etc/e4s/concretize-spack-env.sh


## ROCM-908 SPACK CONCRETIZE
FROM $ROCM_BASE_IMAGE AS spack-rocm-908-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/rocm/_config /etc/e4s/rocm/_config
COPY --from=spack-env gnu/rocm/gfx908 /etc/e4s/rocm/gfx908
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/rocm/gfx908
RUN /etc/e4s/concretize-spack-env.sh


## ROCM-NOARCH SPACK CONCRETIZE
FROM $ROCM_BASE_IMAGE AS spack-rocm-notarget-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/rocm/_config /etc/e4s/rocm/_config
COPY --from=spack-env gnu/rocm/notarget /etc/e4s/rocm/notarget
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/rocm/notarget
RUN /etc/e4s/concretize-spack-env.sh


## ONEAPI GPU SPACK CONCRETIZE
FROM $ONEAPI_BASE_IMAGE AS spack-oneapi-gpu-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env oneapi/_config /etc/e4s/oneapi/_config
COPY --from=spack-env oneapi/gpu /etc/e4s/oneapi/gpu
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/oneapi/gpu
# RUN /etc/e4s/concretize-spack-env.sh


## ONEAPI CPU SPACK CONCRETIZE
FROM $ONEAPI_BASE_IMAGE AS spack-oneapi-cpu-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env oneapi/_config /etc/e4s/oneapi/_config
COPY --from=spack-env oneapi/cpu /etc/e4s/oneapi/cpu
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/oneapi/cpu
RUN /etc/e4s/concretize-spack-env.sh


## CPU SPACK CONCRETIZE
FROM $CPU_BASE_IMAGE AS spack-cpu-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env gnu/_config /etc/e4s/_config
COPY --from=spack-env gnu/cpu /etc/e4s/cpu
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT
ARG FORCE_CACHED_LOCKFILE

WORKDIR /etc/e4s/cpu
# remove paraview+qt after giving a chance to fetch cached lockfile
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack -e . concretize | tee concretize.log \
 && /etc/e4s/concretize-spack-env.sh \
 && spack -e . remove 'paraview +qt' && spack -e . concretize || true


## CUDA-120 SPACK INSTALL
FROM $CUDA_BASE_IMAGE AS spack-cuda-120

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-cuda-120-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-cuda-120-concretize /etc/e4s/cuda /etc/e4s/cuda
COPY --from=spack-cuda-notarget-concretize /etc/e4s/cuda/notarget /etc/e4s/cuda/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/120
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y



## CUDA-90 SPACK INSTALL
FROM $CUDA_BASE_IMAGE AS spack-cuda-90

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-cuda-90-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-cuda-90-concretize /etc/e4s/cuda /etc/e4s/cuda
COPY --from=spack-cuda-notarget-concretize /etc/e4s/cuda/notarget /etc/e4s/cuda/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/90
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y


## CUDA-80 SPACK INSTALL
FROM $CUDA_BASE_IMAGE AS spack-cuda-80

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-cuda-80-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-cuda-80-concretize /etc/e4s/cuda /etc/e4s/cuda
COPY --from=spack-cuda-notarget-concretize /etc/e4s/cuda/notarget /etc/e4s/cuda/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/80
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y


## CUDA-80 FULL CPU+GPU SPACK INSTALL
FROM $CUDA_BASE_IMAGE AS spack-cuda-80-full

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-cpu-concretize /etc/e4s/cpu /etc/e4s/cpu
COPY --from=spack-cuda-80-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-cuda-80-concretize /etc/e4s/cuda /etc/e4s/cuda
COPY --from=spack-cuda-notarget-concretize /etc/e4s/cuda/notarget /etc/e4s/cuda/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cpu
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/80
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && sed -i '/+level_zero: level-zero/a\          ^kokkos +cuda: cuda' /etc/spack/modules.yaml \
 && chmod go+rwX /etc/spack/modules.yaml \
 && spack module tcl refresh --delete-tree -y


## ROCM-950 SPACK INSTALL
FROM $ROCM_BASE_IMAGE AS spack-rocm-950

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-rocm-950-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-rocm-950-concretize /etc/e4s/rocm /etc/e4s/rocm
COPY --from=spack-rocm-notarget-concretize /etc/e4s/rocm/notarget /etc/e4s/rocm/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/rocm/gfx950
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/rocm/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y



## ROCM-942 SPACK INSTALL
FROM $ROCM_BASE_IMAGE AS spack-rocm-942

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-rocm-942-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-rocm-942-concretize /etc/e4s/rocm /etc/e4s/rocm
COPY --from=spack-rocm-notarget-concretize /etc/e4s/rocm/notarget /etc/e4s/rocm/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/rocm/gfx942
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/rocm/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y



## ROCM-90a SPACK INSTALL
FROM $ROCM_BASE_IMAGE AS spack-rocm-90a

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-rocm-90a-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-rocm-90a-concretize /etc/e4s/rocm /etc/e4s/rocm
COPY --from=spack-rocm-notarget-concretize /etc/e4s/rocm/notarget /etc/e4s/rocm/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/rocm/gfx90a
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/rocm/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y



## ROCM-908 SPACK INSTALL
FROM $ROCM_BASE_IMAGE AS spack-rocm-908

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-rocm-908-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-rocm-908-concretize /etc/e4s/rocm /etc/e4s/rocm
COPY --from=spack-rocm-notarget-concretize /etc/e4s/rocm/notarget /etc/e4s/rocm/notarget

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/rocm/gfx908
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/rocm/notarget
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y


## ONEAPI SPACK INSTALL
FROM $ONEAPI_BASE_IMAGE AS spack-oneapi

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-oneapi-gpu-concretize /etc/e4s/oneapi/_config /etc/e4s/oneapi/_config
COPY --from=spack-oneapi-gpu-concretize /etc/e4s/oneapi/gpu /etc/e4s/oneapi/gpu
COPY --from=spack-oneapi-cpu-concretize /etc/e4s/oneapi/cpu /etc/e4s/oneapi/cpu

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/oneapi/cpu
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/oneapi/gpu
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e intel-oneapi-mpi  \
 && spack module tcl refresh --delete-tree -y



## CPU SPACK INSTALL
FROM $CPU_BASE_IMAGE AS spack-cpu

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=etc /etc/e4s /etc/e4s
COPY --from=etc /etc/spack /etc/spack
COPY --from=spack-cpu-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-cpu-concretize /etc/e4s/cpu /etc/e4s/cpu

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cpu
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mark -e mpich \
 && spack module tcl refresh --delete-tree -y


 
FROM $FINAL_BASE_IMAGE AS final-base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

COPY --from=common_4_5 --chmod=0755 e4s-chain-spack.sh /etc/e4s/
COPY --from=release-common --chmod=0755 guacamole-start.sh /etc/e4s/

RUN rm -f /etc/apt/apt.conf.d/docker-clean \
 && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache \
 && ln -sf /etc/e4s/guacamole-start.sh /usr/local/bin/guacamole-start.sh \
 && ln -sf /etc/e4s/guacamole-start.sh /usr/local/bin/guacamole \
 && ln -sf /etc/e4s/e4s-chain-spack.sh /usr/local/bin/e4s-chain-spack.sh

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y \
 && apt install -y \
        bc \
        csh \
        git-lfs \
        imagemagick \
        libfreetype-dev \
        libfuse-dev \
        libfuse3-dev \
        libglib2.0-0 \
        libhdf5-dev \
        libjpeg-dev \
        libpng-dev \
        libqt5gui5 \
        libxcb*dev \
        libxi-dev \
        libxrender-dev \
        libxtst-dev \
        mesa-utils \
        moreutils \
        openjdk-11-jdk \
        pkg-config \
        python3-tk \
        sox \
        tcsh \
        xdg-utils \
        xterm \
        zsh \
        xfce4 \
        xfce4-terminal \
        tigervnc-standalone-server \
        tigervnc-tools \
        dbus-x11 \
        xauth \
        fonts-dejavu-core \
&& apt autoremove -y

# Disabled: https://github.com/E4S-Project/e4s/issues/172
# RUN curl -fsSL https://ollama.com/install.sh | sh

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    cd /tmp \
 && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg -o /tmp/google-cloud-sdk.gpg \
 && gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg /tmp/google-cloud-sdk.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list \
 && apt update -y \
 && apt install -y google-cloud-cli

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    cd /tmp \
 && version=1.121.03429 \
 && debfile="codium_"$version"_amd64.deb" \
 && wget -q https://github.com/VSCodium/vscodium/releases/download/$version/$debfile \
 && dpkg -i $debfile \
 && rm $debfile

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt install -y software-properties-common \
 && add-apt-repository ppa:mozillateam/ppa \
 && apt update -y \
 && apt remove -y firefox \
 && apt install -y firefox-esr \
 && ln -s /usr/bin/firefox-esr /usr/bin/firefox

COPY /install-paraview-visit.sh /
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /install-paraview-visit.sh \
 && rm -f /install-paraview-visit.sh
 
COPY --from=release-common install-nodejs.sh /
RUN /install-nodejs.sh \
 && rm -f /install-nodejs.sh

COPY --from=release-common install-npm-packages.sh /
RUN /install-npm-packages.sh \
 && rm -f /install-npm-packages.sh

RUN cd /opt \
 && wget -q http://tau.uoregon.edu/demo.tgz \
 && tar xzf demo.tgz \
 && rm -rf demo.tgz \
 && sed -i 's@load tau@load tau/2.36-cuda@g' /opt/demo/CoMD/bin/rt.sh \
 && cd /opt/demo \
 && git clone --quiet https://github.com/ParaToolsInc/e4s-cloud-examples.git \
 && rm -rf e4s-cloud-examples/.git \
 && (cd e4s-cloud-examples && ./fetch-all.sh)

COPY --from=release-common julia/examples /opt/demo/julia-examples

ENV TF_CPP_MIN_LOG_LEVEL=2
ENV PYTHONWARNINGS="ignore::FutureWarning,ignore::DeprecationWarning,ignore::RuntimeWarning,ignore::SyntaxWarning"
ENV TIKTOKEN_ENCODINGS_BASE=/etc/encodings

ENTRYPOINT ["/bin/bash", "--rcfile", "/etc/bash.bashrc"]



FROM final-base AS final-cuda-base

RUN cd /tmp \
 && runfile_13_0_3=cuda_13.0.3_580.126.20_linux.run \
 && wget -q https://developer.download.nvidia.com/compute/cuda/13.0.3/local_installers/$runfile_13_0_3 \
 && sh $runfile_13_0_3 --toolkit --silent \
 && rm -rf $runfile_13_0_3

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb \
 && dpkg -i cuda-keyring_1.1-1_all.deb \
 && rm -f cuda-keyring_1.1-1_all.deb \
 && apt update -y \
 && apt install -y \
     libnccl2=2.30.7-1+cuda12.9 \
     libnccl-dev=2.30.7-1+cuda12.9 \
 && apt-mark hold libnccl2 libnccl-dev

RUN cd /tmp \
 && cudnn_name=cudnn-linux-x86_64-9.22.0.52_cuda13-archive \
 && cudnn_tarball=$cudnn_name.tar.xz \
 && wget -q https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.22.0.52_cuda13-archive.tar.xz \
 && tar xf $cudnn_tarball \
 && cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda-13.0/include \
 && cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda-13.0/lib64 \
 && chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda-13.0/lib64/libcudnn* || true \
 && rm -rf $cudnn_tarball cudnn-*-archive

RUN debfile=nvshmem-local-repo-ubuntu2404-3.7.2_3.7.2-1_amd64.deb \
 && wget -q https://developer.download.nvidia.com/compute/nvshmem/3.7.2/local_installers/$debfile \
 && dpkg -i $debfile \
 && rm -rf $debfile \
 && cp /var/nvshmem-local-repo-ubuntu2404-3.7.2/nvshmem-*-keyring.gpg /usr/share/keyrings/ \
 && apt update -y \
 && apt install -y libnvshmem3-cuda-12 libnvshmem3-dev-cuda-12 \
 && apt-mark hold libnvshmem3-cuda-12 libnvshmem3-dev-cuda-12 

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-cuda.sh /
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cuda.sh \
 && rm -f /install-python-pkgs-cuda.sh

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
COPY /install-julia-pkgs-cuda.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-cuda.sh \
 && rm -f /install-julia-pkgs-cuda.sh

# Hermes Agent (UI is reached through guacamole). User-facing scripts live in /etc/e4s and are
# symlinked into place; the install script only installs the application.
COPY --chmod=0755 --from=release-common hermes-wrapper.sh hermes-init.sh hermes-ui.sh /etc/e4s/
COPY --from=release-common hermes.desktop /etc/e4s/
RUN ln -sf /etc/e4s/hermes-wrapper.sh /usr/local/bin/hermes \
 && ln -sf /etc/e4s/hermes-ui.sh /usr/local/bin/hermes-ui \
 && ln -sf /etc/e4s/hermes.desktop /usr/share/applications/hermes.desktop
COPY --chmod=0755 --from=release-common install-hermes.sh /
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /install-hermes.sh \
 && rm -f /install-hermes.sh

# Orca IDE (GUI is reached through guacamole): upstream's package, plus the E4S orca-ide
# dispatcher (/usr/local/bin) and desktop entry, all installed by install-orca.sh.
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    bash /tmp/e4s-common/install-orca.sh

COPY --from=release-common install-npm-packages-openclaw.sh /
RUN /install-npm-packages-openclaw.sh \
 && rm -f /install-npm-packages-openclaw.sh

COPY --from=release-common install-ollama.sh /tmp/install-ollama.sh
RUN ollama_installer=/tmp/install-ollama.sh \
 && curl -fsSL https://ollama.com/install.sh --output $ollama_installer \
 && sed -i '/install_cuda_driver_apt() {/a echo Skipping NVIDIA driver install && return' $ollama_installer \
 && sed -i '/install_cuda_driver_yum() {/a echo Skipping NVIDIA driver install && return' $ollama_installer \
 && chmod +x $ollama_installer \
 && $ollama_installer \
 && rm $ollama_installer


## FINAL CUDA 120
FROM final-cuda-base AS final-cuda-120

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-cuda120

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-120 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-120 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-120 /etc/spack /etc/spack
COPY --from=spack-cuda-120 /etc/e4s /etc/e4s

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

WORKDIR /


## FINAL CUDA 90
FROM final-cuda-base AS final-cuda-90

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-cuda90

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-90 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-90 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-90 /etc/spack /etc/spack
COPY --from=spack-cuda-90 /etc/e4s /etc/e4s
 
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

WORKDIR /


## FINAL CUDA 80
FROM final-cuda-base AS final-cuda-80

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-cuda80

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-80 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-80 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-80 /etc/spack /etc/spack
COPY --from=spack-cuda-80 /etc/e4s /etc/e4s

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

WORKDIR /


## FINAL CUDA 80 FULL
FROM final-cuda-base AS final-cuda-80-full

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-cuda80-full

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-80-full $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-80-full $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-80-full /etc/spack /etc/spack
COPY --from=spack-cuda-80-full /etc/e4s /etc/e4s

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rX /etc/spack

WORKDIR /


## FINAL CPU
FROM final-base AS final-cpu

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-cpu

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-cpu.sh /
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cpu.sh \
 && rm -f /install-python-pkgs-cpu.sh

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
COPY /install-julia-pkgs-cpu.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-cpu.sh \
 && rm -f /install-julia-pkgs-cpu.sh

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cpu $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cpu $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cpu /etc/spack /etc/spack
COPY --from=spack-cpu /etc/e4s /etc/e4s

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=spack-env gnu/_config/packages.yaml /etc/spack/

COPY --chmod=0755 --from=release-common hermes-wrapper.sh hermes-init.sh hermes-ui.sh /etc/e4s/
COPY --from=release-common hermes.desktop /etc/e4s/
RUN ln -sf /etc/e4s/hermes-wrapper.sh /usr/local/bin/hermes \
 && ln -sf /etc/e4s/hermes-ui.sh /usr/local/bin/hermes-ui \
 && ln -sf /etc/e4s/hermes.desktop /usr/share/applications/hermes.desktop
COPY --chmod=0755 --from=release-common install-hermes.sh /
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /install-hermes.sh \
 && rm -f /install-hermes.sh

# Orca IDE (GUI is reached through guacamole): upstream's package, plus the E4S orca-ide
# dispatcher (/usr/local/bin) and desktop entry, all installed by install-orca.sh.
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    bash /tmp/e4s-common/install-orca.sh

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /


FROM final-base AS final-rocm-base

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-rocm.sh /
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-rocm.sh \
 && rm -f /install-python-pkgs-rocm.sh

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
COPY /install-julia-pkgs-rocm.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-rocm.sh \
 && rm -f /install-julia-pkgs-rocm.sh

COPY --chmod=0755 --from=release-common hermes-wrapper.sh hermes-init.sh hermes-ui.sh /etc/e4s/
COPY --from=release-common hermes.desktop /etc/e4s/
RUN ln -sf /etc/e4s/hermes-wrapper.sh /usr/local/bin/hermes \
 && ln -sf /etc/e4s/hermes-ui.sh /usr/local/bin/hermes-ui \
 && ln -sf /etc/e4s/hermes.desktop /usr/share/applications/hermes.desktop
COPY --chmod=0755 --from=release-common install-hermes.sh /
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /install-hermes.sh \
 && rm -f /install-hermes.sh

# Orca IDE (GUI is reached through guacamole): upstream's package, plus the E4S orca-ide
# dispatcher (/usr/local/bin) and desktop entry, all installed by install-orca.sh.
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    bash /tmp/e4s-common/install-orca.sh

## FINAL ROCM 950
FROM final-rocm-base AS final-rocm-950

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-rocm950

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-950 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-rocm-950 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-950 /etc/e4s /etc/e4s
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-rocm /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /

## FINAL ROCM 942
FROM final-rocm-base AS final-rocm-942

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-rocm942

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-942 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-rocm-942 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-942 /etc/e4s /etc/e4s
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-rocm /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /


## FINAL ROCM 90a
FROM final-rocm-base AS final-rocm-90a

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-rocm90a

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-90a $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-rocm-90a $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-90a /etc/e4s /etc/e4s
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-rocm /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /


## FINAL ROCM 908
FROM final-rocm-base AS final-rocm-908

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-rocm908

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-908 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-rocm-908 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-908 /etc/e4s /etc/e4s
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-rocm /etc/spack/packages.yaml /etc/spack/

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /


## FINAL ONEAPI
FROM final-base AS final-oneapi

ARG E4S_VERSION
ENV E4S_VERSION=$E4S_VERSION
ENV E4S_IID=ubuntu2404-x86_64-oneapi

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-oneapi $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-oneapi $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-oneapi /etc/spack /etc/spack
COPY --from=spack-oneapi /etc/e4s /etc/e4s

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-oneapi.sh /
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-oneapi.sh \
 && rm -f /install-python-pkgs-oneapi.sh

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
COPY /install-julia-pkgs-oneapi.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-oneapi.sh \
 && rm -f /install-julia-pkgs-oneapi.sh

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=spack-env oneapi/_config/packages.yaml /etc/spack/

COPY --chmod=0755 --from=release-common hermes-wrapper.sh hermes-init.sh hermes-ui.sh /etc/e4s/
COPY --from=release-common hermes.desktop /etc/e4s/
RUN ln -sf /etc/e4s/hermes-wrapper.sh /usr/local/bin/hermes \
 && ln -sf /etc/e4s/hermes-ui.sh /usr/local/bin/hermes-ui \
 && ln -sf /etc/e4s/hermes.desktop /usr/share/applications/hermes.desktop
COPY --chmod=0755 --from=release-common install-hermes.sh /
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /install-hermes.sh \
 && rm -f /install-hermes.sh

# Orca IDE (GUI is reached through guacamole): upstream's package, plus the E4S orca-ide
# dispatcher (/usr/local/bin) and desktop entry, all installed by install-orca.sh.
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    bash /tmp/e4s-common/install-orca.sh

COPY --from=release-common /install-taucmdr.sh /tmp/install-taucmdr.sh
RUN /tmp/install-taucmdr.sh && rm -f /tmp/install-taucmdr.sh

ARG S3_ENDPOINT
ARG SPACK_MIRROR
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack mirror add --scope site --s3-endpoint-url $S3_ENDPOINT E4S $SPACK_MIRROR \
 && spack buildcache keys -ity

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh
RUN --mount=type=bind,from=release-common,target=/tmp/e4s-common \
    bash /tmp/e4s-common/install-desktop-entries.sh

RUN updatedb

RUN chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /
