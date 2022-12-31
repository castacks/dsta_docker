#!/bin/bash

# Input arguments.
DOCKERHUB_ACCOUNT=$1
NGC_VERSION=$2

# Constants.
PLATFORM=x86
ECHO_PREFIX=">>>"

# Tree of images.
IMAGE_NAME_01_BASE=01_base
IMAGE_NAME_02_PYTHON=02_python
IMAGE_NAME_03_CUDA_TORCH_DEP=03_cuda_torch_dependent
IMAGE_NAME_04_ROS=04_ros
IMAGE_NAME_99_LOCAL=99_local

echo "============================================================"
echo "Build the images for the ${PLATFORM} platform. "
echo "============================================================"
echo ""

# Build the images in order.

echo "${ECHO_PREFIX} Building ${IMAGE_NAME_01_BASE}..."
echo ""

./build_docker_image.sh \
    x86/01_base.dockerfile \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    py3 \
    ${IMAGE_NAME_01_BASE} \
    -b nvcr.io/nvidia/pytorch:${NGC_VERSION}-py3

echo ""
echo "${ECHO_PREFIX} Building ${IMAGE_NAME_02_PYTHON}..."
echo ""

./build_docker_image.sh \
    x86/02_python.dockerfile \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    ${IMAGE_NAME_01_BASE} \
    ${IMAGE_NAME_02_PYTHON}

echo ""
echo "${ECHO_PREFIX} Building ${IMAGE_NAME_03_CUDA_TORCH_DEP}..."
echo ""

./build_docker_image.sh \
    x86/03_cuda_torch_dependent.dockerfile \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    ${IMAGE_NAME_02_PYTHON} \
    ${IMAGE_NAME_03_CUDA_TORCH_DEP}

echo ""
echo "${ECHO_PREFIX} Building ${IMAGE_NAME_04_ROS}..."
echo ""

./build_docker_image.sh \
    x86/04_ros.dockerfile \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    ${IMAGE_NAME_03_CUDA_TORCH_DEP} \
    ${IMAGE_NAME_04_ROS}

echo ""
echo "${ECHO_PREFIX} Building ${IMAGE_NAME_PRE_99_LOCAL}..."
echo ""

./add_user_2_image.sh \
    ${DOCKERHUB_ACCOUNT}/ngc_${PLATFORM}_dsta:${NGC_VERSION}_${IMAGE_NAME_04_ROS} \
    ${DOCKERHUB_ACCOUNT}/ngc_${PLATFORM}_dsta:${NGC_VERSION}_${IMAGE_NAME_99_LOCAL}

# List all the images that have been built.
echo ""
echo "The images that built for ${PLATFORM} platform with NGC version ${NGC_VERSION}: "
echo "=========="
docker images --filter=reference="${DOCKERHUB_ACCOUNT}/*${PLATFORM}_dsta:${NGC_VERSION}*"

echo ""
echo "${ECHO_PREFIX} $0 done. "