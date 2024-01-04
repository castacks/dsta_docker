ARG base_image=yaoyuh/ngc_x86_dsta:22.08_10_opencv_override
FROM ${base_image}

# This resolve some dependency issues.
RUN pip3 install --no-cache-dir \
    markdown-it-py==2.2.0

RUN pip3 install --no-cache-dir \
    graphviz \
    pycuda \
    lightning \
    pytorch-lightning \
    onnxruntime-gpu \
    deform_conv2d_onnx_exporter \
    wandb

RUN pip3 install -U \
    jsonargparse[signatures]>=4.17

# Entrypoint command
CMD /bin/bash