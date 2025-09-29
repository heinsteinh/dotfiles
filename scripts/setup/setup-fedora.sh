#!/usr/bin/env }

if ! declare -f log_success > /dev/null 2>&1; then
    log_success() { echo "[SUCCESS] $1"; }
fi

if ! declare -f log_warning > /dev/null 2>&1; then
    log_warning() { echo "[WARNING] $1"; }
fi

if ! declare -f log_error > /dev/null 2>&1; then
    log_error() { echo "[ERROR] $1"; }
fi

# Check if running Fedorapecific setup script

set -euo pipefail

# Source common setup functions for colors and logging
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_DIR)")"

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

# Check if running on Fedora
check_fedora() {
    if ! command -v dnf &> /dev/null || [[ ! -f /etc/fedora-release ]]; then
        log_error "This script is designed for Fedora systems only"
        exit 1
    fi
}

# Update system
update_system() {
    log_info "Updating system packages..."
    sudo dnf update -y --refresh
    log_success "System updated successfully"
}

# Configure DNF for better performance
configure_dnf() {
    log_info "Configuring DNF for better performance..."
    
    # Create DNF configuration if it doesn't exist
    if [[ ! -f /etc/dnf/dnf.conf ]]; then
        sudo touch /etc/dnf/dnf.conf
    fi
    
    # Add performance optimizations
    if ! grep -q "^max_parallel_downloads" /etc/dnf/dnf.conf; then
        echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
    fi
    
    if ! grep -q "^fastestmirror" /etc/dnf/dnf.conf; then
        echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
    fi
    
    if ! grep -q "^deltarpm" /etc/dnf/dnf.conf; then
        echo "deltarpm=True" | sudo tee -a /etc/dnf/dnf.conf
    fi
    
    log_success "DNF configured for better performance"
}

# Install RPM Fusion repositories
install_rpmfusion() {
    log_info "Installing RPM Fusion repositories..."
    
    local fedora_version=$(rpm -E %fedora)
    
    # Install RPM Fusion Free
    if ! dnf repolist | grep -q rpmfusion-free; then
        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_version}.noarch.rpm"
    fi
    
    # Install RPM Fusion Non-free
    if ! dnf repolist | grep -q rpmfusion-nonfree; then
        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_version}.noarch.rpm"
    fi
    
    # Update package cache
    sudo dnf update -y --refresh
    
    log_success "RPM Fusion repositories installed"
}

# Install Flathub repository
install_flathub() {
    log_info "Installing Flathub repository..."
    
    # Install flatpak if not already installed
    if ! command -v flatpak &> /dev/null; then
        log_info "Installing Flatpak..."
        sudo dnf install -y flatpak
    fi
    
    # Skip Flathub setup in CI environment (requires systemd)
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected, skipping Flathub remote setup"
        return
    fi
    
    if ! flatpak remote-list | grep -q flathub 2>/dev/null; then
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        log_success "Flathub repository added"
    else
        log_info "Flathub repository already installed"
    fi
}

# Install essential packages
install_essential_packages() {
    log_info "Installing essential packages..."
    
    sudo dnf install -y \
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
        neofetch \
        fastfetch \
        unzip \
        zip \
        tar \
        gzip \
        p7zip \
        p7zip-plugins \
        which \
        man-db \
        man-pages \
        openssh-clients \
        openssh-server \
        rsync \
        gnupg2 \
        pass
    
    log_success "Essential packages installed"
}

# Install modern CLI tools
install_modern_cli_tools() {
    log_info "Installing modern CLI tools..."
    
    sudo dnf install -y \
        ripgrep \
        fd-find \
        bat \
        eza \
        fzf \
        jq \
        yq \
        git-delta \
        lazygit \
        bottom \
        procs \
        dust \
        tokei \
        hyperfine \
        bandwhich \
        gping \
        tealdeer \
        zoxide \
        starship
    
    # Create symlink for fd (Fedora uses fd-find)
    if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi
    
    log_success "Modern CLI tools installed"
}

# Install development tools
install_development_tools() {
    log_info "Installing development tools and compilers..."
    
    # Install development group
    sudo dnf groupinstall -y "Development Tools" "Development Libraries"
    
    # Programming languages
    sudo dnf install -y \
        python3 \
        python3-pip \
        python3-devel \
        python3-virtualenv \
        pipx \
        nodejs \
        npm \
        yarn \
        golang \
        rust \
        cargo \
        java-latest-openjdk \
        java-latest-openjdk-devel \
        maven \
        gradle \
        ruby \
        ruby-devel \
        php \
        php-cli \
        lua \
        luarocks \
        perl \
        R \
        sqlite \
        sqlite-devel
    
    # Development utilities
    sudo dnf install -y \
        podman \
        buildah \
        skopeo \
        kubectl \
        helm \
        terraform \
        ansible \
        vagrant \
        VirtualBox \
        qemu \
        qemu-kvm \
        libvirt \
        virt-manager \
        wireshark \
        nmap \
        nmap-ncat \
        tcpdump \
        strace \
        ltrace \
        gdb \
        valgrind \
        perf \
        iperf3 \
        mtr \
        traceroute
    
    # Enable and start libvirt (skip in CI)
    if [[ "${CI:-}" != "true" ]]; then
        sudo systemctl enable libvirtd
        sudo systemctl start libvirtd
        sudo usermod -aG libvirt "$USER"
    fi
    
    log_success "Development tools installed"
    log_warning "Please log out and back in for group changes to take effect"
}

# Install multimedia packages
install_multimedia_packages() {
    log_info "Installing multimedia packages..."
    
    # Skip audio packages in CI environment
    local audio_packages=""
    if [[ "${CI:-}" != "true" ]]; then
        audio_packages="pulseaudio pulseaudio-utils pavucontrol alsa-utils pipewire pipewire-pulseaudio wireplumber"
    fi
    
    # Multimedia codecs and tools
    sudo dnf install -y \
        @multimedia \
        gstreamer1-plugins-{bad-*,good-*,base} \
        gstreamer1-plugin-openh264 \
        gstreamer1-libav \
        lame \
        ffmpeg \
        ffmpeg-libs \
        ImageMagick \
        GraphicsMagick \
        optipng \
        jpegoptim \
        gifsicle \
        webp \
        libwebp-tools \
        x264 \
        x265 \
        libvpx \
        opus \
        vorbis-tools \
        flac \
        sox \
        ${audio_packages}
    
    log_success "Multimedia packages installed"
}

# Install GUI applications via DNF
install_gui_applications_dnf() {
    log_info "Installing GUI applications via DNF..."
    
    # Skip GUI apps in CI environment
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected, skipping GUI applications"
        return
    fi
    
    sudo dnf install -y \
        firefox \
        thunderbird \
        libreoffice \
        gimp \
        inkscape \
        blender \
        vlc \
        mpv \
        obs-studio \
        audacity \
        cheese \
        gnome-tweaks \
        dconf-editor \
        file-roller \
        gnome-extensions-app \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-dash-to-dock \
        code \
        gitg \
        meld \
        tilix \
        gnome-terminal
    
    log_success "GUI applications (DNF) installed"
}

# Install GUI applications via Flatpak
install_gui_applications_flatpak() {
    log_info "Installing GUI applications via Flatpak..."
    
    # Skip Flatpak apps in CI environment
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected, skipping Flatpak GUI applications"
        return
    fi
    
    if ! command -v flatpak &> /dev/null; then
        log_warning "Flatpak not available, skipping Flatpak applications"
        return
    fi
    
    # Popular applications
    local flatpak_apps=(
        "com.google.Chrome"
        "com.slack.Slack"
        "com.discordapp.Discord"
        "us.zoom.Zoom"
        "com.getpostman.Postman"
        "com.spotify.Client"
        "org.signal.Signal"
        "com.skype.Client"
        "org.telegram.desktop"
        "com.valvesoftware.Steam"
        "org.blender.Blender"
        "org.kde.kdenlive"
        "org.audacityteam.Audacity"
        "org.gnome.Boxes"
        "org.videolan.VLC"
        "io.mpv.Mpv"
        "org.mozilla.Thunderbird"
        "org.libreoffice.LibreOffice"
        "com.obsproject.Studio"
    )
    
    for app in "${flatpak_apps[@]}"; do
        if ! flatpak list --app | grep -q "$app"; then
            log_info "Installing $app..."
            flatpak install -y flathub "$app" || log_warning "Failed to install $app"
        fi
    done
    
    log_success "GUI applications (Flatpak) installed"
}

# Install fonts
install_fonts() {
    log_info "Installing fonts..."
    
    # System fonts
    sudo dnf install -y \
        google-roboto-fonts \
        google-roboto-mono-fonts \
        google-roboto-condensed-fonts \
        google-roboto-slab-fonts \
        liberation-fonts \
        liberation-mono-fonts \
        liberation-sans-fonts \
        liberation-serif-fonts \
        dejavu-fonts-common \
        dejavu-sans-fonts \
        dejavu-sans-mono-fonts \
        dejavu-serif-fonts \
        adobe-source-code-pro-fonts \
        adobe-source-sans-pro-fonts \
        adobe-source-serif-pro-fonts \
        fira-code-fonts \
        jetbrains-mono-fonts \
        cascadia-code-fonts \
        mozilla-fira-mono-fonts \
        mozilla-fira-sans-fonts \
        open-sans-fonts
    
    # Noto fonts for Unicode support
    sudo dnf install -y \
        google-noto-fonts-common \
        google-noto-sans-fonts \
        google-noto-serif-fonts \
        google-noto-mono-fonts \
        google-noto-emoji-fonts \
        google-noto-cjk-fonts
    
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

# Configure firewall
configure_firewall() {
    log_info "Configuring firewall..."
    
    # Skip firewall configuration in CI
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected, skipping firewall configuration"
        return
    fi
    
    # Enable firewalld
    sudo systemctl enable firewalld
    sudo systemctl start firewalld
    
    # Set default zone
    sudo firewall-cmd --set-default-zone=public
    
    # Allow SSH (if needed)
    if systemctl is-enabled sshd &> /dev/null; then
        sudo firewall-cmd --permanent --add-service=ssh
    fi
    
    # Reload firewall
    sudo firewall-cmd --reload
    
    log_success "Firewall configured"
}

# Install and configure security tools
install_security_tools() {
    log_info "Installing security tools..."
    
    sudo dnf install -y \
        fail2ban \
        rkhunter \
        clamav \
        clamav-update \
        lynis \
        aide \
        chkrootkit \
        nftables
    
    # Configure fail2ban (skip in CI)
    if [[ "${CI:-}" != "true" ]]; then
        sudo systemctl enable fail2ban
        sudo systemctl start fail2ban
    fi
    
    # Update ClamAV database (skip in CI)
    if [[ "${CI:-}" != "true" ]]; then
        sudo freshclam || log_warning "ClamAV database update failed, will try later"
    fi
    
    log_success "Security tools installed"
}

# Configure system optimizations
configure_system_optimizations() {
    log_info "Applying system optimizations..."
    
    # Improve I/O scheduler for SSDs
    if [[ -f /sys/block/sda/queue/scheduler ]]; then
        echo 'ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"' | sudo tee /etc/udev/rules.d/60-ioschedulers.rules > /dev/null
    fi
    
    # Configure swappiness
    echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf
    
    # Configure networking
    echo 'net.core.default_qdisc = fq' | sudo tee -a /etc/sysctl.d/99-network.conf
    echo 'net.ipv4.tcp_congestion_control = bbr' | sudo tee -a /etc/sysctl.d/99-network.conf
    
    log_success "System optimizations applied"
}

# Install media codecs
install_media_codecs() {
    log_info "Installing additional media codecs..."
    
    # Install multimedia group
    sudo dnf groupinstall -y multimedia
    
    # Install additional codecs
    sudo dnf install -y \
        gstreamer1-plugins-{bad-*,good-*,ugly-*,base} \
        gstreamer1-libav \
        gstreamer1-plugin-openh264 \
        mozilla-openh264 \
        @multimedia
    
    # Enable OpenH264 codec in Firefox
    if command -v firefox &> /dev/null; then
        sudo dnf config-manager --set-enabled fedora-cisco-openh264
    fi
    
    log_success "Media codecs installed"
}

# Cleanup system
cleanup() {
    log_info "Cleaning up system..."
    
    # Clean DNF cache
    sudo dnf clean all
    
    # Remove orphaned packages
    sudo dnf autoremove -y
    
    # Update package database
    sudo updatedb || log_warning "updatedb not available"
    
    log_success "System cleanup completed"
}

# Main function
main() {
    log_info "Starting Fedora-specific setup..."
    
    # System verification and setup
    check_fedora
    configure_dnf
    update_system
    
    # Repository setup
    install_rpmfusion
    install_flathub
    
    # Core package installation
    install_essential_packages
    install_modern_cli_tools
    
    # Shell setup
    install_starship
    if [[ "${CI:-}" != "true" ]]; then
        set_zsh_default
    fi
    install_oh_my_zsh
    install_zsh_plugins
    
    # System configuration
    configure_system_optimizations
    configure_firewall
    
    # Optional installations based on arguments
    if [[ "${1:-}" == "--full" ]] || [[ "${INSTALL_TYPE:-}" == "development" ]]; then
        install_development_tools
        install_multimedia_packages
        install_gui_applications_dnf
        install_gui_applications_flatpak
        install_fonts
        install_media_codecs
        install_security_tools
    elif [[ "${1:-}" == "--dev" ]]; then
        install_development_tools
        install_fonts
    elif [[ "${1:-}" == "--multimedia" ]]; then
        install_multimedia_packages
        install_media_codecs
        install_fonts
    elif [[ "${1:-}" == "--gui" ]]; then
        install_gui_applications_dnf
        install_gui_applications_flatpak
        install_fonts
    elif [[ "${1:-}" == "--security" ]]; then
        install_security_tools
    fi
    
    # Always install fonts for better terminal experience
    if [[ "${1:-}" != "--minimal" ]]; then
        install_fonts
    fi
    
    # Final cleanup
    cleanup
    
    log_success "Fedora setup completed successfully!"
    log_info "Please run 'source ~/.zshrc' or restart your terminal to apply changes"
    
    # Show post-installation information
    log_info "Post-installation notes:"
    echo "  - Reboot is recommended for all optimizations to take effect"
    echo "  - Group membership changes require logout/login"
    echo "  - Run 'systemctl --failed' to check for any failed services"
    echo "  - Check firewall status with 'sudo firewall-cmd --list-all'"
    echo "  - Flatpak apps may require logout/login to appear in app menu"
}

# Run main function with all arguments
main "$@"
