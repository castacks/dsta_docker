#!/bin/bash

source ~/version_info.sh

pip3 install --no-cache-dir \
	torch-scatter \
	torch-sparse \
	torch-cluster \
	torch-spline-conv \
	torch-geometric \
	-f https://data.pyg.org/whl/${VI_PYG_ARCHIVE_CODE}.html

pip3 install --no-cache-dir \
    ${VI_CUPY_PIP_CODE}