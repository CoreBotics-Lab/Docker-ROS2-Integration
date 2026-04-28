#!/bin/bash
# ---------------------------------------------------------
# ROS 2 Jazzy - Desktop Icon Installer
# ---------------------------------------------------------

# 1. Get the absolute path of the project (one level up from this script)
LAUNCHER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_PATH="$( cd "$LAUNCHER_DIR/.." && pwd )"
ICON_PATH="$LAUNCHER_DIR/ros2_icon.png"
LAUNCHER_PATH="$LAUNCHER_DIR/start_dev.sh"

echo "🤖 ROS 2 Jazzy - Desktop Setup"
echo "--------------------------------"

# 2. Detect IDEs
IDEs=()
[[ $(command -v antigravity) ]] && IDEs+=("antigravity")
[[ $(command -v code) ]] && IDEs+=("code")
[[ $(command -v code-insiders) ]] && IDEs+=("code-insiders")

if [ ${#IDEs[@]} -eq 0 ]; then
    echo "❌ Error: No supported IDEs (Antigravity, VS Code, or Insiders) found in your PATH."
    exit 1
fi

# 3. Interactive Selection
echo "Multiple IDEs found. Which one would you like to use for the Desktop Icon?"
for i in "${!IDEs[@]}"; do
    echo "$((i+1))) ${IDEs[$i]}"
done

read -p "Select a number (1-${#IDEs[@]}): " CHOICE

# Validate choice
if [[ ! "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#IDEs[@]} ]; then
    echo "❌ Invalid selection. Exiting."
    exit 1
fi

SELECTED_IDE=${IDEs[$((CHOICE-1))]}
echo "✅ Selected: $SELECTED_IDE"

# 4. Create the .desktop file
DESKTOP_FILE="$HOME/Desktop/ROS2_Jazzy.desktop"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=ROS 2 Jazzy
Comment=Launch ROS 2 Jazzy Development Environment
Exec=$LAUNCHER_PATH $SELECTED_IDE
Icon=$ICON_PATH
Terminal=true
Categories=Development;
StartupNotify=true
Path=$PROJECT_PATH/
EOF

# 5. Make everything executable
chmod +x "$DESKTOP_FILE"
chmod +x "$LAUNCHER_PATH"

echo "--------------------------------"
echo "🎉 SUCCESS!"
echo "A ROS 2 Jazzy icon has been created on your Desktop."
echo "You can now use it to launch your environment with $SELECTED_IDE."
