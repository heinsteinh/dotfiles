# ~/.config/zsh/distro.zsh - Distribution-Specific Aliases and Functions

# ============================================================================
# Auto-Detection and Configuration Loading
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
# Arch Linux Specific
# ============================================================================
if [[ "$OS_TYPE" == "arch" ]]; then
    # Package management
    alias pac-install='sudo pacman -S'
    alias pac-search='pacman -Ss'
    alias pac-update='sudo pacman -Syu'
    alias pac-remove='sudo pacman -R'
    alias pac-remove-deps='sudo pacman -Rs'
    alias pac-info='pacman -Si'
    alias pac-installed='pacman -Q'
    alias pac-files='pacman -Ql'
    alias pac-owner='pacman -Qo'
    alias pac-orphans='sudo pacman -Rs $(pacman -Qtdq)'
    alias pac-clean='sudo pacman -Sc'
    alias pac-clean-all='sudo pacman -Scc'
    
    # AUR helpers
    if command -v yay &> /dev/null; then
        alias yay-install='yay -S'
        alias yay-search='yay -Ss'
        alias yay-update='yay -Syu'
        alias yay-clean='yay -Sc'
        alias yay-stats='yay -Ps'
    fi
    
    if command -v paru &> /dev/null; then
        alias paru-install='paru -S'
        alias paru-search='paru -Ss'
        alias paru-update='paru -Syu'
        alias paru-clean='paru -Sc'
    fi
    
    # System management
    alias update-system='sudo pacman -Syu'
    alias update-mirrors='sudo reflector --verbose --latest 20 --country US --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
    alias kernel-list='pacman -Q | grep linux'
    alias driver-check='lspci -v | grep -A1 -e VGA -e 3D'
    
    # Arch-specific functions
    pac_search_install() {
        local package
        package=$(pacman -Ss "$1" | grep -E '^[^[:space:]]' | fzf --preview 'pacman -Si {1}' | awk '{print $1}')
        [[ -n $package ]] && sudo pacman -S "$package"
    }
    
    # Check for .pacnew files
    alias pacnew='find /etc -name "*.pacnew" 2>/dev/null'
    
    # Service management
    alias enable-service='sudo systemctl enable'
    alias start-service='sudo systemctl start'
    alias restart-service='sudo systemctl restart'
    alias status-service='systemctl status'
    alias failed-services='systemctl --failed'

# ============================================================================
# Ubuntu/Debian Specific
# ============================================================================
elif [[ "$OS_TYPE" == "ubuntu" ]] || [[ "$OS_TYPE" == "debian" ]]; then
    # Package management
    alias apt-install='sudo apt install'
    alias apt-search='apt search'
    alias apt-update='sudo apt update'
    alias apt-upgrade='sudo apt update && sudo apt upgrade'
    alias apt-remove='sudo apt remove'
    alias apt-purge='sudo apt purge'
    alias apt-autoremove='sudo apt autoremove'
    alias apt-info='apt show'
    alias apt-installed='apt list --installed'
    alias apt-files='dpkg -L'
    alias apt-owner='dpkg -S'
    alias apt-clean='sudo apt autoclean && sudo apt autoremove'
    
    # Repository management
    alias add-repo='sudo add-apt-repository'
    alias remove-repo='sudo add-apt-repository --remove'
    alias update-sources='sudo apt update'
    
    # System management
    alias update-system='sudo apt update && sudo apt upgrade'
    alias dist-upgrade='sudo apt update && sudo apt dist-upgrade'
    alias check-updates='apt list --upgradable'
    
    # Ubuntu-specific
    if [[ "$OS_TYPE" == "ubuntu" ]]; then
        alias ubuntu-version='lsb_release -a'
        alias ubuntu-codename='lsb_release -c'
        alias snap-list='snap list'
        alias snap-install='sudo snap install'
        alias snap-remove='sudo snap remove'
        alias snap-update='sudo snap refresh'
    fi
    
    # Debian-specific functions
    apt_search_install() {
        local package
        package=$(apt search "$1" 2>/dev/null | grep -E '^[^[:space:]]' | fzf --preview 'apt show {1}' | awk -F'/' '{print $1}')
        [[ -n $package ]] && sudo apt install "$package"
    }
    
    # Service management
    alias enable-service='sudo systemctl enable'
    alias start-service='sudo systemctl start'
    alias restart-service='sudo systemctl restart'
    alias status-service='systemctl status'

# ============================================================================
# macOS Specific
# ============================================================================
elif [[ "$OS_TYPE" == "macos" ]]; then
    # Homebrew management
    alias brew-install='brew install'
    alias brew-search='brew search'
    alias brew-update='brew update && brew upgrade'
    alias brew-remove='brew uninstall'
    alias brew-info='brew info'
    alias brew-list='brew list'
    alias brew-clean='brew cleanup'
    alias brew-doctor='brew doctor'
    alias brew-cask='brew install --cask'
    alias brew-services='brew services list'
    alias brew-outdated='brew outdated'
    
    # macOS system management
    alias update-system='softwareupdate -i -a'
    alias check-updates='softwareupdate -l'
    alias macos-version='sw_vers'
    
    # macOS specific utilities
    alias show-hidden='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
    alias hide-hidden='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
    alias flush-dns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
    alias rebuild-launch='sudo /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user && killall Finder'
    
    # Quick system controls
    alias sleep-display='pmset displaysleepnow'
    alias prevent-sleep='caffeinate'
    alias lock-screen='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
    
    # Network utilities
    alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
    alias wifi-scan='airport -s'
    alias wifi-info='airport -I'
    
    # Homebrew functions
    brew_search_install() {
        local package
        package=$(brew search "$1" | fzf --preview 'brew info {}')
        [[ -n $package ]] && brew install "$package"
    }
    
    # Application management
    alias app-store='mas list'
    alias app-install='mas install'
    alias app-search='mas search'
    
    # Clipboard utilities
    alias copy='pbcopy'
    alias paste='pbpaste'

# ============================================================================
# Fedora/RHEL Specific
# ============================================================================
elif [[ "$OS_TYPE" == "fedora" ]] || [[ "$OS_TYPE" == "rhel" ]]; then
    # DNF package management
    alias dnf-install='sudo dnf install'
    alias dnf-search='dnf search'
    alias dnf-update='sudo dnf update'
    alias dnf-remove='sudo dnf remove'
    alias dnf-info='dnf info'
    alias dnf-installed='dnf list installed'
    alias dnf-clean='sudo dnf clean all'
    alias dnf-history='dnf history'
    
    # Repository management
    alias add-repo='sudo dnf config-manager --add-repo'
    alias enable-repo='sudo dnf config-manager --enable'
    alias disable-repo='sudo dnf config-manager --disable'
    
    # System management
    alias update-system='sudo dnf update'
    alias check-updates='dnf check-update'
    
    # Fedora-specific
    if [[ "$OS_TYPE" == "fedora" ]]; then
        alias fedora-version='cat /etc/fedora-release'
        alias flatpak-install='flatpak install'
        alias flatpak-update='flatpak update'
        alias flatpak-list='flatpak list'
    fi
    
    # Service management
    alias enable-service='sudo systemctl enable'
    alias start-service='sudo systemctl start'
    alias restart-service='sudo systemctl restart'
    alias status-service='systemctl status'

# ============================================================================
# openSUSE Specific
# ============================================================================
elif [[ "$OS_TYPE" == "opensuse" ]]; then
    # Zypper package management
    alias zyp-install='sudo zypper install'
    alias zyp-search='zypper search'
    alias zyp-update='sudo zypper update'
    alias zyp-remove='sudo zypper remove'
    alias zyp-info='zypper info'
    alias zyp-installed='zypper search --installed-only'
    alias zyp-clean='sudo zypper clean'
    
    # Repository management
    alias add-repo='sudo zypper addrepo'
    alias remove-repo='sudo zypper removerepo'
    alias refresh-repos='sudo zypper refresh'
    
    # System management
    alias update-system='sudo zypper update'
    alias dist-upgrade='sudo zypper dup'
    
    # Service management
    alias enable-service='sudo systemctl enable'
    alias start-service='sudo systemctl start'
    alias restart-service='sudo systemctl restart'
    alias status-service='systemctl status'
fi

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
# Package Manager Detection and Universal Commands
# ============================================================================

# Universal package management functions
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

# System information function
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

# Show distribution-specific commands
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
# Auto-load distribution-specific configurations
# ============================================================================

# Load additional distribution-specific files if they exist
[[ -f ~/.config/zsh/distro/${OS_TYPE}.zsh ]] && source ~/.config/zsh/distro/${OS_TYPE}.zsh

# Export OS_TYPE for use in other scripts
export OS_TYPE

# Show distribution info on first load (optional)
# Uncomment the next line to show distro info when starting a new shell
# echo "Detected OS: $OS_TYPE | Type 'distro_help' for distribution-specific commands"