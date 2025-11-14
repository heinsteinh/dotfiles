# ~/.config/zsh/distro.zsh - Distribution-Specific Configuration Loader

# ============================================================================
# OS Detection
# ============================================================================

# Detect operating system and distribution
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /etc/arch-release ]]; then
            echo "arch"
        elif [[ -f /etc/debian_version ]]; then
            if [[ -f /etc/lsb-release ]] && grep -q "Ubuntu" /etc/lsb-release; then
                echo "ubuntu"
            else
                echo "debian"
            fi
        elif [[ -f /etc/redhat-release ]]; then
            if grep -q "Fedora" /etc/redhat-release; then
                echo "fedora"
            else
                echo "rhel"
            fi
        elif [[ -f /etc/opensuse-release ]]; then
            echo "opensuse"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

OS_TYPE=$(detect_os)

# ============================================================================
# Universal Linux Aliases (for any Linux distribution)
# ============================================================================
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # System information
    alias kernel='uname -r'
    alias cpu-temp='sensors | grep Core'
    alias gpu-temp='nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo "No NVIDIA GPU found"'

    # Hardware information
    alias hardware-info='sudo lshw -short'
    alias memory-info='sudo dmidecode --type memory'
    alias disk-info='sudo fdisk -l'
    alias usb-info='lsusb'
    alias pci-info='lspci'

    # Network management
    alias interfaces='ip link show'
    alias routes='ip route show'
    alias arp-table='ip neighbor show'
    alias network-restart='sudo systemctl restart NetworkManager'

    # Firewall (iptables/ufw)
    if command -v ufw &> /dev/null; then
        alias firewall-status='sudo ufw status'
        alias firewall-enable='sudo ufw enable'
        alias firewall-disable='sudo ufw disable'
    fi

    # X11/Wayland
    alias display-info='echo $XDG_SESSION_TYPE'
    alias x11-info='xrandr'
    alias compositor='echo $XDG_CURRENT_DESKTOP'

    # Power management
    alias suspend='sudo systemctl suspend'
    alias hibernate='sudo systemctl hibernate'
    alias poweroff='sudo systemctl poweroff'
    alias reboot='sudo systemctl reboot'

    # Clipboard (X11)
    if command -v xclip &> /dev/null; then
        alias copy='xclip -selection clipboard'
        alias paste='xclip -selection clipboard -o'
    elif command -v xsel &> /dev/null; then
        alias copy='xsel --clipboard --input'
        alias paste='xsel --clipboard --output'
    fi
fi

# ============================================================================
# Universal Package Manager Wrapper
# ============================================================================

# Universal package management function
pkg() {
    case "$1" in
        install|i)
            shift
            case "$OS_TYPE" in
                arch) sudo pacman -S "$@" ;;
                ubuntu|debian) sudo apt install "$@" ;;
                fedora|rhel) sudo dnf install "$@" ;;
                opensuse) sudo zypper install "$@" ;;
                macos) brew install "$@" ;;
            esac
            ;;
        search|s)
            shift
            case "$OS_TYPE" in
                arch) pacman -Ss "$@" ;;
                ubuntu|debian) apt search "$@" ;;
                fedora|rhel) dnf search "$@" ;;
                opensuse) zypper search "$@" ;;
                macos) brew search "$@" ;;
            esac
            ;;
        update|u)
            case "$OS_TYPE" in
                arch) sudo pacman -Syu ;;
                ubuntu|debian) sudo apt update && sudo apt upgrade ;;
                fedora|rhel) sudo dnf update ;;
                opensuse) sudo zypper update ;;
                macos) brew update && brew upgrade ;;
            esac
            ;;
        remove|r)
            shift
            case "$OS_TYPE" in
                arch) sudo pacman -R "$@" ;;
                ubuntu|debian) sudo apt remove "$@" ;;
                fedora|rhel) sudo dnf remove "$@" ;;
                opensuse) sudo zypper remove "$@" ;;
                macos) brew uninstall "$@" ;;
            esac
            ;;
        info)
            shift
            case "$OS_TYPE" in
                arch) pacman -Si "$@" ;;
                ubuntu|debian) apt show "$@" ;;
                fedora|rhel) dnf info "$@" ;;
                opensuse) zypper info "$@" ;;
                macos) brew info "$@" ;;
            esac
            ;;
        list)
            case "$OS_TYPE" in
                arch) pacman -Q ;;
                ubuntu|debian) apt list --installed ;;
                fedora|rhel) dnf list installed ;;
                opensuse) zypper search --installed-only ;;
                macos) brew list ;;
            esac
            ;;
        clean)
            case "$OS_TYPE" in
                arch) sudo pacman -Sc ;;
                ubuntu|debian) sudo apt autoremove && sudo apt autoclean ;;
                fedora|rhel) sudo dnf clean all ;;
                opensuse) sudo zypper clean ;;
                macos) brew cleanup ;;
            esac
            ;;
        *)
            echo "Usage: pkg [install|search|update|remove|info|list|clean] [package]"
            echo "Universal package manager wrapper for different distributions"
            ;;
    esac
}

# ============================================================================
# System Information Function
# ============================================================================

sysinfo() {
    echo "=== System Information ==="
    echo "OS: $OS_TYPE"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo
    echo "=== Hardware ==="
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "CPU: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs 2>/dev/null || echo 'Unknown')"
        echo "Memory: $(free -h | awk '/^Mem:/ {print $2}' 2>/dev/null || echo 'Unknown')"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "CPU: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo 'Unknown')"
        echo "Memory: $(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)"GB"}' 2>/dev/null || echo 'Unknown')"
    fi
    echo
    echo "=== Package Manager ==="
    case "$OS_TYPE" in
        arch) echo "Package Manager: pacman" ;;
        ubuntu|debian) echo "Package Manager: apt" ;;
        fedora|rhel) echo "Package Manager: dnf" ;;
        opensuse) echo "Package Manager: zypper" ;;
        macos) echo "Package Manager: homebrew" ;;
        *) echo "Package Manager: unknown" ;;
    esac
}

# ============================================================================
# Distribution-Specific Help
# ============================================================================

distro_help() {
    echo "Distribution-specific commands for $OS_TYPE:"
    echo

    case "$OS_TYPE" in
        arch)
            echo "Package Management:"
            echo "  pac-install <pkg>     - Install package"
            echo "  pac-search <term>     - Search packages"
            echo "  pac-update            - Update system"
            echo "  pac-remove <pkg>      - Remove package"
            echo "  pac-orphans           - Remove orphaned packages"
            echo "  pac-clean             - Clean package cache"
            echo
            echo "AUR:"
            echo "  yay-install <pkg>     - Install from AUR"
            echo "  yay-update            - Update AUR packages"
            echo
            echo "System:"
            echo "  update-mirrors        - Update pacman mirrors"
            echo "  pacnew                - Find .pacnew files"
            ;;
        ubuntu|debian)
            echo "Package Management:"
            echo "  apt-install <pkg>     - Install package"
            echo "  apt-search <term>     - Search packages"
            echo "  apt-upgrade           - Update system"
            echo "  apt-remove <pkg>      - Remove package"
            echo "  apt-autoremove        - Remove unused packages"
            echo "  apt-clean             - Clean package cache"
            echo
            echo "Repository:"
            echo "  add-repo <repo>       - Add repository"
            echo "  remove-repo <repo>    - Remove repository"
            echo
            if [[ "$OS_TYPE" == "ubuntu" ]]; then
                echo "Snap:"
                echo "  snap-install <pkg>    - Install snap package"
                echo "  snap-list             - List snap packages"
            fi
            ;;
        macos)
            echo "Homebrew:"
            echo "  brew-install <pkg>    - Install package"
            echo "  brew-search <term>    - Search packages"
            echo "  brew-update           - Update packages"
            echo "  brew-cask <app>       - Install GUI app"
            echo "  brew-clean            - Clean cache"
            echo "  brew-doctor           - Check system"
            echo
            echo "System:"
            echo "  show-hidden           - Show hidden files"
            echo "  hide-hidden           - Hide hidden files"
            echo "  flush-dns             - Clear DNS cache"
            echo "  sleep-display         - Sleep display"
            echo "  lock-screen           - Lock screen"
            ;;
        fedora|rhel)
            echo "Package Management:"
            echo "  dnf-install <pkg>     - Install package"
            echo "  dnf-search <term>     - Search packages"
            echo "  dnf-update            - Update system"
            echo "  dnf-remove <pkg>      - Remove package"
            echo "  dnf-clean             - Clean cache"
            echo "  dnf-history           - Show transaction history"
            ;;
        opensuse)
            echo "Package Management:"
            echo "  zyp-install <pkg>     - Install package"
            echo "  zyp-search <term>     - Search packages"
            echo "  zyp-update            - Update system"
            echo "  zyp-remove <pkg>      - Remove package"
            echo "  zyp-clean             - Clean cache"
            ;;
    esac

    echo
    echo "Universal Commands:"
    echo "  pkg install <pkg>     - Install package (any distro)"
    echo "  pkg search <term>     - Search packages (any distro)"
    echo "  pkg update            - Update system (any distro)"
    echo "  pkg remove <pkg>      - Remove package (any distro)"
    echo "  pkg clean             - Clean cache (any distro)"
    echo "  sysinfo               - Show system information"
}

# ============================================================================
# Load Distribution-Specific Configuration
# ============================================================================

# Load distro-specific file if it exists
if [[ -f ~/.config/zsh/distro/${OS_TYPE}.zsh ]]; then
    source ~/.config/zsh/distro/${OS_TYPE}.zsh
fi

# Export OS_TYPE for use in other scripts
export OS_TYPE

# Show distribution info on first load (optional)
# Uncomment the next line to show distro info when starting a new shell
# echo "Detected OS: $OS_TYPE | Type 'distro_help' for distribution-specific commands"
