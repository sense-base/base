ARG UBUNTU_RELEASE_YEAR=22
ARG UBUNTU_RELEASE_MONTH=04
ARG CUDA_MAJOR=12
ARG CUDA_MINOR=1
ARG CUDA_PATCH=1

FROM docker.io/nvidia/cuda:${CUDA_MAJOR}.${CUDA_MINOR}.${CUDA_PATCH}-devel-ubuntu${UBUNTU_RELEASE_YEAR}.${UBUNTU_RELEASE_MONTH} AS base

ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ARG USERNAME=root
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}compute,video,utility,graphics
ENV QT_X11_NO_MITSHM=1


ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
RUN echo "CUDA Version 12.1.1" > /usr/local/cuda/version.txt



#####################################
# Setting up ROS2
#####################################


# Setup the sources
RUN apt-get update -qq && apt-get install -y software-properties-common curl && \
    add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null


# General environment variables
ENV ROS_DISTRO=humble
ENV AMENT_PREFIX_PATH=/opt/ros/${ROS_DISTRO}
ENV COLCON_PREFIX_PATH=/opt/ros/${ROS_DISTRO}
ENV LD_LIBRARY_PATH=/opt/ros/${ROS_DISTRO}/lib
ENV PATH=/opt/ros/${ROS_DISTRO}/bin:$PATH
ENV PYTHONPATH=/ros2_ws/.venv/lib/python3.10/site-package
ENV ROS_PYTHON_VERSION=3
ENV ROS_VERSION=2


# Install ROS 2 packages
RUN apt-get update -qq && apt-get upgrade -y && \
    apt-get install -y \
    ros-${ROS_DISTRO}-desktop \
    ros-${ROS_DISTRO}-grid-map-rviz-plugin \
    ros-${ROS_DISTRO}-ament-cmake-clang-format \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-nmea-msgs \
    ros-${ROS_DISTRO}-geographic-msgs \
    ros-${ROS_DISTRO}-diagnostic-updater \
    ros-${ROS_DISTRO}-robot-localization \
    ros-${ROS_DISTRO}-common-interfaces \
    ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    ros-${ROS_DISTRO}-rosbag2-storage-mcap 

# bootstrap rmw_cyclonedds_cpp 
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp


# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    gdb \
    git \
    git-core \
    bash-completion \
    openssh-client \
    vim \
    tree \
    lsb-release \
    wget \
    less \
    udev \
    zstd \
    sudo \
    libpng-dev \
    libgomp1 \
    file \
    libmagic-mgc \
    libmagic1 \
    software-properties-common \
    curl \
    bash-completion \
    && rm -rf /var/lib/apt/lists/*

#####################################
# ZED SDK
#####################################
# comment out the following lines on non-GPU platforms
RUN wget -q -O ZED_SDK_Linux_Ubuntu22.run https://download.stereolabs.com/zedsdk/5.0/cu12/ubuntu22 && \
    chmod +x ZED_SDK_Linux_Ubuntu22.run ; ./ZED_SDK_Linux_Ubuntu22.run silent skip_cuda && \
    ln -sf /lib/x86_64-linux-gnu/libusb-1.0.so.0 /usr/lib/x86_64-linux-gnu/libusb-1.0.so && \
    rm ZED_SDK_Linux_Ubuntu22.run && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/Documents/ZED/


# #############################
# # Setting up uv environment
# #############################
# Install uv (Rust-based Python package manager, faster than pip)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Add uv to PATH
ENV PATH="/root/.local/bin/:$PATH"

WORKDIR /ros2_ws
COPY ./workspace/src ./src
COPY ./.devcontainer/rosdep-init.bash .

# Create uv virtual environment and install dependencies
RUN uv venv --python 3.10 --system-site-packages
RUN . .venv/bin/activate
RUN uv pip install -U pip argcomplete setuptools==58.2.0 bloom colcon-common-extensions rosdep vcstool lark numpy
# Notes (not sure where to put them but here are some)
# pip deps from ros-dev-tools #Vhttps://discourse.ros.org/t/ros-developer-tools-now-in-binary-form/29802
# why setuptools 80.7.1 does not work? #https://robotics.stackexchange.com/questions/101255/setuptoolsdeprecationwarning-setup-py-install-is-deprecated-use-build-and-pip
# uv pip list --verbose #see all installed packages


#####################################
# ROS2 Environment Setup and entrypoint
#####################################
### Adding all the necessary ros sourcing
RUN echo "" >> ~/.bashrc
RUN echo "## ROS2" >> ~/.bashrc
RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.bash' >> ~/.bashrc
RUN echo 'source /ros2_ws/.venv/bin/activate' >> ~/.bashrc
### Setting and calling the entrypoint
RUN echo '#!/usr/bin/env bash' > /ros_entrypoint.sh
RUN echo 'source $HOME/.bashrc' >> /ros_entrypoint.sh
RUN echo 'exec "$@"' >> /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]