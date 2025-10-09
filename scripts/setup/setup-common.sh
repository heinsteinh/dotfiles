#!/usr/bin/env bash
# Common setup functions shared across different OS setups

set -euo pipefail

# Colors for output (only define if not already defined)
if [[ -z "${RED:-}" ]]; then
    # Disable colors in CI mode for better output
    if [[ "${CI:-}" == "true" ]] || [[ "${DOTFILES_CI_MODE:-}" == "true" ]] || [[ "${DOTFILES_SKIP_INTERACTIVE:-}" == "true" ]]; then
        readonly RED=''
        readonly GREEN=''
        readonly YELLOW=''
        readonly BLUE=''
        readonly NC=''
    else
        readonly RED='\033[0;31m'
        readonly GREEN='\033[0;32m'
        readonly YELLOW='\033[1;33m'
        readonly BLUE='\033[0;34m'
        readonly NC='\033[0m' # No Color
    fi
fi

# Logging functions (only define if not already defined)
if ! declare -f log_info > /dev/null 2>&1; then
    log_info() {
        echo -e "${BLUE}[INFO]${NC} $1"
    }
fi

if ! declare -f log_success > /dev/null 2>&1; then
    log_success() {
        echo -e "${GREEN}[SUCCESS]${NC} $1"
    }
fi

if ! declare -f log_warning > /dev/null 2>&1; then
    log_warning() {
        echo -e "${YELLOW}[WARNING]${NC} $1"
    }
fi

if ! declare -f log_error > /dev/null 2>&1; then
    log_error() {
        echo -e "${RED}[ERROR]${NC} $1"
    }
fi

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if [[ -f /etc/os-release ]]; then
                . /etc/os-release
                echo "$ID"
            elif command_exists lsb_release; then
                lsb_release -si | tr '[:upper:]' '[:lower:]'
            else
                echo "unknown"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# Create backup of existing file
backup_file() {
    local file="$1"
    if [[ -f "$file" ]] || [[ -L "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up $file to $backup"
        cp "$file" "$backup" || mv "$file" "$backup"
    fi
}

# Create directory if it doesn't exist
ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        log_info "Creating directory: $dir"
        mkdir -p "$dir"
    fi
}

# Download file with progress
download_file() {
    local url="$1"
    local output="$2"

    if command_exists curl; then
        curl -fsSL -o "$output" "$url"
    elif command_exists wget; then
        wget -q -O "$output" "$url"
    else
        log_error "Neither curl nor wget is available"
        return 1
    fi
}

# Install package using appropriate package manager
install_package() {
    local package="$1"
    local os
    os=$(detect_os)

    case "$os" in
        macos)
            if command_exists brew; then
                brew install "$package"
            else
                log_error "Homebrew not found. Please install it first."
                return 1
            fi
            ;;
        ubuntu|debian)
            sudo apt update && sudo apt install -y "$package"
            ;;
        fedora)
            sudo dnf install -y "$package"
            ;;
        arch)
            sudo pacman -S --noconfirm "$package"
            ;;
        *)
            log_error "Unsupported operating system: $os"
            return 1
            ;;
    esac
}

# Check if file is writable
is_writable() {
    local file="$1"
    [[ -w "$file" ]] || [[ -w "$(dirname "$file")" ]]
}

# Get user confirmation
confirm() {
    local message="$1"
    local response

    while true; do
        read -p "$message (y/n): " response
        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                echo "Please answer yes or no."
                ;;
        esac
    done
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed successfully"
    else
        log_info "Oh My Zsh is already installed"
    fi
}

# Install Zsh plugins
install_zsh_plugins() {
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
        log_info "Installing zsh-fast-syntax-highlighting plugin..."
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$zsh_custom/plugins/fast-syntax-highlighting"
    fi

    # zsh-autocomplete
    if [[ ! -d "$zsh_custom/plugins/zsh-autocomplete" ]]; then
        log_info "Installing zsh-autocomplete plugin..."
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$zsh_custom/plugins/zsh-autocomplete"
    fi

    # powerlevel10k theme
    if [[ ! -d "$zsh_custom/themes/powerlevel10k" ]]; then
        log_info "Installing powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$zsh_custom/themes/powerlevel10k"
    fi
}

# Set Zsh as default shell
set_zsh_default() {
    # Skip changing shell in CI environment
    if [[ "${CI:-}" == "true" ]] || [[ "${DOTFILES_CI_MODE:-}" == "true" ]]; then
        log_info "CI environment detected, skipping shell change"
        return 0
    fi

    if [[ "$SHELL" != */zsh ]]; then
        if command_exists zsh; then
            log_info "Setting zsh as default shell..."
            chsh -s "$(which zsh)"
            log_warning "Please log out and back in for shell change to take effect"
        else
            log_error "Zsh is not installed"
            return 1
        fi
    else
        log_info "Zsh is already the default shell"
    fi
}

# Install Starship prompt
install_starship() {
    if ! command_exists starship; then
        log_info "Installing Starship prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        log_success "Starship installed successfully"
    else
        log_info "Starship is already installed"
    fi
}

# Cleanup function
cleanup_temp_files() {
    local temp_dir="${TMPDIR:-/tmp}"
    log_info "Cleaning up temporary files..."
    find "$temp_dir" -name "dotfiles-*" -type f -mtime +7 -delete 2>/dev/null || true
}

# Install modern CLI tools cross-platform
install_modern_cli_tools() {
    local os
    os=$(detect_os)

    log_info "Installing modern CLI tools for $os..."

    case "$os" in
        macos)
            if ! command_exists brew; then
                log_error "Homebrew not found. Please install it first."
                return 1
            fi

            brew install \
                ripgrep fd bat eza fzf jq yq \
                lazygit bottom procs dust tokei \
                hyperfine bandwhich gping tree htop || log_warning "Some packages failed to install"
            ;;
        ubuntu|debian)
            sudo apt install -y -qq \
                ripgrep fd-find fzf jq tree htop unzip || log_warning "Some packages from default repositories failed to install"

            # Install bat (Ubuntu 20.04+)
            sudo apt install -y -qq bat 2>/dev/null || sudo apt install -y -qq batcat || log_warning "Failed to install bat/batcat"

            # Create symlinks for Ubuntu-specific naming
            command_exists fdfind && ! command_exists fd && sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
            command_exists batcat && ! command_exists bat && sudo ln -sf "$(which batcat)" /usr/local/bin/bat

            # Install eza from GitHub (if not in CI)
            if [[ "${CI:-}" != "true" ]] && ! command_exists eza; then
                log_info "Installing eza from GitHub releases..."
                install_eza_github || log_warning "Failed to install eza"
            fi
            ;;
        fedora)
            sudo dnf install -y \
                ripgrep fd-find fzf jq tree htop unzip bat || log_warning "Some packages failed to install"
            ;;
        arch)
            sudo pacman -S --noconfirm \
                ripgrep fd bat eza fzf jq tree htop unzip || log_warning "Some packages failed to install"
            ;;
        *)
            log_error "Unsupported operating system: $os"
            return 1
            ;;
    esac

    log_success "Modern CLI tools installed"
}

# Install eza from GitHub releases (Ubuntu/Debian)
install_eza_github() {
    local architecture
    case "$(uname -m)" in
        x86_64) architecture="x86_64" ;;
        aarch64|arm64) architecture="aarch64" ;;
        *)
            log_warning "Unsupported architecture for eza: $(uname -m)"
            return 1
            ;;
    esac

    local eza_version
    eza_version=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep -o '"tag_name": "v[^"]*' | cut -d'"' -f4 | cut -d'v' -f2) || {
        log_warning "Failed to get eza version from GitHub"
        return 1
    }

    local temp_dir=$(mktemp -d)
    cd "$temp_dir" || return 1

    local download_url="https://github.com/eza-community/eza/releases/download/v${eza_version}/eza_${architecture}-unknown-linux-gnu.tar.gz"

    if curl -L "$download_url" -o eza.tar.gz && tar -xzf eza.tar.gz; then
        sudo mv eza /usr/local/bin/eza
        sudo chmod +x /usr/local/bin/eza
        cd - > /dev/null
        rm -rf "$temp_dir"
        log_success "eza installed successfully"
        return 0
    else
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
}

# Install Docker cross-platform
install_docker() {
    local os
    os=$(detect_os)

    # Skip in CI
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected, skipping Docker installation"
        return 0
    fi

    if command_exists docker; then
        log_info "Docker is already installed"
        return 0
    fi

    log_info "Installing Docker for $os..."

    case "$os" in
        macos)
            if command_exists brew; then
                brew install --cask docker
            else
                log_error "Homebrew not found"
                return 1
            fi
            ;;
        ubuntu|debian)
            # Add Docker's official GPG key
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

            # Set up the stable repository
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

            # Install Docker Engine
            sudo apt update
            sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

            # Add user to docker group
            sudo usermod -aG docker "$USER"
            log_warning "Please log out and back in for Docker group changes to take effect"
            ;;
        fedora)
            sudo dnf install -y docker docker-compose
            sudo systemctl enable --now docker
            sudo usermod -aG docker "$USER"
            log_warning "Please log out and back in for Docker group changes to take effect"
            ;;
        arch)
            sudo pacman -S --noconfirm docker docker-compose
            sudo systemctl enable --now docker
            sudo usermod -aG docker "$USER"
            log_warning "Please log out and back in for Docker group changes to take effect"
            ;;
        *)
            log_error "Unsupported operating system: $os"
            return 1
            ;;
    esac

    log_success "Docker installed successfully"
}

# Install Node.js cross-platform
install_nodejs() {
    local os
    os=$(detect_os)

    # Skip in CI
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected, skipping Node.js installation"
        return 0
    fi

    if command_exists node; then
        log_info "Node.js is already installed"
        return 0
    fi

    log_info "Installing Node.js for $os..."

    case "$os" in
        macos)
            brew install node
            ;;
        ubuntu|debian)
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt install -y nodejs
            ;;
        fedora)
            sudo dnf install -y nodejs npm
            ;;
        arch)
            sudo pacman -S --noconfirm nodejs npm
            ;;
        *)
            log_error "Unsupported operating system: $os"
            return 1
            ;;
    esac

    log_success "Node.js installed successfully"
}

# Main common setup function
common_setup() {
    log_info "Running common setup tasks..."

    check_root
    install_oh_my_zsh
    install_zsh_plugins
    install_starship
    set_zsh_default

    log_success "Common setup completed"
}
