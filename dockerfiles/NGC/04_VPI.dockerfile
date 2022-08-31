ARG base_image
FROM ${base_image}

# https://forums.developer.nvidia.com/t/vpi-1-1-installation-on-x86/200727/3

RUN apt-get update \
 && apt install -y --no-install-recommends \
    gnupg \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --fetch-key https://repo.download.nvidia.com/jetson/jetson-ota-public.asc

RUN apt-get update \
 && apt install -y --no-install-recommends \
    software-properties-common \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# RUN sudo add-apt-repository 'deb https://repo.download.nvidia.com/jetson/x86_64 bionic r32.6 main'
RUN sudo add-apt-repository 'deb https://repo.download.nvidia.com/jetson/x86_64/bionic r32.6 main'

RUN apt-get update \
 && apt install -y --no-install-recommends \
    libnvvpi1 vpi1-dev vpi1-samples vpi1-demos \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Entrypoint command
CMD /bin/bash