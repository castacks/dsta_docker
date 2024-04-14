#!/bin/bash

BASE_IMAGE=$1
TARGET=$2

# Check the total number of arguments
if [ $# -eq 3 ]; then
    CONFIG_USER_SCRIPT=$3
else
    CONFIG_USER_SCRIPT=config_user_empty.sh
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOCKER_BUILD_CONTEXT_DIR=${SCRIPT_DIR}/../dockerfiles
DOCKER_FILE=add_user.dockerfile

GROUP_ID=$(id -g)
GROUP_NAME=$(id -gn)

echo "Add the following user info to Docker image $BASE_IMAGE: "
echo "user_id    = ${UID}"
echo "user_name  = ${USER}"
echo "group_id   = ${GROUP_ID}"
echo "group_name = ${GROUP_NAME}"

cd ${DOCKER_BUILD_CONTEXT_DIR}

DOCKER_BUILDKIT=1 docker build \
    -f ${DOCKER_FILE} \
    -t ${TARGET} \
    --build-arg base_image=${BASE_IMAGE} \
    --build-arg user_id=${UID} \
    --build-arg user_name=${USER} \
    --build-arg group_id=${GROUP_ID} \
    --build-arg group_name=${GROUP_NAME} \
    --build-arg config_user_script=${CONFIG_USER_SCRIPT} \
    .

echo "Done with adding user. "
