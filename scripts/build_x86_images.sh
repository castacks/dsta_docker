#!/bin/bash

# Input arguments.
DOCKERHUB_ACCOUNT=$1
NGC_VERSION=$2

# Constants.
PLATFORM=x86
ECHO_PREFIX=">>>"

# Helper function.
function build_one_image()
{
    # Input argument list.
    local DOCKERHUB_ACCOUNT=$1
    local PLATFORM=$2
    local NGC_VERSION=$3
    local DOCKER_FILE=$4
    local BASE_IMAGE_NAME=$5
    local IMAGE_NAME=$6
    local DASH_B_OPTION=$7

    if [ -z ${DASH_B_OPTION} ]
    then
        DASH_B_OPTION=""
    else
        DASH_B_OPTION="-b ${DASH_B_OPTION}"
    fi

    local DK_IMG=$(docker images --filter=reference="${DOCKERHUB_ACCOUNT}/*${PLATFORM}_dsta:${NGC_VERSION}_${IMAGE_NAME}*" -q)
    
    echo ""

    if [ -z ${DK_IMG} ]
    then
        echo "${ECHO_PREFIX} Building ${IMAGE_NAME}..."

        ./build_docker_image.sh \
            ${DOCKER_FILE} \
            ${DOCKERHUB_ACCOUNT} \
            ${PLATFORM} \
            ${NGC_VERSION} \
            ${BASE_IMAGE_NAME} \
            ${IMAGE_NAME} \
            ${DASH_B_OPTION}

    else
        echo "${ECHO_PREFIX} Image for ${IMAGE_NAME} already exists. Skip this one. "
    fi

    echo ""
}

# Tree of images.
DOCKER_FILE_01=x86/01_base.dockerfile
IMAGE_NAME_01_BASE=01_base

DOCKER_FILE_02=x86/02_python.dockerfile
IMAGE_NAME_02_PYTHON=02_python

DOCKER_FILE_03=x86/03_cuda_torch_dependent.dockerfile
IMAGE_NAME_03_CUDA_TORCH_DEP=03_cuda_torch_dependent

DOCKER_FILE_04=x86/04_ros.dockerfile
IMAGE_NAME_04_ROS=04_ros

# This seems OK on x86. But may have issues on Jetson devices.
DOCKER_FILE_10=x86/10_opencv_override.dockerfile
IMAGE_NAME_10_OPENCV_OVERRIDE=10_opencv_override

IMAGE_NAME_LAST_ROOT=${IMAGE_NAME_10_OPENCV_OVERRIDE}

# For adding a user.
IMAGE_NAME_99_LOCAL=99_local

echo "============================================================"
echo "Build the images for the ${PLATFORM} platform. "
echo "============================================================"
echo ""

# Build the images in order.

build_one_image \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    ${DOCKER_FILE_01} \
    py3 \
    ${IMAGE_NAME_01_BASE} \
    nvcr.io/nvidia/pytorch:${NGC_VERSION}-py3

build_one_image \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    ${DOCKER_FILE_02} \
    ${IMAGE_NAME_01_BASE} \
    ${IMAGE_NAME_02_PYTHON} \
    ""

build_one_image \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    ${DOCKER_FILE_03} \
    ${IMAGE_NAME_02_PYTHON} \
    ${IMAGE_NAME_03_CUDA_TORCH_DEP} \
    ""

build_one_image \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    ${DOCKER_FILE_04} \
    ${IMAGE_NAME_03_CUDA_TORCH_DEP} \
    ${IMAGE_NAME_04_ROS} \
    ""

build_one_image \
    ${DOCKERHUB_ACCOUNT} \
    ${PLATFORM} \
    ${NGC_VERSION} \
    ${DOCKER_FILE_10} \
    ${IMAGE_NAME_04_ROS} \
    ${IMAGE_NAME_10_OPENCV_OVERRIDE} \
    ""

echo ""
echo "${ECHO_PREFIX} Building ${IMAGE_NAME_99_LOCAL}..."
echo ""

./add_user_2_image.sh \
    ${DOCKERHUB_ACCOUNT}/ngc_${PLATFORM}_dsta:${NGC_VERSION}_${IMAGE_NAME_LAST_ROOT} \
    ${DOCKERHUB_ACCOUNT}/ngc_${PLATFORM}_dsta:${NGC_VERSION}_${IMAGE_NAME_99_LOCAL}

# List all the images that have been built.
echo ""
echo "The images that built for ${PLATFORM} platform with NGC version ${NGC_VERSION}: "
echo "=========="
docker images --filter=reference="${DOCKERHUB_ACCOUNT}/*${PLATFORM}_dsta:${NGC_VERSION}*"

echo ""
echo "${ECHO_PREFIX} $0 done. "