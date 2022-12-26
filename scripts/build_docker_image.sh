#!/bin/bash

# Input arguments.
DOCKER_FILE_RELATIVE_PATH=$1
DOCKERHUB_ACCOUNT=$2
PLATFORM=$3
NGC_VERSION=$4
DAA_TAG_BASE=$5
DAA_TAG_TARGET=$6
shift 6

# Constants.
ECHO_PREFIX=">>>"

# Handle optional arguments.
# https://stackoverflow.com/questions/59378368/bash-using-both-positional-and-optional-arguments-in-a-script
IMAGE_TAG_BASE=""
while getopts ":b:" flag
do
    case "${flag}" in
        b) # Base image tag is specified by overriding the composed one.
            echo "${ECHO_PREFIX} Override the base image tag. "
            IMAGE_TAG_BASE=${OPTARG}
            echo "${ECHO_PREFIX} IMAGE_TAG_BASE=${IMAGE_TAG_BASE}"
            ;;
    esac
done

# Figure out the folder structure.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${SCRIPT_DIR}/../dockerfiles/

# Use the relative path directly since we already cd to the directory.
DOCKER_FILE=${DOCKER_FILE_RELATIVE_PATH}

# Compose the base image tag.
if [ -z "$IMAGE_TAG_BASE" ]
then
    echo "${ECHO_PREFIX} Compose the base image tag from the metadata. "
    IMAGE_TAG_BASE=${DOCKERHUB_ACCOUNT}/ngc_${PLATFORM}_dsta:${NGC_VERSION}_${DAA_TAG_BASE}
else
    echo "${ECHO_PREFIX} Base image tag is overridden by the -b option to ${IMAGE_TAG_BASE}. "
fi
IMAGE_TAG_TARGET=${DOCKERHUB_ACCOUNT}/ngc_${PLATFORM}_dsta:${NGC_VERSION}_${DAA_TAG_TARGET}

echo "${ECHO_PREFIX} Building ${IMAGE_TAG_TARGET} from"
echo "${ECHO_PREFIX} ${IMAGE_TAG_BASE}"

# Build the image.
DOCKER_BUILDKIT=1 docker build \
    -f ${DOCKER_FILE} \
    -t ${IMAGE_TAG_TARGET} \
    --build-arg base_image=${IMAGE_TAG_BASE} \
    .

echo "${ECHO_PREFIX} $0 done. "