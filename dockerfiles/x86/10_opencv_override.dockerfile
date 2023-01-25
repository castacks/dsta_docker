ARG base_image=yaoyuh/ngc_x86_dsta:22.08_04_ros
FROM ${base_image}

# Install OpenCV manually may have some issues because the base image already has OpenCV installed.
# Especially for the Jetson devices.
# cv2.__file__ looks like
# /opt/conda/lib/python3.8/site-packages/cv2/python-3.8/cv2.cpython-38-x86_64-linux-gnu.so
RUN sudo rm -rf $(dirname $(dirname $(python -c "import cv2; print(cv2.__file__)"))) \
 && pip3 install --no-cache-dir \
    opencv-python opencv-contrib-python

# Entrypoint command
CMD /bin/bash