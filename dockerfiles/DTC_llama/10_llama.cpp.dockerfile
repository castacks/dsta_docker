ARG base_image=yaoyuh/ngc_x86_dtc_llama:24.02_03_ros2
FROM ${base_image}

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ccache \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /llama \
 && cd /llama \
 && git clone --branch b2531-static https://github.com/huyaoyu/llama.cpp.git \
 && mkdir build \
 && cd build \
 && cmake \
    -DCMAKE_INSTALL_PREFIX=/usr/local/llama \
    -DLLAMA_CUBLAS=ON \
    -DLLAMA_BUILD_TESTS=OFF \
    -DLLAMA_BUILD_EXAMPLES=OFF \
    -DBUILD_SHARED_LIBS=ON \
    ../llama.cpp \
 && cmake --build . --config Release -j6 \
 && cmake --install . \
 && cp ./common/libcommon.a /usr/local/llama/lib \
 && cd ..
#  && rm -rf build

# Entrypoint command
CMD /bin/bash