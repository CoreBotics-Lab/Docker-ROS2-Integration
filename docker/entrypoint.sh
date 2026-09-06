#!/bin/bash
# ---------------------------------------------------------
# ROS 2 Container Entrypoint
# ---------------------------------------------------------

# We do NOT use 'set -e' globally here because we want the 
# container to start even if a minor permission fix fails.

# 1. Fix permissions for scripts and tools in /root
echo "🔧 Setting script permissions..."
chmod +x /root/*.sh 2>/dev/null || true

# 3. Final Check
# ${ROS_DISTRO^} capitalizes the first letter (e.g., Lyrical)
echo "🚀 ROS 2 ${ROS_DISTRO^} Container Ready!"

# 4. Hand over to the command (usually 'bash')
# This must be the very last line.
exec "$@"