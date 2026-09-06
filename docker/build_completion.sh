#!/bin/bash

_build_completions()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    local ws_path="/root/ros2_ws/src"
    
    # 1. Check if workspace exists
    if [ ! -d "$ws_path" ]; then
        return 0
    fi

    # 2. Get the list of packages 
    # We find the package.xml and get the name of the folder it sits in
    local pkgs=$(find "$ws_path" -maxdepth 5 -name "package.xml" | xargs -I {} bash -c 'basename $(dirname {})')
    
    # 3. Add special arguments
    local special_args="all clean debug"
    local opts="$pkgs $special_args"
    
    # 4. Generate the completion suggestions
    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
}

# Register the function for the 'build', 'clean', and 'debug' commands
complete -F _build_completions build
complete -F _build_completions clean
complete -F _build_completions debug

# Also register for the script path directly
complete -F _build_completions /root/build.sh
complete -F _build_completions ./build.sh