#!/usr/bin/env bash
# Ubuntu-specific setup script

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu
if ! command -v lsb_release &> /dev/null || [[ "$(lsb_release -si)" != "Ubuntu" ]]; then
    log_error "This script is designed for Ubuntu systems only"
    exit 1
fi

main() {
    log_info "Setting up Ubuntu-specific configurations..."

    # Update package lists
    log_info "Updating package lists..."
    sudo apt update

    # Install essential packages
    log_info "Installing essential packages..."
    sudo apt install -y \
        curl \
        wget \
        git \
        vim \
        ranger \
        zsh \
        tmux \
        tree \
        htop \
        neofetch \
        unzip \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release

    # Install modern CLI tools
    log_info "Installing modern CLI tools..."
    sudo apt install -y \
        ripgrep \
        fd-find \
        bat \
        eza \
        fzf

    # Create symlinks for fd and bat (Ubuntu specific naming)
    if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi

    if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
        sudo ln -sf "$(which batcat)" /usr/local/bin/bat
    fi

    # Install Node.js via NodeSource repository
    if ! command -v node &> /dev/null; then
        log_info "Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
    fi

    # Install Docker
    if ! command -v docker &> /dev/null; then
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

    # Set zsh as default shell
    if [[ "$SHELL" != */zsh ]]; then
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
    sudo apt install -y \
        build-essential \
        python3 \
        python3-pip \
        golang-go \
        default-jdk

    # Install Rust
    if ! command -v cargo &> /dev/null; then
        log_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

    # Clean up
    log_info "Cleaning up..."
    sudo apt autoremove -y
    sudo apt autoclean

    log_success "Ubuntu setup completed successfully!"
    log_info "Please run 'source ~/.zshrc' or restart your terminal to apply changes"
}

main "$@"
