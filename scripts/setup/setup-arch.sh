#!/usr/bin/env bash

if ! declare -f log_success > /dev/null 2>&1; then
    log_success() { echo "[SUCCESS] $1"; }
fi

if ! declare -f log_warning > /dev/null 2>&1; then
    log_warning() { echo "[WARNING] $1"; }
fi

if ! declare -f log_error > /dev/null 2>&1; then
    log_error() { echo "[ERROR] $1"; }
fi

# Check if running Arch Linuxux-specific setup script

set -euo pipefail

# Source common setup functions for colors and logging
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [[ -f "$DOTFILES_DIR/scripts/setup/setup-common.sh" ]]; then
    source "$DOTFILES_DIR/scripts/setup/setup-common.sh"
fi

# Additional logging functions if not defined
if ! declare -f log_info > /dev/null 2>&1; then
    log_info() { echo "[INFO] $1"; }
fi

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Arch Linux
check_arch_linux() {
    if ! command -v pacman &> /dev/null || [[ ! -f /etc/arch-release ]]; then
        log_error "This script is designed for Arch Linux systems only"
        exit 1
    fi
}

# Update system
update_system() {
    log_info "Updating system packages..."
    sudo pacman -Syu --noconfirm
    log_success "System updated successfully"
}

# Install essential packages
install_essential_packages() {
    log_info "Installing essential packages..."

    sudo pacman -S --needed --noconfirm \
        base-devel \
        curl \
        wget \
        git \
        vim \
        neovim \
        ranger \
        zsh \
        tmux \
        tree \
        htop \
        btop \
        fastfetch \
        unzip \
        zip \
        tar \
        gzip \
        p7zip \
        which \
        man-db \
        man-pages \
        openssh \
        rsync

    log_success "Essential packages installed"
}

# Install modern CLI tools
install_modern_cli_tools() {
    log_info "Installing modern CLI tools..."

    sudo pacman -S --needed --noconfirm \
        ripgrep \
        fd \
        bat \
        eza \
        fzf \
        jq \
        yq \
        lazygit \
        bottom \
        procs \
        dust \
        tokei \
        hyperfine \
        bandwhich \
        gping \
        dog \
        choose \
        sd \
        tealdeer \
        zoxide \
        mcfly \
        starship

    log_success "Modern CLI tools installed"
}

# Install AUR helper (yay)
install_aur_helper() {
    # Skip AUR helper in CI environment
    if [[ "${CI:-}" == "true" ]] || [[ "${DOTFILES_CI_MODE:-}" == "true" ]]; then
        log_info "CI environment detected, skipping AUR helper installation"
        return 0
    fi

    if ! command -v yay &> /dev/null; then
        log_info "Installing yay AUR helper..."

        # Create temporary directory
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"

        # Clone and build yay
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm

        # Cleanup
        cd "$HOME"
        rm -rf "$temp_dir"

        log_success "yay AUR helper installed"
    else
        log_info "yay AUR helper already installed"
    fi
}

# Install AUR packages
install_aur_packages() {
    log_info "Installing AUR packages..."

    # Skip AUR packages in CI environment
    if [[ "${CI:-}" == "true" ]] || [[ "${DOTFILES_CI_MODE:-}" == "true" ]]; then
        log_info "CI environment detected, skipping AUR packages"
        return 0
    fi

    # Check if yay is available
    if ! command -v yay &> /dev/null; then
        log_warning "yay not found, skipping AUR packages"
        return
    fi

    yay -S --needed --noconfirm \
        lazydocker \
        nvm \
        visual-studio-code-bin \
        google-chrome \
        firefox-developer-edition \
        slack-desktop \
        discord \
        zoom \
        postman-bin \
        dbeaver \
        obsidian \
        spotify \
        vlc \
        gimp \
        inkscape \
        blender \
        obs-studio

    log_success "AUR packages installed"
}

# Install development tools
install_development_tools() {
    log_info "Installing development tools..."

    # Programming languages and runtimes
    sudo pacman -S --needed --noconfirm \
        python \
        python-pip \
        python-pipx \
        python-virtualenv \
        nodejs \
        npm \
        yarn \
        go \
        rust \
        cargo \
        jdk-openjdk \
        maven \
        gradle \
        ruby \
        php \
        lua \
        luarocks

    # Development utilities
    sudo pacman -S --needed --noconfirm \
        docker \
        docker-compose \
        kubectl \
        helm \
        terraform \
        ansible \
        vagrant \
        virtualbox \
        qemu \
        libvirt \
        virt-manager \
        wireshark-qt \
        nmap \
        tcpdump \
        strace \
        ltrace \
        gdb \
        valgrind \
        perf \
        iperf3

    # Enable Docker service (skip in CI)
    if [[ "${CI:-}" != "true" ]]; then
        sudo systemctl enable docker.service
        sudo systemctl start docker.service
        sudo usermod -aG docker "$USER"
    fi

    log_success "Development tools installed"
    log_warning "Please log out and back in for Docker group changes to take effect"
}

# Install multimedia and graphics packages
install_multimedia_packages() {
    log_info "Installing multimedia and graphics packages..."

    # Skip audio packages in CI environment
    local audio_packages=""
    if [[ "${CI:-}" != "true" ]]; then
        audio_packages="alsa-utils pulseaudio pulseaudio-alsa pavucontrol"
    fi

    sudo pacman -S --needed --noconfirm \
        ${audio_packages} \
        ffmpeg \
        imagemagick \
        graphicsmagick \
        optipng \
        jpegoptim \
        gifsicle \
        webp \
        libwebp \
        x264 \
        x265 \
        libvpx \
        opus

    log_success "Multimedia packages installed"
}

# Install fonts
install_fonts() {
    log_info "Installing fonts..."

    # System fonts
    sudo pacman -S --needed --noconfirm \
        ttf-dejavu \
        ttf-liberation \
        ttf-roboto \
        ttf-roboto-mono \
        ttf-opensans \
        ttf-fira-code \
        ttf-fira-mono \
        ttf-fira-sans \
        ttf-jetbrains-mono \
        ttf-cascadia-code \
        noto-fonts \
        noto-fonts-emoji \
        noto-fonts-cjk \
        adobe-source-code-pro-fonts \
        adobe-source-sans-fonts \
        adobe-source-serif-fonts

    # Nerd fonts (if yay is available)
    if command -v yay &> /dev/null; then
        log_info "Installing Nerd Fonts via AUR..."
        yay -S --needed --noconfirm \
            ttf-firacode-nerd \
            ttf-jetbrains-mono-nerd \
            ttf-hack-nerd \
            ttf-meslo-nerd \
            ttf-sourcecodepro-nerd
    fi

    log_success "Fonts installed"
}

# Install Starship prompt
install_starship() {
    if ! command -v starship &> /dev/null; then
        log_info "Installing Starship prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        log_success "Starship prompt installed"
    else
        log_info "Starship prompt already installed"
    fi
}

# Set zsh as default shell
set_zsh_default() {
    # Skip changing shell in CI environment
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected, skipping shell change"
        return
    fi

    if [[ "$SHELL" != */zsh ]]; then
        log_info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        log_warning "Please restart your terminal for shell change to take effect"
    else
        log_info "Zsh is already the default shell"
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    else
        log_info "Oh My Zsh already installed"
    fi
}

# Install Zsh plugins
install_zsh_plugins() {
    log_info "Installing Zsh plugins..."
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [[ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting
    if [[ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_custom/plugins/zsh-syntax-highlighting"
    fi

    # zsh-fast-syntax-highlighting
    if [[ ! -d "$zsh_custom/plugins/fast-syntax-highlighting" ]]; then
        log_info "Installing zsh-fast-syntax-highlighting..."
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$zsh_custom/plugins/fast-syntax-highlighting"
    fi

    # zsh-autocomplete
    if [[ ! -d "$zsh_custom/plugins/zsh-autocomplete" ]]; then
        log_info "Installing zsh-autocomplete..."
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$zsh_custom/plugins/zsh-autocomplete"
    fi

    log_success "Zsh plugins installed"
}

# Configure system settings
configure_system_settings() {
    log_info "Configuring system settings..."

    # Enable multilib repository (for 32-bit support)
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        log_info "Enabling multilib repository..."
        sudo sed -i '/^#\[multilib\]/,/^#Include/ { s/^#//; }' /etc/pacman.conf
        sudo pacman -Sy
    fi

    # Configure makepkg for faster builds
    log_info "Optimizing makepkg configuration..."
    local cpu_cores=$(nproc)
    sudo sed -i "s/^#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$cpu_cores\"/" /etc/makepkg.conf
    sudo sed -i 's/^COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 0 -z -)/' /etc/makepkg.conf

    # Configure pacman for parallel downloads
    if ! grep -q "^ParallelDownloads" /etc/pacman.conf; then
        log_info "Enabling parallel downloads in pacman..."
        sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
    fi

    # Enable color output in pacman
    if ! grep -q "^Color" /etc/pacman.conf; then
        log_info "Enabling color output in pacman..."
        sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
    fi

    log_success "System settings configured"
}

# Install security tools
install_security_tools() {
    log_info "Installing security tools..."

    sudo pacman -S --needed --noconfirm \
        ufw \
        fail2ban \
        rkhunter \
        clamav \
        lynis \
        checksec \
        nftables \
        iptables-nft

    # Enable and configure UFW (skip in CI)
    if [[ "${CI:-}" != "true" ]]; then
        sudo ufw --force reset
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        sudo ufw enable

        # Enable fail2ban
        sudo systemctl enable fail2ban.service
    fi

    log_success "Security tools installed and configured"
}

# Cleanup
cleanup() {
    log_info "Cleaning up..."

    # Clean pacman cache
    sudo pacman -Sc --noconfirm

    # Clean yay cache if available
    if command -v yay &> /dev/null; then
        yay -Sc --noconfirm
    fi

    # Remove orphaned packages
    local orphans=$(pacman -Qdtq 2>/dev/null || true)
    if [[ -n "$orphans" ]]; then
        log_info "Removing orphaned packages..."
        sudo pacman -Rns $orphans --noconfirm
    fi

    log_success "Cleanup completed"
}

# Main function
main() {
    log_info "Starting Arch Linux-specific setup..."

    # Check CI environment
    if [[ "${CI:-}" == "true" ]] || [[ "${DOTFILES_CI_MODE:-}" == "true" ]]; then
        log_info "CI environment detected (CI=${CI:-false}, DOTFILES_CI_MODE=${DOTFILES_CI_MODE:-false})"
    fi

    # Verification and core setup
    check_arch_linux
    update_system
    install_essential_packages
    install_modern_cli_tools
    configure_system_settings

    # AUR setup
    install_aur_helper

    # Shell setup
    install_starship
    set_zsh_default
    install_oh_my_zsh
    install_zsh_plugins

    # Optional installations based on arguments
    # Always respect CI environment regardless of flags
    if [[ "${CI:-}" == "true" ]] || [[ "${DOTFILES_CI_MODE:-}" == "true" ]]; then
        log_info "CI environment detected, using minimal installation profile"
        # Skip additional installations in CI
    elif [[ "${1:-}" == "--full" ]] || [[ "${INSTALL_TYPE:-}" == "development" ]]; then
        install_development_tools
        install_aur_packages
        install_multimedia_packages
        install_fonts
        install_security_tools
    elif [[ "${1:-}" == "--dev" ]]; then
        install_development_tools
        install_fonts
    elif [[ "${1:-}" == "--security" ]]; then
        install_security_tools
    elif [[ "${1:-}" == "--multimedia" ]]; then
        install_multimedia_packages
        install_fonts
    elif [[ "${1:-}" == "--minimal" ]]; then
        # In minimal mode (like CI), just install essential fonts
        if [[ "${CI:-}" != "true" ]]; then
            install_fonts
        fi
    fi

    # Always install fonts for better terminal experience (unless minimal CI)
    if [[ "${1:-}" != "--minimal" ]] && [[ "${CI:-}" != "true" ]]; then
        install_fonts
    fi

    # Cleanup
    cleanup

    log_success "Arch Linux setup completed successfully!"
    log_info "Please run 'source ~/.zshrc' or restart your terminal to apply changes"

    # Show post-installation information
    log_info "Post-installation notes:"
    echo "  - Reboot is recommended for all changes to take effect"
    echo "  - Docker group membership requires logout/login"
    echo "  - Consider running 'sudo updatedb' to update locate database"
    echo "  - Run 'systemctl --failed' to check for any failed services"
}

# Run main function with all arguments
main "$@"
