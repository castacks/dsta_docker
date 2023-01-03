#!/bin/bash

source ~/version_info.sh

ECHO_PREFIX=">>>"

function pip3_install_if_not_already_installed()
{
	local PKG_NAME=$1
	local PIP_CODE=$2

	local GREP_OUTPUT=$(pip3 list | grep ${PKG_NAME})

	if [ -z "${GREP_OUTPUT}" ]
	then
		echo "${ECHO_PREFIX} Installing ${PKG_NAME}..."
		pip3 install --no-cache-dir ${PIP_CODE}
	else
		echo "${ECHO_PREFIX} ${GREP_OUTPUT} found from the base image. Skip installing ${PKG_NAME}. "
	fi
}

pip3 install --no-cache-dir \
	torch-scatter \
	torch-sparse \
	torch-cluster \
	torch-spline-conv \
	torch-geometric \
	-f https://data.pyg.org/whl/${VI_PYG_ARCHIVE_CODE}.html

# pip3 install --no-cache-dir \
#     ${VI_CUPY_PIP_CODE}

pip3_install_if_not_already_installed cupy ${VI_CUPY_PIP_CODE}
