ARG base_image=yaoyuh/ngc_x86_dsta:22.08_01_base
FROM ${base_image}

RUN pip3 install --no-cache-dir \
    numpy \
    scipy \
    scikit-image \
    scikit-learn \
    opencv-python \
    ipython \
    ipdb \
    pyquaternion \
    pytransform3d \
    ipympl \
    tqdm \
    pyyaml \
    colorcet \
    ninja \
    pandas

# Tricky ones.
RUN pip install llvmlite --ignore-installed \
 && pip3 install --no-cache-dir \
    numba==0.49.1

# Entrypoint command
CMD /bin/bash