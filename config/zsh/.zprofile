# Zsh Profile Configuration
# This file is sourced for login shells

# Set PATH and other environment variables
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# Language and locale settings
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Default applications
export EDITOR="vim"
export VISUAL="vim"
export BROWSER="firefox"
export TERMINAL="kitty"

# History settings
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"

# Development tools
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Node.js
export NODE_PATH="/usr/local/lib/node_modules"

# Python
export PYTHONPATH="$HOME/.local/lib/python3.9/site-packages:$PYTHONPATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Java
if [[ -d "/usr/lib/jvm/default-java" ]]; then
    export JAVA_HOME="/usr/lib/jvm/default-java"
elif [[ -d "/Library/Java/JavaVirtualMachines" ]]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home"
fi

# SSH Agent
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
fi

# GPG Agent
export GPG_TTY=$(tty)

# Load OS-specific profile
case "$(uname -s)" in
    Darwin)
        [[ -f "$HOME/.config/zsh/distro/macos.zsh" ]] && source "$HOME/.config/zsh/distro/macos.zsh"
        ;;
    Linux)
        if command -v lsb_release &> /dev/null; then
            case "$(lsb_release -si)" in
                Ubuntu) [[ -f "$HOME/.config/zsh/distro/ubuntu.zsh" ]] && source "$HOME/.config/zsh/distro/ubuntu.zsh" ;;
                Debian) [[ -f "$HOME/.config/zsh/distro/debian.zsh" ]] && source "$HOME/.config/zsh/distro/debian.zsh" ;;
                Fedora) [[ -f "$HOME/.config/zsh/distro/fedora.zsh" ]] && source "$HOME/.config/zsh/distro/fedora.zsh" ;;
                Arch) [[ -f "$HOME/.config/zsh/distro/arch.zsh" ]] && source "$HOME/.config/zsh/distro/arch.zsh" ;;
            esac
        elif [[ -f /etc/arch-release ]]; then
            [[ -f "$HOME/.config/zsh/distro/arch.zsh" ]] && source "$HOME/.config/zsh/distro/arch.zsh"
        fi
        ;;
esac

# Load local profile if it exists
[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
