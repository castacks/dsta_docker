# Author:
# Yaoyu Hu <yaoyuh@andrew.cmu.edu>
#
# Date:
# 2021-12-28

# Arguments.
ARG base_image

FROM ${base_image}

# Add a user with the same user_id as the user outside the container

ARG user_id
ARG user_name
ARG group_id
ARG group_name

RUN echo "user_id=${user_id}" \
 && echo "user_name=${user_name}" \
 && echo "group_od=${group_id}" \
 && echo "group_name=${group_name}"

# Install sudo.
RUN apt-get update \
 && apt-get install --no-install-recommends -y sudo \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Create new group if it doesn't already exist.
RUN ["/bin/bash", "-c", "if [[ -z \"$(getent group ${group_id})\" ]]; then groupadd -g ${group_id} ${group_name}; fi"]

# Create a new user.
RUN useradd --uid ${user_id} --gid ${group_id} -ms /bin/bash ${user_name} \
 && echo "${user_name}:${user_name}" | chpasswd \
 && adduser ${user_name} sudo \
 && echo "${user_name} ALL=NOPASSWD: ALL" >> /etc/sudoers.d/${user_name}

# run as the developer user
USER ${user_name}

# Configure the .bashrc file.
RUN touch /home/${user_name}/.tmux.conf \
 && echo 'set -g mouse on' >> /home/${user_name}/.tmux.conf

# Configure ROS as needed.
# For the additional catkin build argument: https://github.com/ysl208/iRoPro/issues/59
RUN echo 'alias beginROSBase="source /opt/ros/noetic/setup.bash"' >> /home/${user_name}/.bashrc \
 && echo 'alias beginROS="source /ros_ws/devel/setup.bash"' >> /home/${user_name}/.bashrc \
 && echo 'alias cb="catkin build -DPYTHON_EXECUTABLE=/usr/bin/python3"' >> /home/${user_name}/.bashrc

# running container start dir
WORKDIR /home/${user_name}