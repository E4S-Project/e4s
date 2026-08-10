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
COPY --from=spack-env gnu/cuda/120_driver_reqd /etc/e4s/cuda/120_driver_reqd
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/120
RUN /etc/e4s/concretize-spack-env.sh

WORKDIR /etc/e4s/cuda/120_driver_reqd
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
COPY --from=spack-env gnu/cuda/90_driver_reqd /etc/e4s/cuda/90_driver_reqd
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/90
RUN /etc/e4s/concretize-spack-env.sh

WORKDIR /etc/e4s/cuda/90_driver_reqd
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
COPY --from=spack-env gnu/cuda/80_driver_reqd /etc/e4s/cuda/80_driver_reqd
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cuda/80
RUN /etc/e4s/concretize-spack-env.sh

WORKDIR /etc/e4s/cuda/80_driver_reqd
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

WORKDIR /etc/e4s/cuda/notarget
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

WORKDIR /etc/e4s/rocm/notarget
RUN /etc/e4s/concretize-spack-env.sh


## ONEAPI GPU SPACK CONCRETIZE
FROM $ONEAPI_BASE_IMAGE AS spack-oneapi-gpu-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env oneapi/_config /etc/e4s/_config
COPY --from=spack-env oneapi/gpu /etc/e4s/gpu
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/gpu
RUN /etc/e4s/concretize-spack-env.sh


## ONEAPI CPU SPACK CONCRETIZE
FROM $ONEAPI_BASE_IMAGE AS spack-oneapi-cpu-concretize

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-complete $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-complete $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-env oneapi/_config /etc/e4s/_config
COPY --from=spack-env oneapi/cpu /etc/e4s/cpu
COPY --from=etc /etc/e4s/utilities.sh /etc/e4s
COPY --from=etc /etc/e4s/concretize-spack-env.sh /etc/e4s

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cpu
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

WORKDIR /etc/e4s/cpu
RUN . $SPACK_CORE_ROOT/share/spack/setup-env.sh \
 && spack -e . remove 'paraview +qt' \
 && spack -e . concretize | tee concretize.log \
 && /etc/e4s/concretize-spack-env.sh


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

WORKDIR /etc/e4s/cuda/120_driver_reqd
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

WORKDIR /etc/e4s/cuda/90_driver_reqd
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

WORKDIR /etc/e4s/cuda/80_driver_reqd
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/cuda/notarget
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
COPY --from=spack-oneapi-gpu-concretize /etc/e4s/_config /etc/e4s/_config
COPY --from=spack-oneapi-gpu-concretize /etc/e4s/gpu /etc/e4s/gpu
COPY --from=spack-oneapi-cpu-concretize /etc/e4s/cpu /etc/e4s/cpu

ARG SPACK_MIRROR
ARG S3_ENDPOINT

WORKDIR /etc/e4s/cpu
RUN --mount=type=secret,id=AWS_CONFIG_FILE,required=true \
    /etc/e4s/install-spack-packages.sh

WORKDIR /etc/e4s/gpu
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

RUN rm -f /etc/apt/apt.conf.d/docker-clean \
 && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

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

RUN cd /opt \
 && wget -q http://tau.uoregon.edu/demo.tgz \
 && tar xzf demo.tgz \
 && rm -rf demo.tgz \
 && sed -i 's@load tau@load tau/2.35.2-cuda@g' /opt/demo/CoMD/bin/rt.sh \
 && cd /opt/demo \
 && git clone --quiet https://github.com/ParaToolsInc/e4s-cloud-examples.git \
 && rm -rf e4s-cloud-examples/.git \
 && (cd e4s-cloud-examples && ./fetch-all.sh)

COPY --from=release-common julia/examples /opt/demo/julia-examples

RUN chmod -R o+rX /root \
 && chmod -R g+rwX /root

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
     libnccl2=2.28.9-1+cuda12.9 \
     libnccl-dev=2.28.9-1+cuda12.9 \
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

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-cuda.sh /
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cuda.sh \
 && rm -f /install-python-pkgs-cuda.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
COPY /install-julia-pkgs-cuda.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-cuda.sh \
 && rm -f /install-julia-pkgs-cuda.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root




## FINAL CUDA 120
FROM final-cuda-base AS final-cuda-120

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-120 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-120 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-120 /etc/spack /etc/spack
COPY --from=spack-cuda-120 /etc/e4s /etc/e4s

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R g+rwX /root

WORKDIR /


## FINAL CUDA 90
FROM final-cuda-base AS final-cuda-90

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-90 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-90 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-90 /etc/spack /etc/spack
COPY --from=spack-cuda-90 /etc/e4s /etc/e4s
 
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R g+rwX /root

WORKDIR /


## FINAL CUDA 80
FROM final-cuda-base AS final-cuda-80

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-80 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cuda-80 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cuda-80 /etc/spack /etc/spack
COPY --from=spack-cuda-80 /etc/e4s /etc/e4s

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-cuda /etc/spack/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R g+rwX /root

WORKDIR /


## FINAL CPU
FROM final-base AS final-cpu

ARG PY_TARBALL
ENV UV_LINK_MODE=copy
COPY /install-python-pkgs-cpu.sh /
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=bind,source=/downloads,target=/tmp/downloads \
    /install-python-pkgs-cpu.sh \
 && rm -f /install-python-pkgs-cpu.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
COPY /install-julia-pkgs-cpu.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-cpu.sh \
 && rm -f /install-julia-pkgs-cpu.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-cpu $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-cpu $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-cpu /etc/spack /etc/spack
COPY --from=spack-cpu /etc/e4s /etc/e4s

COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=spack-env gnu/_config/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R go+rwX /root \
 && chmod -R go+rwX /etc/e4s /etc/spack

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
 && rm -f /install-python-pkgs-rocm.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
COPY /install-julia-pkgs-rocm.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-rocm.sh \
 && rm -f /install-julia-pkgs-rocm.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root


## FINAL ROCM 942
FROM final-rocm-base AS final-rocm-942

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-942 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-rocm-942 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-942 /etc/e4s /etc/e4s
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-rocm /etc/spack/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R go+rwX /root \
 && chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /


## FINAL ROCM 90a
FROM final-rocm-base AS final-rocm-90a

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-90a $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-rocm-90a $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-90a /etc/e4s /etc/e4s
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-rocm /etc/spack/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R go+rwX /root \
 && chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /


## FINAL ROCM 908
FROM final-rocm-base AS final-rocm-908

ARG SPACK_CORE_ROOT
ARG SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-908 $SPACK_CORE_ROOT $SPACK_CORE_ROOT
COPY --from=spack-rocm-908 $SPACK_PACKAGES_ROOT $SPACK_PACKAGES_ROOT
COPY --from=spack-rocm-908 /etc/e4s /etc/e4s
COPY --from=container-common utilities.sh /etc/e4s/
COPY --from=etc-spack-rocm /etc/spack/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R go+rwX /root \
 && chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /


## FINAL ONEAPI
FROM final-base AS final-oneapi

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
 && rm -f /install-python-pkgs-oneapi.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV JULIA_CPU_TARGET='generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)'
COPY /install-julia-pkgs-oneapi.sh /
RUN --mount=type=cache,target=/root/.julia \
    /install-julia-pkgs-oneapi.sh \
 && rm -f /install-julia-pkgs-oneapi.sh \
 && chmod -R o+rX /root \
 && chmod -R g+rwX /root

ENV METRICS_SOURCE=/tmp/metrics-discovery
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y \
 && apt install -y libdrm-dev \
 && git clone https://github.com/intel/metrics-discovery.git $METRICS_SOURCE \
 && git -C $METRICS_SOURCE checkout 6752a06dea8b979b9827f675629f480778b560e2 \
 && mkdir -p $METRICS_SOURCE/build \
 && cd $METRICS_SOURCE/build \
 && cmake .. \
 && make -j \
 && make -j install \
 && rm -rf $METRICS_SOURCE

ENV METRICS_SOURCE=/tmp/metrics-library
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y \
 && apt install -y libdrm-dev \
 && git clone https://github.com/intel/metrics-library.git $METRICS_SOURCE \
 && git -C $METRICS_SOURCE checkout 1a8ab8667df9582aec346a7078c36ae4c5578743 \
 && mkdir -p $METRICS_SOURCE/build \
 && cd $METRICS_SOURCE/build \
 && cmake .. \
 && make -j \
 && make -j package \
 && dpkg -i intel-metrics-library*.deb \
 && rm -rf $METRICS_SOURCE

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y software-properties-common \
 && add-apt-repository -y ppa:kobuk-team/intel-graphics \
 && apt-get install -y \
    clinfo \
    intel-ocloc \
    intel-ocloc-dev \
    intel-opencl-icd


COPY --from=container-common utilities.sh /etc/e4s/ 
COPY --from=spack-env oneapi/_config/packages.yaml /etc/spack/
COPY --from=container-common e4s-chain-spack.sh /etc/e4s/

ARG IMAGE_TARGET

COPY /install-bashrc.sh /
RUN /install-bashrc.sh && rm /install-bashrc.sh

RUN updatedb

RUN git -C /spack-packages remote set-url origin https://github.com/spack/spack-packages

RUN chmod -R o+rX /root \
 && chmod -R go+rwX /root \
 && chmod -R go+rwX /etc/e4s /etc/spack

WORKDIR /
