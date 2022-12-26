#!/bin/bash

# Include common functions.
source ./common/architecture.sh

# Input arguments.
DOCKERHUB_ACCOUNT=$1
NGC_VERSION=$2

ECHO_PREFIX=">>>"

# Detect the system architecture.
ARCH=$(get_docker_arch)

if [ "${ARCH}" == "x86" ]; then
    echo "${ECHO_PREFIX} Build for ${ARCH}. "
    ./build_x86_images.sh ${DOCKERHUB_ACCOUNT} ${NGC_VERSION}
else
    # Duplicate line for debug purpose.
    echo "${ECHO_PREFIX} Build for ${ARCH}. "
    ./build_arm_images.sh ${DOCKERHUB_ACCOUNT} ${NGC_VERSION}
fi

echo ""
echo "${ECHO_PREFIX} $0 done. "