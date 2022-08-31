ARG base_image
FROM ${base_image}

# Backward.
RUN apt-get update \
 && apt install -y --no-install-recommends \
    binutils-dev libdw-dev libdwarf-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir backward-cpp \
 && cd backward-cpp \
 && git clone https://github.com/bombela/backward-cpp.git backward-cpp \
 && mkdir build \
 && cd build \
 && cmake ../backward-cpp \
 && make \
 && make install \
 && cd ../.. \
 && rm -rf backward-cpp

# Entrypoint command
CMD /bin/bash