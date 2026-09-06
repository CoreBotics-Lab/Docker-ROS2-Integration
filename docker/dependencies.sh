#!/usr/bin/env bash
set -e # Exit immediately if any command fails

echo "📦 Installing CoreBotics Workspace Dependencies..."

# 1. Update package indexes
apt-get update

# 2. Main ROS 2 Simulation and Control Packages
apt-get install -y \
    ros-lyrical-ros2-control \
    ros-lyrical-ros2-controllers \
    ros-lyrical-gz-ros2-control \
    ros-lyrical-joint-state-publisher-gui \
    ros-lyrical-xacro \
    ros-lyrical-rosidl-default-generators \
    ros-lyrical-rosidl-default-runtime \
    ros-lyrical-ros-gz-sim \
    ros-lyrical-ros-gz-bridge \
    ros-lyrical-gz-ros2-control \
    ros-lyrical-turtlesim \
    ros-lyrical-tf-transformations \
    ros-lyrical-rviz-imu-plugin \
    ros-lyrical-ament-cmake-python

# 3. Clean up apt cache to keep the Docker image lightweight
rm -rf /var/lib/apt/lists/*

echo "✅ All dependencies installed successfully!"
