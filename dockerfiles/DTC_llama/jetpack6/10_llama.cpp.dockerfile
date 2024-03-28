ARG base_image=yaoyuh/dtc_llama:04_ros2
FROM ${base_image}

# This docker fille needs to be used with out the build kit!
# DOCKER_BUILDKIT=0 docker build ...


# Some packages are already installed in the base image.
# Re-install them through pip may mess up the system, 
# e.g. opencv.
# The versioned dependencies are manually inspected from llama.cpp release b2331.
RUN pip3 install --no-cache-dir \
    ipdb \
    sentencepiece~=0.1.98 \
    "transformers>=4.35.2,<5.0.0" \
    gguf>=0.1.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ccache \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /llama \
 && cd /llama \
 && git clone --branch b2542 https://github.com/ggerganov/llama.cpp.git \
 && mkdir build \
 && cd build \
 && cmake \
    -DCMAKE_INSTALL_PREFIX=/usr/local/llama \
    -DBUILD_SHARED_LIBS=ON \
    -DLLAMA_CUBLAS=ON \
    -DLLAMA_BUILD_TESTS=OFF \
    -DLLAMA_BUILD_EXAMPLES=ON \
    ../llama.cpp \
 && cmake --build . --config Release -j6
#  && cmake --install . \
#  && cp ./common/libcommon.a /usr/local/llama/lib \
#  && cd ..
#  && rm -rf build

# Entrypoint command
CMD /bin/bash
