#!/usr/bin/env bash
set -e # Exit immediately if any command fails

echo "📦 Installing CoreBotics Workspace Dependencies..."

# 1. Update package indexes
apt-get update

# 2. Main ROS 2 Simulation and Control Packages
apt-get install -y \
    ros-jazzy-ros2-control \
    ros-jazzy-ros2-controllers \
    ros-jazzy-gz-ros2-control \
    ros-jazzy-joint-state-publisher-gui \
    ros-jazzy-xacro \
    ros-jazzy-rosidl-default-generators \
    ros-jazzy-rosidl-default-runtime \
    ros-jazzy-ros-gz-sim \
    ros-jazzy-ros-gz-bridge \
    ros-jazzy-turtlesim \
    ros-jazzy-tf-transformations \
    ros-jazzy-rviz-imu-plugin \
    ros-jazzy-ament-cmake-python

# 3. Clean up apt cache to keep the Docker image lightweight
rm -rf /var/lib/apt/lists/*

echo "✅ All dependencies installed successfully!"