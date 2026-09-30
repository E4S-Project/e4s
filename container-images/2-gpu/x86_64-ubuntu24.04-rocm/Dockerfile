# check=skip=InvalidDefaultArgInFrom

ARG SOURCE_IMAGE

FROM $SOURCE_IMAGE

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
 
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
 && debfile=amdgpu-install_7.2.4.70204-1_all.deb \
 && wget --quiet  https://repo.radeon.com/amdgpu-install/7.2.4/ubuntu/noble/$debfile \
 && apt install -y ./$debfile \
 && rm -f ./$debfile \
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

RUN echo --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13 >> /opt/rocm/lib/llvm/bin/rocm.cfg

# Not sure why this was ever added. Commenting out for now...
# RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     --mount=type=cache,target=/var/lib/apt,sharing=locked \
#     apt install -y libstdc++-14-dev

RUN updatedb

RUN echo export PATH=/opt/rocm/bin:'$PATH' >> /etc/bash.bashrc
ENV PATH=/opt/rocm/bin:$PATH

ARG E4S_ROCM_VERSION
LABEL E4S_ROCM_VERSION=$E4S_ROCM_VERSION
