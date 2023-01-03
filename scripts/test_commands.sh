#!/bin/bash

DK_IMG=$(docker images --filter=reference="yaoyuh/*x86_dsta:22.09*" -q)

if [ -z "${DK_IMG}" ]
then
    echo "DK_IMG is empty"
else
    echo "${DK_IMG}"
    
fi
