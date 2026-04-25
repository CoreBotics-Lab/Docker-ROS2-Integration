#!/bin/bash
# ---------------------------------------------------------
# ROS 2 Jazzy - Dev Environment Launcher (Modular Version)
# ---------------------------------------------------------

# --- CONFIGURATION ---
# Default IDE if no argument is provided (e.g., "antigravity", "code", "code-insiders")
DEFAULT_IDE="antigravity"

# Your Container Name (from docker-compose.yml)
CONTAINER_NAME="jazzy_dev"
# ---------------------

# Use the first argument as the IDE binary, or fall back to default
IDE_BINARY="${1:-$DEFAULT_IDE}"

# 1. Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 2. Start Docker
echo "🌐 Enabling X11 access..."
xhost +local:docker > /dev/null

echo "🚀 Starting Container..."
cd docker && docker compose up -d
cd ..

# 3. Generate the Dynamic Hex Code
echo "🔧 Generating connection hex for $IDE_BINARY..."
if [[ "$IDE_BINARY" == "antigravity" ]]; then
    # Antigravity wants JSON format: {"containerId":"jazzy_dev"}
    HEX_CODE=$(python3 -c "import json; print(json.dumps({'containerId': '$CONTAINER_NAME'}, separators=(',', ':')).encode().hex())")
    REMOTE_TYPE="dev-container"
else
    # VS Code and others want Simple format: jazzy_dev
    HEX_CODE=$(python3 -c "print('$CONTAINER_NAME'.encode().hex())")
    REMOTE_TYPE="attached-container"
fi

# 4. Launch the IDE
echo "🛸 Opening $IDE_BINARY (Remote Mode)..."
$IDE_BINARY -n --remote ${REMOTE_TYPE}+${HEX_CODE} /root/ros2_ws &

echo "✅ Environment Launched."
sleep 3
exit 0
