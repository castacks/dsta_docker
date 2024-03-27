ARG base_image=nvcr.io/nvidia/l4t-ml:r36.2.0-py3
FROM ${base_image}

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
        gdb \
        git \
        vim \
        wget \
        curl \
        less \
        htop \
        tmux \
        python3-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
	
# Entrypoint command
CMD /bin/bash