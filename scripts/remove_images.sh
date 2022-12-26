#!/bin/bash

# Include common functions.
source ./common/architecture.sh

# Input arguments.
DOCKERHUB_ACCOUNT=$1
NGC_VERSION=$2

# Detect the system architecture.
ARCH=$(get_docker_arch)

shift 3
while getopts ":c" flag
do
    case "${flag}" in
        c) # Confirm to remove.
            echo "Removing..."
            docker images --filter=reference="${DOCKERHUB_ACCOUNT}/*${ARCH}_dsta:${NGC_VERSION}*"
            docker rmi $(docker images --filter=reference="${DOCKERHUB_ACCOUNT}/*${ARCH}_dsta:${NGC_VERSION}*" -q)            
            exit;;
    esac
done

echo "===================================================="
echo "Dry run by default. Use -c to confirm the deletion. "
echo "===================================================="
echo ""

echo "The following images will be removed once -c option is used."
docker images --filter=reference="${DOCKERHUB_ACCOUNT}/*${ARCH}_dsta:${NGC_VERSION}*"