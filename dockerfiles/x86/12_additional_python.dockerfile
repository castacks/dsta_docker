ARG base_image=yaoyuh/ngc_x86_dsta:22.08_10_opencv_override
FROM ${base_image}

RUN pip3 install --no-cache-dir \
    empy \
    jsonargparse

# Entrypoint command
CMD /bin/bash