ARG base_image=yaoyuh/ngc_x86_dsta:22.12_02_python
FROM ${base_image}

# Copy version_helper.py
COPY version_helper.py /tmp/version_helper.py
COPY install_cuda_torch_dependent.sh /tmp/install_cuda_torch_dependent.sh

RUN pip3 install --no-cache-dir \
    monai \
    kornia

RUN cd /tmp \
 && python3 ./version_helper.py \
 && bash ./install_cuda_torch_dependent.sh

# Entrypoint command
CMD /bin/bash