# check=skip=InvalidDefaultArgInFrom

ARG SOURCE_IMAGE

FROM $SOURCE_IMAGE

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
 
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
 && wget --quiet https://repo.radeon.com/amdgpu-install/7.2.3/ubuntu/noble/amdgpu-install_7.2.3.70203-1_all.deb \
 && apt install -y ./amdgpu-install_7.2.3.70203-1_all.deb \
 && rm -f ./amdgpu-install_7.2.3.70203-1_all.deb \
 && apt update -y \
 && apt install -y \
      rocm \
      rocm-hip-libraries \
      rocm-hip-runtime \
      rocm-language-runtime \
      rocm-llvm-dev \
      rocm-ml-libraries \
      rocm-opencl-runtime

RUN echo /opt/rocm/lib > /etc/ld.so.conf.d/rocm.conf \
 && ldconfig -v

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt install -y libstdc++-14-dev

RUN updatedb

RUN echo export PATH=/opt/rocm/bin:'$PATH' >> /etc/bash.bashrc
ENV PATH=/opt/rocm/bin:$PATH
