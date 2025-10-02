#!/usr/bin/env bash
# Development tools installation script

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../setup/setup-common.sh
source "$SCRIPT_DIR/../setup/setup-common.sh"

# Development tools installation script
# Tool lists are defined inline within each OS-specific function

install_development_tools() {
    local os
    os=$(detect_os)

    log_info "Installing development tools for $os..."

    case "$os" in
        macos)
            install_macos_dev_tools
            ;;
        ubuntu|debian)
            install_debian_dev_tools
            ;;
        fedora)
            install_fedora_dev_tools
            ;;
        arch)
            install_arch_dev_tools
            ;;
        *)
            log_error "Unsupported operating system: $os"
            exit 1
            ;;
    esac
}

install_macos_dev_tools() {
    # Install Xcode command line tools
    if ! xcode-select -p &> /dev/null; then
        log_info "Installing Xcode command line tools..."
        xcode-select --install
    fi

    # Install Homebrew if not present
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install development tools via Homebrew
    local tools=(
        git vim neovim tmux
        node npm yarn
        python3
        go rust
        openjdk maven gradle
        docker docker-compose
    )

    for tool in "${tools[@]}"; do
        if ! command_exists "$tool" && ! brew list "$tool" &>/dev/null; then
            log_info "Installing $tool..."
            brew install "$tool"
        fi
    done

    # Install Docker Desktop
    if ! command_exists docker; then
        log_info "Installing Docker Desktop..."
        brew install --cask docker
    fi
}

install_debian_dev_tools() {
    # Update package lists
    sudo apt update

    # Install build essentials
    sudo apt install -y build-essential

    # Install basic development tools
    sudo apt install -y \
        git vim neovim tmux \
        curl wget \
        python3 python3-pip python3-venv \
        default-jdk maven gradle

    # Install Node.js via NodeSource
    if ! command_exists node; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
    fi

    # Install Yarn
    if ! command_exists yarn; then
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        sudo apt update && sudo apt install -y yarn
    fi

    # Install Go
    if ! command_exists go; then
        sudo apt install -y golang-go
    fi

    # Install Rust
    if ! command_exists cargo; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        # shellcheck source=/dev/null
        source "$HOME/.cargo/env"
    fi

    # Install Docker
    install_docker_debian
}

install_fedora_dev_tools() {
    # Install development group
    sudo dnf groupinstall -y "Development Tools"

    # Install individual tools
    sudo dnf install -y \
        git vim neovim tmux \
        python3 python3-pip \
        java-latest-openjdk-devel maven gradle \
        nodejs npm yarn \
        golang rust cargo

    # Install Docker
    sudo dnf install -y docker docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
}

install_arch_dev_tools() {
    # Update package database
    sudo pacman -Syu --noconfirm

    # Install base development tools
    sudo pacman -S --noconfirm \
        base-devel git vim neovim tmux \
        python python-pip \
        jdk-openjdk maven gradle \
        nodejs npm yarn \
        go rust

    # Install Docker
    sudo pacman -S --noconfirm docker docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
}

install_docker_debian() {
    if ! command_exists docker; then
        log_info "Installing Docker..."

        # Add Docker's official GPG key
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        # Set up the stable repository
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Install Docker Engine
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io

        # Add user to docker group
        sudo usermod -aG docker "$USER"

        log_info "Installing Docker Compose..."
        sudo apt install -y docker-compose-plugin

        log_warning "Please log out and back in for Docker group changes to take effect"
    fi
}

install_vscode() {
    local os
    os=$(detect_os)

    case "$os" in
        macos)
            if ! command_exists code; then
                log_info "Installing Visual Studio Code..."
                brew install --cask visual-studio-code
            fi
            ;;
        ubuntu|debian)
            if ! command_exists code; then
                log_info "Installing Visual Studio Code..."
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
                echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
                sudo apt update && sudo apt install -y code
            fi
            ;;
        fedora)
            if ! command_exists code; then
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
                sudo dnf install -y code
            fi
            ;;
        arch)
            if ! command_exists code; then
                yay -S --noconfirm visual-studio-code-bin ||
                sudo pacman -S --noconfirm code
            fi
            ;;
    esac
}

main() {
    log_info "Starting development tools installation..."

    install_development_tools

    # Skip interactive prompts in CI mode
    if [[ "${CI:-}" != "true" ]] && [[ "${DOTFILES_CI_MODE:-}" != "true" ]] && [[ "${DOTFILES_SKIP_INTERACTIVE:-}" != "true" ]]; then
        if confirm "Do you want to install Visual Studio Code?"; then
            install_vscode
        fi
    else
        log_info "Skipping Visual Studio Code installation in CI mode"
    fi

    log_success "Development tools installation completed!"
    log_info "Please restart your terminal or run 'source ~/.zshrc' to update your environment"

    # Show installed versions
    log_info "Installed tool versions:"
    for tool in git node python3 go rustc java; do
        if command_exists "$tool"; then
            case "$tool" in
                git) echo "  Git: $(git --version)" ;;
                node) echo "  Node.js: $(node --version)" ;;
                python3) echo "  Python: $(python3 --version)" ;;
                go) echo "  Go: $(go version | cut -d' ' -f3)" ;;
                rustc) echo "  Rust: $(rustc --version | cut -d' ' -f2)" ;;
                java) echo "  Java: $(java --version 2>&1 | head -1)" ;;
            esac
        fi
    done
}

main "$@"
