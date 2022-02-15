ARG base_image
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
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
 && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Useful tools
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        cppcheck \
        gdb \
        git \
        sudo \
        vim \
        wget \
        curl \
        less \
        htop \
        python3-pip \
        python-tk \
        libsm6 libxext6 \
        libboost-all-dev zlib1g-dev \
        lsb-release \
        libatlas-base-dev libflann-dev libmetis-dev doxygen libyaml-cpp-dev \
        libgl1-mesa-glx \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# # allow using GUI apps
# ARG TERM=xterm
# ARG DEBIAN_FRONTEND=noninteractive
# RUN apt-get update \
#  && -E apt-get install -y tzdata \
#  && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
#  && dpkg-reconfigure --frontend noninteractive tzdata \
#  && apt-get clean

# entrypoint command
CMD /bin/bash
