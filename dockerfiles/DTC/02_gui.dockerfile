ARG base_image=theairlab/dtc_temp:01_base
FROM ${base_image}

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    gedit \
    ros-humble-rviz2 \
    ros-humble-compressed-image-transport \
    ros-humble-rqt \
    ros-humble-rqt-common-plugins \
    ros-humble-rosbag2-storage-mcap \
    net-tools \
    iproute2 \
    iputils-ping \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
	
# Entrypoint command
CMD /bin/bash
