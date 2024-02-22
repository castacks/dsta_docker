ARG base_image=ros:humble-perception
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
	
# Entrypoint command
CMD /bin/bash