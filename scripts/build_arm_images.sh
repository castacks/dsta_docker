#!/bin/bash

# Input arguments.
DOCKERHUB_ACCOUNT=$1
NGC_VERSION=$2

# Constants.
PLATFORM=arm
ECHO_PREFIX=">>>"

# Tree of images.
IMAGE_NAME_PRE_01_BASE=pre_01_base
IMAGE_NAME_PRE_02_PYTHON=pre_02_python
IMAGE_NAME_PRE_99_LOCAL=pre_99_local

echo "============================================================"
echo "Build the images for the ${PLATFORM} platform. "
echo "============================================================"
echo ""

# Build the images in order.
# echo "${ECHO_PREFIX} Building ${IMAGE_NAME_PRE_01_BASE}..."
# echo ""

# ./build_docker_image.sh \
#     pre_processing/01_base.dockerfile \
#     ${DOCKERHUB_ACCOUNT} \
#     ${PLATFORM} \
#     ${NGC_VERSION} \
#     py3 \
#     ${IMAGE_NAME_PRE_01_BASE} \
#     -b nvcr.io/nvidia/pytorch:${NGC_VERSION}-py3

echo ""
echo "${ECHO_PREFIX} Building ${IMAGE_NAME_PRE_02_PYTHON}..."
echo ""

./build_docker_image.sh \
    pre_processing/02_python.dockerfile \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    ${IMAGE_NAME_PRE_01_BASE} \
    ${IMAGE_NAME_PRE_02_PYTHON}

echo ""
echo "${ECHO_PREFIX} Building ${IMAGE_NAME_PRE_99_LOCAL}..."
echo ""

./add_user_2_image.sh \
    ${DOCKERHUB_ACCOUNT}/ngc_${PLATFORM}_dsta:${NGC_VERSION}_${IMAGE_NAME_PRE_02_PYTHON} \
    ${DOCKERHUB_ACCOUNT}/ngc_${PLATFORM}_dsta:${NGC_VERSION}_${IMAGE_NAME_PRE_99_LOCAL}

# List all the images that have been built.
echo ""
echo "The images that built for ${PLATFORM} platform with NGC version ${NGC_VERSION}: "
echo "=========="
docker images --filter=reference="${DOCKERHUB_ACCOUNT}/*${PLATFORM}_dsta:${NGC_VERSION}*"

echo ""
echo "${ECHO_PREFIX} $0 done. "