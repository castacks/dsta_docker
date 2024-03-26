ARG base_image=yaoyuh/ngc_x86_dtc_llama:24.02_01_base
FROM ${base_image}

# Some packages are already installed in the base image.
# Re-install them through pip may mess up the system, 
# e.g. opencv.
# The versioned dependencies are manually inspected from llama.cpp release b2331.
RUN pip3 install --no-cache-dir \
    ipdb \
    sentencepiece~=0.1.98 \
    "transformers>=4.35.2,<5.0.0" \
    gguf>=0.1.0

# Entrypoint command
CMD /bin/bash