ARG base_image=yaoyuh/ngc_arm_dsta:22.12_pre_01_base
FROM ${base_image}

RUN pip3 install --no-cache-dir \
    pyquaternion \
    pytransform3d \
    ipympl

# Entrypoint command
CMD /bin/bash