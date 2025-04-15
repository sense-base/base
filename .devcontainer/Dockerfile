ARG UBUNTU_RELEASE_YEAR=22
ARG UBUNTU_RELEASE_MONTH=04
ARG CUDA_MAJOR=12
ARG CUDA_MINOR=1
ARG CUDA_PATCH=1

FROM docker.io/nvidia/cuda:${CUDA_MAJOR}.${CUDA_MINOR}.${CUDA_PATCH}-devel-ubuntu${UBUNTU_RELEASE_YEAR}.${UBUNTU_RELEASE_MONTH} as base

ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ARG USERNAME=root
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Disable GPU-specific variables on non-GPU platforms like macOS
# This will be handled by build args or runtime settings.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}compute,video,utility,graphics
ENV QT_X11_NO_MITSHM 1

# General environment variables
ENV PIP_ROOT_USER_ACTION=ignore
ENV ROS_DISTRO=humble
ENV AMENT_PREFIX_PATH=/opt/ros/${ROS_DISTRO}
ENV COLCON_PREFIX_PATH=/opt/ros/${ROS_DISTRO}
ENV LD_LIBRARY_PATH=/opt/ros/${ROS_DISTRO}/lib
ENV PATH=/opt/ros/${ROS_DISTRO}/bin:$PATH
ENV PYTHONPATH=/opt/ros/${ROS_DISTRO}/lib/python3.10/site-packages
ENV ROS_PYTHON_VERSION=3
ENV ROS_VERSION=2

RUN echo "Europe/London" > /etc/localtime ; echo "CUDA Version 12.1.0" > /usr/local/cuda/version.txt

#############################
# Install necessary libraries
#############################
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    python3 \
    gdb \
    git \
    git-core \
    bash-completion \
    openssh-client \
    python3-argcomplete \
    python3-pip \
    vim \
    lsb-release \
    wget \
    less \
    udev \
    zstd \
    sudo \
    libpng-dev \
    libgomp1 \
    python3-venv \
    file \
    libmagic-mgc \
    libmagic1 \
    software-properties-common \
    curl \
    bash-completion && \
    rm -rf /var/lib/apt/lists/*

#####################################
# ZED SDK
#####################################
# # comment out the following line on non-GPU platforms
RUN wget -q -O ZED_SDK_Linux_Ubuntu22.run https://download.stereolabs.com/zedsdk/5.0/cu12/ubuntu22 && \
    chmod +x ZED_SDK_Linux_Ubuntu22.run ; ./ZED_SDK_Linux_Ubuntu22.run silent skip_cuda && \
    ln -sf /lib/x86_64-linux-gnu/libusb-1.0.so.0 /usr/lib/x86_64-linux-gnu/libusb-1.0.so && \
    rm ZED_SDK_Linux_Ubuntu22.run && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/Documents/ZED/

# # Download ZED AI models directly into the container
RUN /usr/local/zed/tools/ZED_Diagnostic -nrlo

######
# ROS
######
RUN apt-get update -q && add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update -q && apt-get install --no-install-recommends -y \
    ros-dev-tools \
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
    # ros-${ROS_DISTRO}-image-transport-plugin \
    # ros-${ROS_DISTRO}-compressed-image_transport \
    # ros-${ROS_DISTRO}-compressed-depth-image-transport \
    # ros-${ROS_DISTRO}-theora-image-transport \
    # ros-${ROS_DISTRO}-ffmpeg-image-transport \
    # ros-${ROS_DISTRO}-ffmpeg-encoder-decoder \
    # ros-${ROS_DISTRO}-point-cloud-transport-plugins \
    # ros-${ROS_DISTRO}-draco-point-cloud-transport \
    # ros-${ROS_DISTRO}-zlib-point-cloud-transport \
    # ros-${ROS_DISTRO}-zed-msgs \
    # ros-${ROS_DISTRO}-cob-srvs && \
    # rm -rf /var/lib/apt/lists/*

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
RUN rosdep init && rosdep update --rosdistro $ROS_DISTRO

###########################
# Install pip requirements
###########################
ENV VIRTUAL_ENV=/root/venv
RUN python3 -m venv $VIRTUAL_ENV --system-site-packages
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYTHYONPATH="$VIRTUAL_ENV/lib/python3.10/site-packages:$PYTHONPATH"
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/ pip install -r requirements.txt
