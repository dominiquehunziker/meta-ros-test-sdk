#!/bin/bash

set -e

# Install binaries built with SDK
tar xf /home/root/data.tar -C /

# Setup ROS environment for building a binary
export ROS_DISTRO=indigo

export ROS_PACKAGE_PATH=/opt/ros/${ROS_DISTRO}/share:/opt/ros/cross_compiled/share
export PATH=$PATH:/opt/ros/${ROS_DISTRO}/bin:/opt/ros/cross_compiled/bin
export LD_LIBRARY_PATH=/opt/ros/${ROS_DISTRO}/lib:/opt/ros/cross_compiled/lib
export PYTHONPATH=/opt/ros/${ROS_DISTRO}/lib/python2.7/site-packages:/opt/ros/cross_compiled/lib/python2.7/site-packages
export CMAKE_PREFIX_PATH=/opt/ros/${ROS_DISTRO}:/opt/ros/cross_compiled

# Prepare workspace
mkdir -p /home/root/ws/src
cd /home/root/ws/src

# Initialize the workspace
catkin_init_workspace

# Setup package
catkin_create_pkg --rosdistro indigo runner roscpp my_pkg
cp /home/root/src/runner.cpp /home/root/ws/src/runner/src
cp /home/root/src/CMakeLists.txt /home/root/ws/src/runner

cd /home/root/ws

# Build package
catkin_make install

# Setup ROS environment for execution
. install/setup.bash

export ROS_MASTER_URI=http://192.168.7.2:11311
export ROS_IP=192.168.7.2

# Run simple test
roslaunch /home/root/src/test.launch
