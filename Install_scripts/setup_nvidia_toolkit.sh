#!/bin/bash
set -e

echo "Setting up Host Machine for ROS 2 Docker Environment..."

echo "1. Installing NVIDIA Container Toolkit..."
# Add the package repositories
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Install the toolkit
sudo apt update && sudo apt install -y nvidia-container-toolkit

# Configure Docker to use the NVIDIA runtime
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

echo "2. Enabling GUI Access (X11)..."
xhost +local:docker

# Add to bashrc if not already present
if ! grep -q "xhost +local:docker" ~/.bashrc; then
    echo "xhost +local:docker > /dev/null" >> ~/.bashrc
    echo "Added xhost configuration to ~/.bashrc"
else
    echo "xhost configuration already present in ~/.bashrc"
fi

echo "Setup complete!"
