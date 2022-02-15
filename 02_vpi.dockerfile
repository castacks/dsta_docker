ARG base_image
FROM ${base_image}

# Install GCC 8.
# https://linuxize.com/post/how-to-install-gcc-compiler-on-ubuntu-18-04/
RUN apt-get update \
 && apt-get install -y gcc-8 g++-8 \
 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 80 --slave /usr/bin/g++ g++ /usr/bin/g++-8 --slave /usr/bin/gcov gcov /usr/bin/gcov-8 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Public key for the VPI repository.
RUN apt-get update \
 && apt-get install -y --no-install-recommends gnupg libopencv-dev \
 && apt-key adv --fetch-key https://repo.download.nvidia.com/jetson/jetson-ota-public.asc \
 && apt-get install -y --no-install-recommends software-properties-common \
 && add-apt-repository 'deb https://repo.download.nvidia.com/jetson/x86_64 bionic r32.5' \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    libnvvpi1 vpi1-dev vpi1-samples \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# entrypoint command
CMD /bin/bash
