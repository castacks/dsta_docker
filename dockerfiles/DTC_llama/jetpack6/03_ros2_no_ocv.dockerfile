ARG base_image=yaoyuh/dtc_llama:02_ros2_base
FROM ${base_image}

COPY ros2-selective-install.sh /tmp/

RUN apt-get update \
 && /tmp/ros2-selective-install.sh \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Entrypoint command
CMD /bin/bash