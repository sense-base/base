#!/bin/bash

ROS_DISTRO=jazzy

rosdep fix-permissions
rosdep init
rosdep update --rosdistro ${ROS_DISTRO}
rosdep install --from-paths src --ignore-src -r -y --rosdistro ${ROS_DISTRO}
colcon build --symlink-install
source install/setup.bash