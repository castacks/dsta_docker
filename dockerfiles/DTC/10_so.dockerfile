ARG base_image=theairlab/dtc_temp:02_gui
FROM ${base_image}

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    cmake \
    git \
    vim \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libparmetis-dev \
    ros-humble-velodyne-pointcloud \
    wget \
    zip \
    unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \ 
 && wget -q http://ceres-solver.org/ceres-solver-2.0.0.tar.gz \
 && tar zxf ceres-solver-2.0.0.tar.gz \
 && sed -i '435s/.*/"${TBB_INCLUDE_DIRS}\/tbb\/version.h"/' ceres-solver-2.0.0/cmake/FindTBB.cmake \
 && mkdir ceres-bin \
 && cd ceres-bin \
 && cmake ../ceres-solver-2.0.0 \
 && make -j6 \
 && make install \
 && cd ../ \
 && rm -rf ceres-solver-2.0.0.tar.gz ceres-solver-2.0.0 ceres-bin

# RUN echo "source /usr/share/bash-completion/completions/git" >> /etc/bash.bashrc

RUN cd /tmp \
 && git clone http://github.com/strasdat/Sophus.git \
 && cd Sophus \
 && git checkout 97e7161 \
 && mkdir build \
 && cd build \
 && cmake .. -DBUILD_TESTS=OFF \
 && make -j6 \
 && make install \
 && cd ../.. \
 && rm -rf Sophus

# On Ubuntu 22.04, the GTSAM 4.0.3 and 4.1.1 are not compatible with the system tbb and boost.
#Install gtsam - library for localization and mapping
# RUN cd /tmp \
#     # && wget -O /tmp/gtsam.zip https://github.com/borglab/gtsam/archive/4.0.2.zip \
#     # && wget -O /tmp/gtsam.zip https://github.com/borglab/gtsam/archive/4.0.3.zip \
#     && wget -O /tmp/gtsam.zip https://github.com/borglab/gtsam/archive/4.1.1.zip \
#     && unzip gtsam.zip -d /tmp/ \
#     # && cd /tmp/gtsam-4.0.2/ \
#     # && cd gtsam-4.0.3/ \
#     && cd gtsam-4.1.1/ \
#     && mkdir build \
#     && cd build \
#     && cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF -DGTSAM_USE_SYSTEM_EIGEN=ON .. \
#     && make install -j6 \
#     && cd ../.. \
#     && rm -rf gtsam.zip gtsam-4.1.1

# && sed -i '187s/.*/file(READ "${TBB_INCLUDE_DIRS}\/oneapi\/tbb\/version.h" _tbb_version_file)/' cmake/FindTBB.cmake \

# This is the develop branch of GTSAM on 2024-04-13.
RUN cd /tmp \
 && git clone https://github.com/borglab/gtsam.git \
 && cd gtsam \
 && git checkout 4abef92 \
 && mkdir build \
 && cd build \
 && cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF -DGTSAM_USE_SYSTEM_EIGEN=ON .. \
 && make install -j6 \
 && cd ../.. \
 && rm -rf gtsam

# Entrypoint command
CMD /bin/bash