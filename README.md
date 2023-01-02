
# Docker for DSTA #

- [Docker for DSTA](#docker-for-dsta)
- [Introduction](#introduction)
- [Major packages](#major-packages)
- [Pre-built images](#pre-built-images)
- [Scripts for creating docker containers](#scripts-for-creating-docker-containers)
- [Adding the host user to an image](#adding-the-host-user-to-an-image)
- [Building images locally](#building-images-locally)
  - [Notes for supporting PyG and CuPy on x86](#notes-for-supporting-pyg-and-cupy-on-x86)
- [Remove a series of images based on NGC version](#remove-a-series-of-images-based-on-ngc-version)
- [Who to talk to](#who-to-talk-to)
  - [Point of contact:](#point-of-contact)

# Introduction #

This repo contains useful docker files and scripts for the DSTA project. You can find the pre-built docker images, docker files, and helper scripts here. The docker usage targets both x86 (ordinary desktop CPU/GPU) and ARM (aarch64, Jetson platforms) architectures. Although, currently the images for these two platforms have different functionalities.

# Major packages #

| NGC   | ubuntu | CUDA | Python | PyTorch  | Torch-TRT | comment                       |
|-------|--------|------|--------|----------|-----------|-------------------------------|
| 22.12 | 20.04  | 11.8 | 3.8.10 | 1.14.0a0 | 1.3.0a0   | For pre-proc                  |
| 22.08 | 20.04  | 11.7 | 3.8    | 1.13.0a0 | 1.1.0a0   | All purpose on x86.           |
| 20.11 | 18.04  | 11.1 | 3.6.10 | 1.8.0a0  | None      | For compatibility test on x86 |

# Pre-built images #

__NOTE__: All the pre-built images have the `root` as the default user. This is not a good practice and it leads to issues when trying to give GUI support to a docker container. The user is encouraged to create a wrapper docker image based on any of the pre-built images and add an appropriate non-root user to the wrapper image. Please refer to the [Adding the host user to an image](#adding-the-host-user-to-an-image) section for more details.

Pre-built images can be found in our Docker Hub repository for [x86][x86_repo] and [ARM][arm_repo] architectures. The convention of the image tag is `<Docker Hub account>`/ngc_`<platform>`\_dsta:`<NGC version>`\_`<suffix>`. Where the placeholders are 
- __Docker Hub account__: A Docker Hub account name. This part could be any valid name if the images are built locally following the [Building images locally](#building-images-locally) section.
- __platform__: Can be `x86` or `arm`. Use `arm` on Jetson devices.
- __NGC version__: The version of the [NGC PyTorch image][ngc_pytorch] with out the `-py3` suffix. E.g., 22.12.
- __suffix__: An ordered name showing the functions of the image. For suffixs that contain `pre`, they are used for pre-processing. Not for testing inference or any operations that have GPU involved (if on Jetson devices). 

An example image tag could be
```
yaoyuh/ngc_arm_dsta:22.12_pre_02_python
```
which is an image for a Jetson device based on NGC PyTorch 22.12 and it provides necessary third-party python packages for pre-processing. Note that the `suffix` is only for documentation purposes. The user needs to look at the actual docker files to get a sense of what is in an image without running the image.

[x86_repo]: https://hub.docker.com/repository/docker/yaoyuh/ngc_x86_dsta
[arm_repo]: https://hub.docker.com/repository/docker/yaoyuh/ngc_arm_dsta
[ngc_pytorch]: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

# Scripts for creating docker containers #

__NOTE__: It is strongly recommended to follow the [Adding the host user to an image](#adding-the-host-user-to-an-image) section to create a wrapper docker image for working with the scripts provided here.

In the `scripts` folder, there is a script file for starting a development docker container. That is `start_dev_container.sh`. GUI (X server) support is already built in.

To use these scripts, it is recommended to make a copy of a script and modify the necessary arguments for the `docker run` command. 

To start a docker container and enter it immediately, use the following command

```bash
cd <scripts/>
./start_dev_docker.sh <docker image with tag>
```

The container created by these scripts does not get removed automatically. The user needs to do `docker rm` before running the script with the same image tag.

# Adding the host user to an image #

It is recommended to create a wrapper image and add the host user to it. This has several benefits:
- No file permission issues in and out of the container.
- Friendly to GUI-enabled applications.
- Provides an extra layer of security such that the user won't accidentally change or delete mounted host files.

A dedicated script, `add_user_2_image.sh`, is provided to help to add the host user to an image. The usage is

```bash
cd <scripts/>
./add_user_2_image.sh <input image tag> <new/wrapper image tag>
```

# Building images locally #

To build the images locally, do

```bath
cd <scripts/>
./build_images.sh <Docker Hub account> <NGC version>
```

As mentioned in the [Pre-built images](#pre-built-images) section, `<Docker Hub account>` could be any valid account name that best suits the user's needs.

An concrete example (on Jetson) could be

```bash
cd <scripts/>
./build_images.sh yaoyuh 22.12 
```

Several images will be built progressively. In case of a failure, the user can comment out some parts of the script, make necessary changes to the docker file and re-run again. Then previous successfully built images serve as warm start (base images) of the modified docker file. When the whole build procedure finishes, there will be an image with a `99_local` tag suffix. This is the final image that has the host user already added. The images built by the above example command on a Jetson device are

```
REPOSITORY            TAG                   IMAGE ID       CREATED      SIZE
yaoyuh/ngc_arm_dsta   22.12_pre_99_local    ef1c20223b47   2 days ago   14.4GB
yaoyuh/ngc_arm_dsta   22.12_pre_02_python   650ffbd9c296   2 days ago   14.4GB
yaoyuh/ngc_arm_dsta   22.12_pre_01_base     555cde636521   2 days ago   14.3GB
```

Running `./build_images.sh yaoyuh 20.11` on x86 will be

```
REPOSITORY            TAG                             IMAGE ID       CREATED        SIZE
yaoyuh/ngc_x86_dsta   20.11_99_local                  8d07077ba47d   16 hours ago   13.6GB
yaoyuh/ngc_x86_dsta   20.11_03_cuda_torch_dependent   fe7659272a98   16 hours ago   13.6GB
yaoyuh/ngc_x86_dsta   20.11_02_python                 c0cf065066aa   16 hours ago   13.4GB
yaoyuh/ngc_x86_dsta   20.11_01_base                   8054a4e1402e   16 hours ago   13.2GB
```

Note that, currently, different set of images with different suffixs will be generated on Jetson and x86 platforms. This situation may be changed to have a more consistent set of images later.

## Notes for supporting PyG and CuPy on x86 ##

The user is encouraged to take a look at `dockerfiles/version_helper.py` to get the supported versions of [PyG](https://github.com/pyg-team/pytorch_geometric) and [CuPy](https://docs.cupy.dev/en/stable/install.html). Since the versions of CUDA and PyTorch are determined by the [NGC image](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/overview.html#overview), we need to find the best match for PyG and CuPy by referring to the CUDA and PyTorch.

On ARM (Jetson), no images are provided for supporting PyG and CuPy at the moment. They might be supported later. Currently on Jetpack 4.6, all our inference codes are running without docker.

# Remove a series of images based on NGC version #

__NOTE__: Use with caution.

When a newer NGC version is available, we can remove a series of images that are based on an old NGC version by the `remove_images.sh` script. 

First, perform a dry run.

```bash
cd <scripts/>
./remove_images.sh <Docker Hub account> <NGC version>
```

The following is an example on a x86.

```
$ cd <scripts/> 
$ ./remove_images.sh yaoyuh 20.11   
REPOSITORY            TAG                             IMAGE ID       CREATED        SIZE
yaoyuh/ngc_x86_dsta   20.11_99_local                  8d07077ba47d   16 hours ago   13.6GB
yaoyuh/ngc_x86_dsta   20.11_03_cuda_torch_dependent   fe7659272a98   16 hours ago   13.6GB
yaoyuh/ngc_x86_dsta   20.11_02_python                 c0cf065066aa   16 hours ago   13.4GB
yaoyuh/ngc_x86_dsta   20.11_01_base                   8054a4e1402e   16 hours ago   13.2GB
```

To confirm the deletion, add the `-c` option to the command line. 

```
$ ./remove_images.sh yaoyuh 22.12 -c
Removing...
REPOSITORY           TAG                 IMAGE ID       CREATED        SIZE
...
```

The above command untags the images. To finally/acutally remove them, use

```bash
# This will remove other stuff! Use with caution.
# Please read the documentation of 'docker system prune' before proceeding.
docker system prune
```

# Who to talk to #

Please create GitHub issues if you find any problems.

## Point of contact: ##

Yaoyu Hu \<yaoyuh@andrew.cmu.edu\>
