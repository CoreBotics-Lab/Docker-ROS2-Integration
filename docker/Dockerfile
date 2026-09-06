# 0. Global Scope Argument
# This allows us to change the version in one place (top) and have it
# apply to every stage below.
ARG ROS_DISTRO=lyrical		  

# --- STAGE 1: THE PERMANENT BASE (Core Logic & Workspace Setup) ---

# We use the 'ros-base' image because it is lighter and contains only the
# core libraries needed for building and running robot logic.
FROM ros:${ROS_DISTRO}-ros-base AS base	  

# Re-declare ARG to bring it into this stage's scope
ARG ROS_DISTRO

# ENV persists during container runtime; ARG only exists during build time.
ENV ROS_DISTRO=${ROS_DISTRO}

# Prevents installers from hanging while waiting for user input (keyboard/timezone).
ENV DEBIAN_FRONTEND=noninteractive		  

# Use Bash instead of the default 'sh' to allow for advanced sourcing.
SHELL ["/bin/bash", "-c"]		  

# 1. Install Essential Build Tools
# colcon-common-extensions: The standard build tool for ROS 2.
# colcon-clean: The tool we use for our 'clean' alias.
# rosdep: Tool for installing system dependencies from a package.xml.
# build-essential & cmake: Standard C++ compiler tools.
RUN apt-get update && apt-get install -y \
                wget \
                gdb \
                terminator \
                fonts-noto-color-emoji  \
                python3-colcon-common-extensions \
                python3-colcon-clean \
                python3-rosdep \
                build-essential \
                cmake \
                ros-${ROS_DISTRO}-demo-nodes-py \
                && rm -rf /var/lib/apt/lists/*
                		  
# --- MODULAR DEPENDENCY SECTION ---
# Mount the script temporarily to execute it, avoiding any file copying or cleanup layers
RUN --mount=type=bind,source=dependencies.sh,target=/tmp/dependencies.sh \
    bash /tmp/dependencies.sh
# ----------------------------------

# 2. Update rosdep database
# This downloads the latest list of software package names for Lyrical.
RUN rosdep update --rosdistro ${ROS_DISTRO}		  

# 3. Create the workspace structure
# WORKDIR is like 'mkdir' and 'cd' combined.
WORKDIR /root/ros2_ws
RUN mkdir src		  

# --- ADDITIONAL SETUP ---	  

# 4. Copy the extension script into /root/
# 4.1 This is a personal tool. We copy it here so it's always in the image.
COPY setup_vscode_ext.sh /root/setup_vscode_ext.sh
COPY build_completion.sh /root/build_completion.sh

#4.2 Copy build script to ros2_ws
COPY build.sh /root/build.sh	  

# This script runs ONCE every time the container is turned on.
# It will handle the 'chmod +x' for our build.sh automatically.
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh		  

# 5. Set up the environment for every shell session & Aliases
# We use '&& \' to chain these into one 'RUN' layer for a smaller image.
# - source /opt/ros/...: Loads standard ROS commands (ros2 run, etc.)
# - if [ -f .../setup.bash ]: Loads YOUR custom code so you can run your nodes.
# - alias: Shortcut commands we created to save time.
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc && \
                echo 'if [ -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]; then source "/opt/ros/${ROS_DISTRO}/setup.bash"; fi' >> ~/.bashrc && \
                echo 'if [ -f /root/ros2_ws/install/setup.bash ]; then source /root/ros2_ws/install/setup.bash; fi' >> ~/.bashrc  &&  \
                echo "alias build='source /root/build.sh'" >> ~/.bashrc && \
                echo "alias clean='source /root/build.sh clean'" >> ~/.bashrc && \
                echo "alias install_ext='source /root/setup_vscode_ext.sh'" >> ~/.bashrc && \
                echo "source /root/build_completion.sh" >> ~/.bashrc
# 6. Startup Setup (The Entrypoint)
ENTRYPOINT ["/root/entrypoint.sh"]		  

# Default command if no other command is provided.
CMD ["bash"]		  

# --- STAGE 2: DESKTOP SETUP (Inherits everything from base) ---
# This stage adds the heavy GUI tools like RViz and Rqt.
FROM base AS desktop	  

# NVIDIA & X11 environment variables for GPU acceleration.
# xcb is the platform plugin for 3D windows.
# nvidia vendor library ensures the container talks to your NVIDIA GPU.
ENV QT_QPA_PLATFORM=xcb
ENV __GLX_VENDOR_LIBRARY_NAME=nvidia
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV OGRE_RTT_MODE=Copy
ENV __GL_THREADED_OPTIMIZATIONS=0
ENV __GL_SYNC_TO_VBLANK=1
ENV QT_ENABLE_HIGHDPI_SCALING=0
ENV QT_AUTO_SCREEN_SCALE_FACTOR=0
ENV QT_SCALE_FACTOR=1

# 7. Install GUI "Furniture"
RUN apt-get update && apt-get install -y \
                ros-${ROS_DISTRO}-desktop \
                ros-${ROS_DISTRO}-rviz2 \
                ros-${ROS_DISTRO}-ros-gz \
                mesa-utils \
                libgl1 \
                libgl1-mesa-dri \
                && rm -rf /var/lib/apt/lists/*		  

# 8. Create private runtime directory and rviz2 settings directory
RUN mkdir -p /tmp/runtime-root /root/.rviz2 && chmod 0700 /tmp/runtime-root
ENV XDG_RUNTIME_DIR=/tmp/runtime-root
# Re-confirm 'bash' as the default shell for the desktop stage.
CMD ["bash"]