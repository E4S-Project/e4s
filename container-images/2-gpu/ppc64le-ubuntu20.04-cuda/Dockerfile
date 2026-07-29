# check=skip=InvalidDefaultArgInFrom

ARG SOURCE_IMAGE

FROM $SOURCE_IMAGE

RUN --mount=type=bind,from=downloads,source=cuda_11.2.2_460.32.03_linux_ppc64le.run,target=cuda_11.2.2_460.32.03_linux_ppc64le.run \
    sh cuda_11.2.2_460.32.03_linux_ppc64le.run --toolkit --silent

RUN --mount=type=bind,from=downloads,source=cudnn-11.2-linux-ppc64le-v8.1.1.33.tgz,target=cudnn-11.2-linux-ppc64le-v8.1.1.33.tgz \
    tar xzf cudnn-11.2-linux-ppc64le-v8.1.1.33.tgz \
 && cp cuda/targets/ppc64le-linux/include/cudnn*.h /usr/local/cuda/include \
 && cp -P cuda/targets/ppc64le-linux/lib/libcudnn* /usr/local/cuda/lib64 \
 && chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn* \
 && rm -rf /cuda

RUN --mount=type=bind,from=downloads,source=nccl_2.8.4-1+cuda11.2_ppc64le.txz,target=nccl_2.8.4-1+cuda11.2_ppc64le.txz \
    tar xvf nccl_2.8.4-1+cuda11.2_ppc64le.txz \
 && mv nccl_2.8.4-1+cuda11.2_ppc64le /usr/local/nccl-2.8.4 \
 && echo /usr/local/nccl-2.8.4/lib > /etc/ld.so.conf.d/nccl-2.8.4.conf \
 && ldconfig -v >/dev/null 2>&1

RUN --mount=type=bind,from=downloads,source=TensorRT-7.2.0.13.Ubuntu-18.04.ppc64le-gnu.cuda-11.0.cudnn8.0.tar.gz,target=TensorRT-7.2.0.13.Ubuntu-18.04.ppc64le-gnu.cuda-11.0.cudnn8.0.tar.gz \
    tar xzf TensorRT-7.2.0.13.Ubuntu-18.04.ppc64le-gnu.cuda-11.0.cudnn8.0.tar.gz -C /usr/local \
 && echo /usr/local/TensorRT-7.2.0.13/lib > /etc/ld.so.conf.d/tensorrt-7.2.0.13.conf \
 && ldconfig -v >/dev/null 2>&1

RUN echo /usr/local/cuda/extras/CUPTI/lib64 > /etc/ld.so.conf.d/cupti.conf \
 && ldconfig -v >/dev/null 2>&1

RUN updatedb

ENV PATH=/usr/local/cuda/bin:$PATH
ENV CUPTI_ROOT=/usr/local/cuda/extras/CUPTI
