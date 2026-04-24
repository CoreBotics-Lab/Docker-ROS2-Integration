# 🖥️ ROS 2 Jazzy Desktop Launcher Setup

This guide explains how to set up a professional "One-Click" desktop launcher for this ROS 2 development environment.

## 📦 1. Prerequisite: Dev Containers Extension
If you are using a fork of VS Code (like Antigravity) that uses Open VSX, you may need to install the **Dev Containers** extension manually via VSIX to avoid connection errors.

*   **Download Link**: [Dev Containers v0.456.0](https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-vscode-remote/vsextensions/remote-containers/0.456.0/vspackage)
*   **Installation**: Download the file and in your IDE select **Extensions > ... > Install from VSIX**.

---

## 🚀 2. Creating the Desktop Icon
Since the `.desktop` file is local to your machine, you should create it manually on your desktop.

1. Create a new file on your desktop named `ROS2_Jazzy.desktop`.
2. Paste the following code into it (replace `YOUR_PROJECT_PATH` with the actual path to this folder):

```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=ROS 2 Jazzy
Comment=Launch ROS 2 Jazzy Development Environment
Exec=YOUR_PROJECT_PATH/start_dev.sh
Icon=YOUR_PROJECT_PATH/ros2_icon.png
Terminal=true
Categories=Development;
StartupNotify=true
Path=YOUR_PROJECT_PATH/
```

3. Make the file executable:
   ```bash
   chmod +x ~/Desktop/ROS2_Jazzy.desktop
   ```

---

## ⚙️ 3. Configuration

### Switching IDEs
The `start_dev.sh` script is designed to work with Antigravity, VS Code, or VS Code Insiders. To switch:

1. Open `start_dev.sh` in the project root.
2. Locate the `IDE_BINARY` variable at the top and change it to your preferred command (`antigravity`, `code`, or `code-insiders`).

### Customizing the Container Name
If you change the container name in `docker-compose.yml`, you must update the hex string in `start_dev.sh`. To find a new hex string for your container, run this command in your terminal:

```bash
# To find a new hex code for a different container name, run:
python3 -c "print('{\"containerId\":\"YOUR_CONTAINER_NAME\"}'.encode().hex())"

# Example for 'jazzy_dev':
python3 -c "print('{\"containerId\":\"jazzy_dev\"}'.encode().hex())"
# Output: 7b22636f6e7461696e65724964223a226a617a7a795f646576227d
```

Copy the output and paste it into the `--remote` section of `start_dev.sh`.

---

## 📄 File Overview
*   `start_dev.sh`: The main engine that starts Docker and launches the IDE.
*   `ros2_icon.png`: The official icon for the desktop launcher.
*   `docker/setup_vscode_ext.sh`: Utility to install recommended extensions.
