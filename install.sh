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
    
    # CI environment detection
    if [[ "${CI:-}" == "true" ]]; then
        echo "CI environment detected - running in non-interactive mode"
        export DOTFILES_SKIP_INTERACTIVE=true
        export DOTFILES_CI_MODE=true
    fi
    
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

    # Install components with error handling for CI
    echo "Installing fonts..."
    ./scripts/install/install-fonts.sh || { echo "Font installation failed (continuing)"; }
    
    echo "Installing CLI tools..."
    ./scripts/install/install-cli-tools.sh || { echo "CLI tools installation failed (continuing)"; }
    
    echo "Creating symlinks..."
    ./scripts/utils/create-symlinks.sh || { echo "Symlink creation failed (continuing)"; }

    echo "Installation complete!"
    
    if [[ "${CI:-}" != "true" ]]; then
        echo "Restart your terminal or run: source ~/.zshrc"
    else
        echo "CI installation completed - symlinks created for testing"
    fi
}

main "$@"
