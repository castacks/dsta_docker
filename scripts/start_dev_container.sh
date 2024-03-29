#!/bin/bash

# Include common functions.
source ./common/architecture.sh

# This file is obtained from
# https://answers.ros.org/question/300113/docker-how-to-use-rviz-and-gazebo-from-a-container/
# and
# https://medium.com/intro-to-artificial-intelligence/rviz-on-docker-bdf4d0fca5b


# If not working, first do: sudo rm -rf /tmp/.docker.xauth
# It still not working, try running the script as root.

XAUTH=/tmp/.docker.xauth

echo "Preparing Xauthority data... "
xauth_list=$(xauth nlist :0 | tail -n 1 | sed -e 's/^..../ffff/')
if [ ! -f $XAUTH ]; then
    if [ ! -z "$xauth_list" ]; then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

echo "Done. "
echo ""
echo "Verifying file contents: "
file $XAUTH
echo "--> It should say \"X11 Xauthority data\"."
echo ""
echo "Permissions:"
ls -FAlh $XAUTH
echo ""
echo "Running docker... "

# Get the option for NVIDIA runtime.
DOCKER_RUN_NVIDIA=$(get_docker_nvidia_option)
echo "DOCKER_RUN_NVIDIA=${DOCKER_RUN_NVIDIA}"

docker run \
    -it \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$XAUTH:$XAUTH" \
    --volume="/external/home/${USER}/ros/:/ros_ws/" \
    --volume="/external/home/${USER}/data/:/data/" \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="XAUTHORITY=$XAUTH" \
    --env="NVIDIA_VISIBLE_DEVICES=all" \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --network host \
    --ipc host \
    --ulimit memlock=-1 \
    --ulimit stack=67108864 \
    --privileged \
    --group-add audio \
    --group-add video \
    --name mvs \
    ${DOCKER_RUN_NVIDIA} \
    $1 \
    /bin/bash

echo "Out of the container. "
