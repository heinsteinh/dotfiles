#!/usr/bin/env bash
# Ubuntu/Debian-specific setup script

set -euo pipefail

# Source common setup functions for colors and logging
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [[ -f "$DOTFILES_DIR/scripts/setup/setup-common.sh" ]]; then
    source "$DOTFILES_DIR/scripts/setup/setup-common.sh"
else
    echo "[ERROR] Cannot find setup-common.sh"
    exit 1
fi

# Check if running on Ubuntu (container-aware)
is_ubuntu() {
    # Check multiple ways to detect Ubuntu (container-friendly)
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        [[ "$ID" == "ubuntu" ]] && return 0
    fi

    # Fallback to lsb_release if available
    if command -v lsb_release &> /dev/null; then
        [[ "$(lsb_release -si)" == "Ubuntu" ]] && return 0
    fi

    # Check /etc/issue as another fallback
    if [[ -f /etc/issue ]] && grep -qi ubuntu /etc/issue; then
        return 0
    fi

    # Check if we're in a Ubuntu container (CI environment)
    if [[ "${CI:-}" == "true" ]] && [[ -f /etc/debian_version ]]; then
        log_info "Detected Ubuntu-based container in CI environment"
        return 0
    fi

    return 1
}

# Install modern CLI tools with proper repositories
install_modern_cli_tools() {
    log_info "Installing modern CLI tools..."

    # Install tools available in default repositories
    sudo apt install -y -qq \
        ripgrep \
        fd-find \
        fzf \
        jq || log_warning "Some packages from default repositories failed to install"

    # Install bat (available in Ubuntu 20.04+)
    if sudo apt install -y -qq bat 2>/dev/null; then
        log_success "bat installed from repository"
    else
        # Fallback: install batcat (older Ubuntu versions)
        sudo apt install -y -qq batcat || log_warning "Failed to install bat/batcat"
    fi

    # Install eza from GitHub releases (not in Ubuntu repos)
    if ! command -v eza &> /dev/null; then
        log_info "Installing eza from GitHub releases..."
        if install_eza_from_github; then
            log_success "eza installed successfully"
        else
            log_warning "Failed to install eza, will use ls with aliases"
        fi
    fi

    # Install fastfetch (modern neofetch replacement)
    if ! command -v fastfetch &> /dev/null; then
        log_info "Installing fastfetch..."
        if install_fastfetch; then
            log_success "fastfetch installed successfully"
        else
            log_warning "Failed to install fastfetch"
        fi
    fi

    # Create symlinks for Ubuntu-specific naming
    create_cli_symlinks
}

# Install eza from GitHub releases
install_eza_from_github() {
    # Skip in CI to avoid network issues
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected, skipping eza installation"
        return 1
    fi

    local eza_version
    local architecture
    local temp_dir

    # Detect architecture
    case "$(uname -m)" in
        x86_64) architecture="x86_64" ;;
        aarch64|arm64) architecture="aarch64" ;;
        *)
            log_warning "Unsupported architecture for eza: $(uname -m)"
            return 1
            ;;
    esac

    # Get latest version
    eza_version=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep -o '"tag_name": "v[^"]*' | cut -d'"' -f4 | cut -d'v' -f2) || {
        log_warning "Failed to get eza version from GitHub"
        return 1
    }

    # Download and install
    temp_dir=$(mktemp -d)
    cd "$temp_dir"

    local download_url="https://github.com/eza-community/eza/releases/download/v${eza_version}/eza_${architecture}-unknown-linux-gnu.tar.gz"

    if curl -L "$download_url" -o eza.tar.gz && tar -xzf eza.tar.gz; then
        sudo mv eza /usr/local/bin/eza
        sudo chmod +x /usr/local/bin/eza
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 0
    else
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
}

# Install fastfetch
install_fastfetch() {
    # Try to install from PPA first
    if [[ "${CI:-}" != "true" ]]; then
        # Add PPA for fastfetch
        if sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y 2>/dev/null && sudo apt update 2>/dev/null; then
            if sudo apt install -y fastfetch 2>/dev/null; then
                return 0
            fi
        fi
    fi

    # Fallback: install from GitHub releases
    local temp_dir
    temp_dir=$(mktemp -d)
    cd "$temp_dir"

    local architecture
    case "$(uname -m)" in
        x86_64) architecture="amd64" ;;
        aarch64|arm64) architecture="arm64" ;;
        *)
            log_warning "Unsupported architecture for fastfetch: $(uname -m)"
            cd - > /dev/null
            rm -rf "$temp_dir"
            return 1
            ;;
    esac

    # Get Ubuntu version
    local ubuntu_version
    ubuntu_version=$(lsb_release -rs | cut -d'.' -f1,2)

    # Try to download appropriate .deb package
    local download_url="https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${architecture}.deb"

    if curl -L "$download_url" -o fastfetch.deb && sudo dpkg -i fastfetch.deb; then
        # Fix any dependency issues
        sudo apt-get install -f -y || true
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 0
    else
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
}

# Create symlinks for Ubuntu-specific naming
create_cli_symlinks() {
    # Create symlink for fd (Ubuntu uses fd-find)
    if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
        log_success "Created fd symlink"
    fi

    # Create symlink for bat (Ubuntu might use batcat)
    if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
        sudo ln -sf "$(which batcat)" /usr/local/bin/bat
        log_success "Created bat symlink"
    fi
}

if ! is_ubuntu; then
    log_error "This script is designed for Ubuntu systems only"
    exit 1
fi

main() {
    log_info "Setting up Ubuntu-specific configurations..."

    # Update package lists
    log_info "Updating package lists..."
    sudo apt update -qq

    # Install essential packages
    log_info "Installing essential packages..."
    sudo apt install -y -qq \
        curl \
        wget \
        git \
        vim \
        neovim \
        ranger \
        newsboat \
        zsh \
        tmux \
        tree \
        htop \
        unzip \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release

    # Install modern CLI tools
    log_info "Installing modern CLI tools..."
    install_modern_cli_tools

    # Install Node.js via NodeSource repository (skip in CI)
    if [[ "${CI:-}" != "true" ]] && ! command -v node &> /dev/null; then
        log_info "Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
    fi

    # Install Docker (skip in CI)
    if [[ "${CI:-}" != "true" ]] && ! command -v docker &> /dev/null; then
        log_info "Installing Docker..."
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io
        sudo usermod -aG docker "$USER"
        log_warning "Please log out and back in for Docker group changes to take effect"
    fi

    # Install Starship prompt
    if ! command -v starship &> /dev/null; then
        log_info "Installing Starship prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # Set zsh as default shell (skip in CI)
    if [[ "${CI:-}" != "true" ]] && [[ "$SHELL" != */zsh ]]; then
        log_info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        log_warning "Please log out and back in for shell change to take effect"
    fi

    # Install Oh My Zsh if not present
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install Zsh plugins
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [[ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    fi

    if [[ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_custom/plugins/zsh-syntax-highlighting"
    fi

    # Install development tools
    log_info "Installing development tools..."
    if [[ "${CI:-}" == "true" ]]; then
        # Minimal development tools for CI
        sudo apt install -y -qq \
            build-essential \
            python3 \
            python3-pip || log_warning "Some development tools failed to install"
    else
        # Full development tools for regular installation
        sudo apt install -y -qq \
            build-essential \
            python3 \
            python3-pip \
            golang-go \
            default-jdk || log_warning "Some development tools failed to install"
    fi

    # Install Rust (skip in CI)
    if [[ "${CI:-}" != "true" ]] && ! command -v cargo &> /dev/null; then
        log_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

    # Clean up
    log_info "Cleaning up..."
    sudo apt autoremove -y -qq
    sudo apt autoclean -qq

    log_success "Ubuntu setup completed successfully!"
    log_info "Please run 'source ~/.zshrc' or restart your terminal to apply changes"
}

main "$@"
