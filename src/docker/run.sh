#!/bin/bash

set -e

# IMPORTANT: Without alias expansion catkin_make will fail when called from a script!
shopt -s expand_aliases

. /usr/local/oecore-sdk/environment-setup-*

mkdir -p /root/ws/src
cd /root/ws/src

# Initialize the workspace
catkin_init_workspace

# Setup package
catkin_create_pkg --rosdistro indigo my_pkg roscpp std_msgs
cp /root/src/chatter.h /root/ws/src/my_pkg/include/my_pkg
cp /root/src/chatter.cpp /root/ws/src/my_pkg/src
cp /root/src/listener.cpp /root/ws/src/my_pkg/src
cp /root/src/CMakeLists.txt /root/ws/src/my_pkg

cd /root/ws

# Build package
DESTDIR=/root/target catkin_make install --cmake-args -DCMAKE_INSTALL_PREFIX=/opt/ros/cross_compiled -DCATKIN_BUILD_BINARY_PACKAGE=ON
touch /root/target/opt/ros/cross_compiled/.catkin  # Mark the directory

# Package data
tar -C /root/target/ -cf /root/output/data.tar .
