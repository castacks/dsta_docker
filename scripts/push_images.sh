#!/bin/bash

# Include common functions.
source ./common/architecture.sh

# Input arguments.
DOCKERHUB_ACCOUNT=$1
NGC_VERSION=$2

ECHO_PREFIX=">>>"

# Detect the system architecture.
ARCH=$(get_docker_arch)

# Get the list of images to push.
IMGS=$(docker images --filter=reference="${DOCKERHUB_ACCOUNT}/*${ARCH}_dsta:${NGC_VERSION}*" --format "{{.Repository}}:{{.Tag}}")

for IMG in ${IMGS}
do
    if [[ ! ${IMG} =~ "_99_local" ]]
    then
        echo "${ECHO_PREFIX} Pushing ${IMG}..."
        docker push ${IMG}
    fi
done

echo ""
echo "${ECHO_PREFIX} $0 done. "
