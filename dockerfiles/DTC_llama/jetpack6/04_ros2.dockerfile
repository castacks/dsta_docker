ARG base_image=yaoyuh/dtc_llama:03_ros2_no_ocv
FROM ${base_image}

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libboost-python-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY build-opencv-ros2-packages.sh /tmp/

RUN /tmp/build-opencv-ros2-packages.sh

# Entrypoint command
CMD /bin/bash
