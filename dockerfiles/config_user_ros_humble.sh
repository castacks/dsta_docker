#!/bin/bash

user_name=$1

echo "Configuring user for ROS Humble. "
echo 'export PATH=/home/${user_name}/.local/bin:${PATH}'
echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib' >> /home/${user_name}/.bashrc
