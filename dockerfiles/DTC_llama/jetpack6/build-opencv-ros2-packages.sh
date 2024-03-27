#!/bin/bash

source /opt/ros/humble/setup.bash

mkdir -p /ros_ocv/src
cd /ros_ocv/src
git clone https://github.com/ros-perception/vision_opencv.git -b humble
git clone https://github.com/ros-perception/image_transport_plugins.git -b humble
cd ..
colcon build --symlink-install
