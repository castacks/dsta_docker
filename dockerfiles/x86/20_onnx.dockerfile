ARG base_image=yaoyuh/ngc_x86_dsta:22.08_10_opencv_override
FROM ${base_image}

# Don't need --extra-index-url https://pypi.ngc.nvidia.com becase we are using NGC base images.
RUN pip3 install --no-cache-dir \
    colored \
    onnx_graphsurgeon

# Entrypoint command
CMD /bin/bash