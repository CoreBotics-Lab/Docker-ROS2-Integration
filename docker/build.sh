#!/bin/bash
# -----------------------------------------------------------------------------
# ROS 2 Build & Clean Helper Script - Milestone Version (Enhanced + Wildcards)
# -----------------------------------------------------------------------------

# Colors for B.I.R.D.I.E. style feedback
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 1. Define and Enter Workspace
WORKSPACE_DIR="/root/ros2_ws"

if [ -d "$WORKSPACE_DIR" ]; then
    cd "$WORKSPACE_DIR"
else
    echo -e "${RED}❌ Error: $WORKSPACE_DIR not found!${NC}"
    return 1
fi

# Function to collect and expand packages (supports wildcards like core_*)
collect_packages() {
    local input_pkgs=("$@")
    local expanded_pkgs=""
    local all_pkgs=""
    
    # Pre-fetch all available packages if needed for expansion
    if [[ "$*" == *[*?]* ]]; then
        all_pkgs=$(find "src" -maxdepth 5 -name "package.xml" | xargs -I {} bash -c 'basename $(dirname {})')
    fi

    for p in "${input_pkgs[@]}"; do
        if [[ "$p" == --* ]]; then
            break
        fi
        
        # If the argument contains a wildcard, try to match it against all_pkgs
        if [[ "$p" == *[*?]* ]]; then
            local matches=""
            for available in $all_pkgs; do
                if [[ $available == $p ]]; then
                    matches="$matches $available"
                fi
            done
            
            if [ -n "$matches" ]; then
                expanded_pkgs="$expanded_pkgs $matches"
            else
                # If no matches, keep it as is (colcon will handle the error)
                expanded_pkgs="$expanded_pkgs $p"
            fi
        else
            expanded_pkgs="$expanded_pkgs $p"
        fi
    done
    echo "$expanded_pkgs"
}

# 2. Logic for "clean" (Supports: clean all OR clean <pkg1> <pkg2> ...)
if [ "$1" == "clean" ]; then
    shift
    
    if [ "$1" == "all" ] || [ -z "$1" ]; then
        echo -e "${YELLOW}🧹 [CLEAN ALL] Wiping build, install, and log folders...${NC}"
        rm -rf build/ install/ log/
        echo -e "${GREEN}✅ Workspace is 100% clean.${NC}"
    else
        PKGS=$(collect_packages "$@")
        for PKG_NAME in $PKGS; do
            echo -e "🪒 [CLEAN PARTIAL] Removing build/install artifacts for: ${CYAN}$PKG_NAME${NC}"
            rm -rf "build/$PKG_NAME" "install/$PKG_NAME"
            rm -rf "install/share/$PKG_NAME" 2>/dev/null || true
            echo -e "${GREEN}✅ Package [$PKG_NAME] cleaned.${NC}"
        done
    fi
    return 0

# 3. Enhanced Debug Mode (Supports: debug OR debug <pkg1> <pkg2> ...)
elif [ "$1" == "debug" ]; then
    shift 
    
    if [ -z "$1" ] || [[ "$1" == --* ]]; then
        echo -e "${YELLOW}🐞 [DEBUG ALL] Building entire workspace with Debug symbols...${NC}"
        colcon build --cmake-args -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON "$@"
    else
        PKGS=$(collect_packages "$@")
        # Shift past collected items
        while [ -n "$1" ] && [[ "$1" != --* ]]; do shift; done
        
        echo -e "🐞 [DEBUG PARTIAL] Building packages [${CYAN}$PKGS${NC}] with Debug symbols..."
        colcon build --packages-select $PKGS --cmake-args -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON "$@"
    fi
    echo -e "${GREEN}✅ Debug build complete.${NC}"

# 4. Triple-Threat Build Logic
elif [ "$1" == "all" ]; then
    echo -e "${YELLOW}🏗️  [FORCE ALL] Rebuilding every package (Release)...${NC}"
    shift
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON "$@"

elif [ -n "$1" ] && [[ "$1" != --* ]]; then
    PKGS=$(collect_packages "$@")
    # Shift past collected items
    while [ -n "$1" ] && [[ "$1" != --* ]]; do shift; done
    
    echo -e "📦 [PARTIAL BUILD] Targeting packages: ${CYAN}$PKGS${NC}..."
    colcon build --packages-select $PKGS --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON "$@"

else
    echo -e "${YELLOW}⚡ [INCREMENTAL BUILD] Building changes...${NC}"
    colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON "$@"
fi

# 5. Re-source the workspace
if [ -f "$WORKSPACE_DIR/install/setup.bash" ]; then
    source "$WORKSPACE_DIR/install/setup.bash"
    echo -e "${GREEN}🔄 Environment re-sourced.${NC}"
fi