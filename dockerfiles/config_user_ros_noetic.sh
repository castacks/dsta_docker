#!/bin/bash

user_name=$1

# Configure ROS as needed.
# For the additional catkin build argument: https://github.com/ysl208/iRoPro/issues/59
echo 'alias beginROSBase="source /opt/ros/noetic/setup.bash"' >> /home/${user_name}/.bashrc
echo 'alias beginROS="source /ros_ws/devel/setup.bash"' >> /home/${user_name}/.bashrc
echo 'alias cb="catkin build -DPYTHON_EXECUTABLE=/usr/bin/python3"' >> /home/${user_name}/.bashrc
