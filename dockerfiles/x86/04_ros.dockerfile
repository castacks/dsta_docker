ARG base_image=yaoyuh/ngc_x86_dsta:22.08_03_cuda_torch_dependent
FROM ${base_image}

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ros-noetic-desktop-full \
 && apt-get install -y --no-install-recommends \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential \
 && rosdep init \
 && rosdep update\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    catkin_tools

# Entrypoint command
CMD /bin/bash