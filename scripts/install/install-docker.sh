#!/usr/bin/env bash
# Docker installation and setup script

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../setup/setup-common.sh
source "$SCRIPT_DIR/../setup/setup-common.sh"

install_docker() {
    local os
    os=$(detect_os)

    log_info "Installing Docker for $os..."

    case "$os" in
        macos)
            install_docker_macos
            ;;
        ubuntu|debian)
            install_docker_debian
            ;;
        fedora)
            install_docker_fedora
            ;;
        arch)
            install_docker_arch
            ;;
        *)
            log_error "Unsupported operating system: $os"
            exit 1
            ;;
    esac
}

install_docker_macos() {
    if ! command_exists docker; then
        log_info "Installing Docker Desktop for macOS..."

        if command_exists brew; then
            brew install --cask docker
        else
            log_info "Please install Docker Desktop manually from https://www.docker.com/products/docker-desktop"
            exit 1
        fi

        log_info "Starting Docker Desktop..."
        open -a Docker

        # Wait for Docker to start
        log_info "Waiting for Docker to start..."
        while ! docker system info &> /dev/null; do
            sleep 5
            echo -n "."
        done
        echo

    else
        log_info "Docker is already installed"
    fi
}

install_docker_debian() {
    if ! command_exists docker; then
        log_info "Installing Docker Engine for Debian/Ubuntu..."

        # Remove old versions
        sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

        # Update package index
        sudo apt update

        # Install prerequisites
        sudo apt install -y \
            ca-certificates \
            curl \
            gnupg \
            lsb-release

        # Add Docker's official GPG key
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        # Set up repository
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Install Docker Engine
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

        # Start and enable Docker
        sudo systemctl start docker
        sudo systemctl enable docker

        # Add user to docker group
        sudo usermod -aG docker "$USER"

        log_warning "Please log out and back in for Docker group changes to take effect"

    else
        log_info "Docker is already installed"
    fi
}

install_docker_fedora() {
    if ! command_exists docker; then
        log_info "Installing Docker Engine for Fedora..."

        # Remove old versions
        sudo dnf remove -y docker \
                          docker-client \
                          docker-client-latest \
                          docker-common \
                          docker-latest \
                          docker-latest-logrotate \
                          docker-logrotate \
                          docker-selinux \
                          docker-engine-selinux \
                          docker-engine 2>/dev/null || true

        # Install dnf-plugins-core
        sudo dnf install -y dnf-plugins-core

        # Add Docker repository
        sudo dnf config-manager \
            --add-repo \
            https://download.docker.com/linux/fedora/docker-ce.repo

        # Install Docker Engine
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

        # Start and enable Docker
        sudo systemctl start docker
        sudo systemctl enable docker

        # Add user to docker group
        sudo usermod -aG docker "$USER"

        log_warning "Please log out and back in for Docker group changes to take effect"

    else
        log_info "Docker is already installed"
    fi
}

install_docker_arch() {
    if ! command_exists docker; then
        log_info "Installing Docker for Arch Linux..."

        # Install Docker
        sudo pacman -S --noconfirm docker docker-compose

        # Start and enable Docker
        sudo systemctl start docker
        sudo systemctl enable docker

        # Add user to docker group
        sudo usermod -aG docker "$USER"

        log_warning "Please log out and back in for Docker group changes to take effect"

    else
        log_info "Docker is already installed"
    fi
}

configure_docker() {
    log_info "Configuring Docker..."

    # Create Docker daemon configuration
    sudo mkdir -p /etc/docker

    # Configure Docker daemon with better defaults
    cat << 'EOF' | sudo tee /etc/docker/daemon.json > /dev/null
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-address-pools": [
    {
      "base": "172.17.0.0/12",
      "size": 24
    }
  ],
  "storage-driver": "overlay2",
  "features": {
    "buildkit": true
  }
}
EOF

    # Restart Docker to apply configuration
    if [[ "$(detect_os)" != "macos" ]]; then
        sudo systemctl restart docker
    fi
}

install_docker_compose() {
    if ! command_exists docker-compose; then
        log_info "Installing Docker Compose..."

        local latest_version
        latest_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

        sudo curl -L "https://github.com/docker/compose/releases/download/${latest_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose

        # Create symbolic link for easier access
        if [[ ! -f /usr/bin/docker-compose ]]; then
            sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
        fi

        log_success "Docker Compose $(docker-compose --version) installed"
    else
        log_info "Docker Compose is already installed"
    fi
}

verify_docker_installation() {
    log_info "Verifying Docker installation..."

    # Test Docker
    if docker --version && docker system info > /dev/null 2>&1; then
        log_success "Docker is working correctly"
        echo "  Docker version: $(docker --version)"

        # Test with hello-world if user confirms
        if confirm "Run Docker hello-world test?"; then
            docker run --rm hello-world
        fi
    else
        log_error "Docker installation verification failed"
        return 1
    fi

    # Test Docker Compose
    if command_exists docker-compose; then
        echo "  Docker Compose version: $(docker-compose --version)"
        log_success "Docker Compose is working correctly"
    fi
}

setup_docker_aliases() {
    log_info "Setting up Docker aliases..."

    # Create Docker aliases file
    cat << 'EOF' > "$HOME/.docker_aliases"
# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dip='docker image prune'
alias dvp='docker volume prune'
alias dnp='docker network prune'
alias dsp='docker system prune'
alias dcp='docker container prune'
alias dex='docker exec -it'
alias dlog='docker logs'
alias dlogf='docker logs -f'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'
alias dclean='docker system prune -af'

# Docker Compose aliases
alias dcu='docker-compose up'
alias dcud='docker-compose up -d'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'
alias dce='docker-compose exec'
alias dcps='docker-compose ps'
alias dcrestart='docker-compose restart'
alias dcpull='docker-compose pull'

# Useful Docker functions
dsh() {
    docker exec -it "$1" /bin/bash
}

dzsh() {
    docker exec -it "$1" /bin/zsh
}

dsh-root() {
    docker exec -u root -it "$1" /bin/bash
}
EOF

    log_success "Docker aliases created in ~/.docker_aliases"
    log_info "Add 'source ~/.docker_aliases' to your shell configuration to use them"
}

main() {
    log_info "Starting Docker installation and setup..."

    install_docker
    configure_docker

    # Install Docker Compose separately for non-macOS systems
    if [[ "$(detect_os)" != "macos" ]]; then
        install_docker_compose
    fi

    setup_docker_aliases
    verify_docker_installation

    log_success "Docker installation and setup completed!"

    if [[ "$(detect_os)" != "macos" ]]; then
        log_info "To use Docker without sudo, please:"
        log_info "1. Log out and back in (or run 'newgrp docker')"
        log_info "2. Restart your terminal"
    fi

    log_info "Useful commands:"
    log_info "  docker --version       # Check Docker version"
    log_info "  docker run hello-world # Test Docker installation"
    log_info "  docker ps              # List running containers"
    log_info "  docker images          # List Docker images"
}

main "$@"
