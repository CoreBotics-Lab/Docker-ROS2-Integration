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
Exec=YOUR_PROJECT_PATH/start_dev.sh antigravity
Icon=YOUR_PROJECT_PATH/ros2_icon.png
Terminal=true
Categories=Development;
StartupNotify=true
Path=YOUR_PROJECT_PATH/
```

> [!TIP]
> You can change the IDE by changing the argument at the end of the `Exec` line (e.g., `.../start_dev.sh code` or `.../start_dev.sh code-insiders`).

3. Make the file executable:
   ```bash
   chmod +x ~/Desktop/ROS2_Jazzy.desktop
   ```

---

## ⚙️ 3. Configuration

### Customizing the Container Name
The script is now **fully dynamic**. If you change the container name in `docker-compose.yml`, you only need to update the `CONTAINER_NAME` variable at the top of `start_dev.sh`. 

The script will automatically generate the correct hex code for your IDE using Python!

---

## 📄 File Overview
*   `start_dev.sh`: The main engine that starts Docker and launches the IDE.
*   `ros2_icon.png`: The official icon for the desktop launcher.