#!/bin/bash
# ---------------------------------------------------------
# ROS 2 Jazzy - Dev Environment Launcher (Smart IDE Detection)
# ---------------------------------------------------------

# --- CONFIGURATION ---
# Choose your IDE: "antigravity", "code", or "code-insiders"
IDE_BINARY="code"
# ---------------------

# 1. Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 2. Start Docker
echo "🌐 Enabling X11 access..."
xhost +local:docker > /dev/null

echo "🚀 Starting Container..."
cd docker && docker compose up -d
cd ..

# 3. Determine the correct Hex Format for the IDE
# Antigravity wants JSON-in-Hex, VS Code wants Simple-Hex
if [[ "$IDE_BINARY" == "antigravity" ]]; then
    # To find this hex: python3 -c "print('{\"containerId\":\"jazzy_dev\"}'.encode().hex())"
    HEX_CODE="7b22636f6e7461696e65724964223a226a617a7a795f646576227d"
    REMOTE_TYPE="dev-container"
else
    # To find this hex: python3 -c "print('jazzy_dev'.encode().hex())"
    HEX_CODE="6a617a7a795f646576"
    REMOTE_TYPE="attached-container"
fi

# 4. Launch the IDE
echo "🛸 Opening $IDE_BINARY (Remote Mode)..."
$IDE_BINARY -n --remote ${REMOTE_TYPE}+${HEX_CODE} /root/ros2_ws &

echo "✅ Environment Launched."
sleep 3
exit 0
