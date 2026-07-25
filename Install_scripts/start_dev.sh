#!/bin/bash
# ---------------------------------------------------------
# ROS 2 Jazzy - Dev Environment Launcher (Modular Version)
# ---------------------------------------------------------

# --- CONFIGURATION ---
DEFAULT_IDE="antigravity"
CONTAINER_NAME="jazzy_dev"
# ---------------------

IDE_BINARY="${1:-$DEFAULT_IDE}"

# Fix the BASH_SOURCE path lookup format
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Enable X11 access silently
xhost +local:docker > /dev/null 2>&1

# Start Docker container in the background silently
cd ../docker && docker compose up -d > /dev/null 2>&1
cd ../Install_scripts

# Generate the connection hex strings
if [[ "$IDE_BINARY" == "antigravity" ]]; then
    HEX_CODE=$(python3 -c "import json; print(json.dumps({'containerId': '$CONTAINER_NAME'}, separators=(',', ':')).encode().hex())")
    REMOTE_TYPE="dev-container"
    FLAGS="--no-sandbox --disable-gpu-sandbox"
else
    HEX_CODE=$(python3 -c "print('$CONTAINER_NAME'.encode().hex())")
    REMOTE_TYPE="attached-container"
    FLAGS=""
fi

# Launch the IDE globally in its own detached background session
setsid $IDE_BINARY $FLAGS -n --remote ${REMOTE_TYPE}+${HEX_CODE} /root/ros2_ws >/dev/null 2>&1 &

exit 0
