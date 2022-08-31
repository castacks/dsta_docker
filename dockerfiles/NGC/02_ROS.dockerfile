ARG base_image
FROM ${base_image}

# ROS source.
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list \
 && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

# ROS.
RUN apt-get update \
 && apt-get install -y --no-install-recommends ros-melodic-desktop-full \
 && apt-get install  -y --no-install-recommends python-rosdep python-rosinstall python-rosinstall-generator python-wstool \
 && rosdep init \
 && rosdep update \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# catkin tools.
RUN wget http://packages.ros.org/ros.key -O - | apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    python3-catkin-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Entrypoint command
CMD /bin/bash