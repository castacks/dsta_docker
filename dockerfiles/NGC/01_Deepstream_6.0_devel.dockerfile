FROM nvcr.io/nvidia/deepstream:6.0-devel

# Key rotation.
RUN rm /etc/apt/sources.list.d/cuda.list \
 && apt-key del 7fa2af80 \
 && wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb \
 && dpkg -i cuda-keyring_1.0-1_all.deb

# Priliminary packages.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        build-essential \
        sudo \
        apt-utils \
        software-properties-common \
 && add-apt-repository ppa:deadsnakes/ppa -y \
 && apt-get update \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Allow using GUI apps.
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y tzdata \
 && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Useful tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        cmake \
        cppcheck \
        gdb \
        git \
        vim \
        wget \
        curl \
        less \
        htop \
        libsm6 libxext6 \
        virtualenv \
        libboost-all-dev zlib1g-dev \
        lsb-release \
        tmux \
        python3-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Entrypoint command
CMD /bin/bash