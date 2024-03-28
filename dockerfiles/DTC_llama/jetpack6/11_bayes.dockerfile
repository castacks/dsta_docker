ARG base_image=yaoyuh/dtc_llama:10_llama
FROM ${base_image}

# Some packages are already installed in the base image.
# Re-install them through pip may mess up the system, 
# e.g. opencv.
RUN pip3 install --no-cache-dir \
    pgmpy

# Entrypoint command
CMD /bin/bash
