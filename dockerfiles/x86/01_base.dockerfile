ARG base_image=nvcr.io/nvidia/pytorch:22.08-py3
FROM ${base_image}

# Allow using GUI apps.
# ENV TERM=xterm
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
 && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common \
    tmux \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# For torch import error:
# /opt/hpcx/ompi/lib/libmpi.so.40: undefined symbol: opal_hwloc201_hwloc_get_type_depth
# Solution:
# https://forums.developer.nvidia.com/t/issues-building-docker-image-from-ngc-container-nvcr-io-nvidia-pytorch-22-py3/209034/4
# https://forums.developer.nvidia.com/t/unable-to-import-pytorch/154016
ENV PATH="/opt/hpcx/ompi/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/hpcx/ompi/lib:${LD_LIBRARY_PATH}"
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libopenblas-base libopenmpi-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
	
# Entrypoint command
CMD /bin/bash