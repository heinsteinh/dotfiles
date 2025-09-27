#!/bin/bash
# Main installation script for cross-platform dotfiles

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v pacman &> /dev/null; then
            echo "arch"
        elif command -v apt &> /dev/null; then
            echo "ubuntu"
        elif command -v dnf &> /dev/null; then
            echo "fedora"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Main installation
main() {
    local os_type
    os_type=$(detect_os)

    echo "Detected OS: $os_type"
    echo "Installing dotfiles..."

    # Change to script directory to ensure relative paths work
    cd "$SCRIPT_DIR"

    # Run OS-specific setup
    case "$os_type" in
        arch)
            ./scripts/setup/setup-arch.sh
            ;;
        ubuntu)
            ./scripts/setup/setup-ubuntu.sh
            ;;
        macos)
            ./scripts/setup/setup-macos.sh
            ;;
        fedora)
            ./scripts/setup/setup-fedora.sh
            ;;
        *)
            echo "Unsupported OS: $os_type"
            exit 1
            ;;
    esac

    # Install components
    ./scripts/install/install-fonts.sh
    ./scripts/install/install-cli-tools.sh
    ./scripts/utils/create-symlinks.sh

    echo "Installation complete!"
    echo "Restart your terminal or run: source ~/.zshrc"
}

main "$@"
