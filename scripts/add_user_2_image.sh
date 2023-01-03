#!/bin/bash

BASE_IMAGE=$1
TARGET=$2

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOCKER_FILE=${SCRIPT_DIR}/../dockerfiles/add_user.dockerfile

GROUP_ID=$(id -g)
GROUP_NAME=$(id -gn)

echo "Add the following user info to Docker image $BASE_IMAGE: "
echo "user_id    = ${UID}"
echo "user_name  = ${USER}"
echo "group_id   = ${GROUP_ID}"
echo "group_name = ${GROUP_NAME}"

DOCKER_BUILDKIT=1 docker build \
    -f ${DOCKER_FILE} \
    -t ${TARGET} \
    --build-arg base_image=${BASE_IMAGE} \
    --build-arg user_id=${UID} \
    --build-arg user_name=${USER} \
    --build-arg group_id=${GROUP_ID} \
    --build-arg group_name=${GROUP_NAME} \
    .

echo "Done with adding user. "
