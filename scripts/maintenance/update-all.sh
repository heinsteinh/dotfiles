#!/usr/bin/env bash
# Update all tools and packages script

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../setup/setup-common.sh
source "$SCRIPT_DIR/../setup/setup-common.sh"

update_system_packages() {
    local os
    os=$(detect_os)

    log_info "Updating system packages for $os..."

    case "$os" in
        macos)
            if command_exists brew; then
                log_info "Updating Homebrew packages..."
                brew update && brew upgrade
                brew cleanup
            fi

            if command_exists mas; then
                log_info "Updating App Store applications..."
                mas upgrade
            fi
            ;;
        ubuntu|debian)
            log_info "Updating APT packages..."
            sudo apt update && sudo apt upgrade -y
            sudo apt autoremove -y && sudo apt autoclean
            ;;
        fedora)
            log_info "Updating DNF packages..."
            sudo dnf update -y
            sudo dnf autoremove -y
            ;;
        arch)
            log_info "Updating Pacman packages..."
            sudo pacman -Syu --noconfirm

            if command_exists yay; then
                log_info "Updating AUR packages..."
                yay -Syu --noconfirm
            fi
            ;;
        *)
            log_warning "Unknown OS, skipping system package updates"
            ;;
    esac
}

update_development_tools() {
    log_info "Updating development tools..."

    # Update Node.js packages
    if command_exists npm; then
        log_info "Updating global npm packages..."
        npm update -g
    fi

    if command_exists yarn; then
        log_info "Updating global yarn packages..."
        yarn global upgrade
    fi

    # Update Python packages
    if command_exists pip3; then
        log_info "Updating pip packages..."
        pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U || true
    fi

    # Update Rust toolchain
    if command_exists rustup; then
        log_info "Updating Rust toolchain..."
        rustup update
    fi

    # Update Go tools
    if command_exists go; then
        log_info "Updating Go tools..."
        go list -m -u all | grep -v "^go: " || true
    fi

    # Update Ruby gems
    if command_exists gem; then
        log_info "Updating Ruby gems..."
        gem update --system && gem update || true
    fi
}

update_shell_tools() {
    log_info "Updating shell tools and configurations..."

    # Update Oh My Zsh
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Updating Oh My Zsh..."
        (cd "$HOME/.oh-my-zsh" && git pull)
    fi

    # Update Zsh plugins
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [[ -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
        log_info "Updating zsh-autosuggestions..."
        (cd "$zsh_custom/plugins/zsh-autosuggestions" && git pull)
    fi

    if [[ -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]]; then
        log_info "Updating zsh-syntax-highlighting..."
        (cd "$zsh_custom/plugins/zsh-syntax-highlighting" && git pull)
    fi

    if [[ -d "$zsh_custom/themes/powerlevel10k" ]]; then
        log_info "Updating powerlevel10k theme..."
        (cd "$zsh_custom/themes/powerlevel10k" && git pull)
    fi

    # Update Tmux Plugin Manager plugins
    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_info "Updating Tmux plugins..."
        "$HOME/.tmux/plugins/tpm/bin/update_plugins" all
    fi

    # Update Vim plugins
    if [[ -f "$HOME/.vim/autoload/plug.vim" ]]; then
        log_info "Updating Vim plugins..."
        vim +PlugUpdate +qall || true
    fi

    # Update Neovim plugins (if using vim-plug)
    if command_exists nvim && [[ -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]; then
        log_info "Updating Neovim plugins..."
        nvim +PlugUpdate +qall || true
    fi
}

update_containers() {
    log_info "Updating container images..."

    if command_exists docker; then
        log_info "Updating Docker images..."
        docker image prune -f

        # Update commonly used images
        local images=(
            "alpine:latest"
            "ubuntu:latest"
            "node:lts"
            "python:3"
            "nginx:latest"
            "redis:latest"
        )

        for image in "${images[@]}"; do
            if docker images -q "$image" &>/dev/null; then
                log_info "Updating $image..."
                docker pull "$image" || true
            fi
        done
    fi
}

update_fonts() {
    log_info "Checking for font updates..."

    # This would typically involve re-running the font installation script
    local font_script="$SCRIPT_DIR/../install/install-fonts.sh"
    if [[ -x "$font_script" ]]; then
        log_info "Running font update script..."
        "$font_script" --update || true
    fi
}

cleanup_system() {
    log_info "Cleaning up system..."

    local os
    os=$(detect_os)

    case "$os" in
        macos)
            # Clean Homebrew caches
            if command_exists brew; then
                brew cleanup
                brew doctor || true
            fi

            # Clean user caches
            rm -rf "$HOME/Library/Caches/Homebrew"
            ;;
        ubuntu|debian)
            sudo apt autoremove -y
            sudo apt autoclean
            ;;
        fedora)
            sudo dnf autoremove -y
            sudo dnf clean all
            ;;
        arch)
            sudo pacman -Sc --noconfirm
            if command_exists yay; then
                yay -Sc --noconfirm
            fi
            ;;
    esac

    # Clean common development caches
    if [[ -d "$HOME/.npm/_cacache" ]]; then
        log_info "Cleaning npm cache..."
        npm cache clean --force
    fi

    if [[ -d "$HOME/.yarn/cache" ]]; then
        log_info "Cleaning yarn cache..."
        yarn cache clean
    fi

    if [[ -d "$HOME/.cargo/registry" ]]; then
        log_info "Cleaning Cargo cache..."
        cargo clean 2>/dev/null || true
    fi

    # Clean Docker system
    if command_exists docker; then
        log_info "Cleaning Docker system..."
        docker system prune -f || true
    fi
}

generate_update_report() {
    local report_file="$HOME/.cache/dotfiles-update-$(date +%Y%m%d_%H%M%S).log"

    log_info "Generating update report..."

    {
        echo "Dotfiles Update Report"
        echo "====================="
        echo "Date: $(date)"
        echo "User: $(whoami)"
        echo "Host: $(hostname)"
        echo "OS: $(detect_os)"
        echo ""

        echo "System Information:"
        echo "  Uptime: $(uptime)"
        if command_exists free; then
            echo "  Memory: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
        fi
        if command_exists df; then
            echo "  Disk: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 " used)"}')"
        fi
        echo ""

        echo "Tool Versions After Update:"
        for tool in git node npm yarn python3 go rustc docker; do
            if command_exists "$tool"; then
                case "$tool" in
                    git) echo "  Git: $(git --version)" ;;
                    node) echo "  Node.js: $(node --version)" ;;
                    npm) echo "  npm: $(npm --version)" ;;
                    yarn) echo "  Yarn: $(yarn --version)" ;;
                    python3) echo "  Python: $(python3 --version)" ;;
                    go) echo "  Go: $(go version | cut -d' ' -f3)" ;;
                    rustc) echo "  Rust: $(rustc --version | cut -d' ' -f2)" ;;
                    docker) echo "  Docker: $(docker --version)" ;;
                esac
            fi
        done
    } > "$report_file"

    log_success "Update report saved to: $report_file"
}

main() {
    log_info "Starting comprehensive system update..."

    local start_time
    start_time=$(date +%s)

    # Create cache directory if it doesn't exist
    mkdir -p "$HOME/.cache"

    # Run updates
    if confirm "Update system packages?"; then
        update_system_packages
    fi

    if confirm "Update development tools?"; then
        update_development_tools
    fi

    if confirm "Update shell tools and configurations?"; then
        update_shell_tools
    fi

    if confirm "Update container images?"; then
        update_containers
    fi

    if confirm "Check for font updates?"; then
        update_fonts
    fi

    if confirm "Clean up system caches?"; then
        cleanup_system
    fi

    # Generate report
    generate_update_report

    local end_time duration
    end_time=$(date +%s)
    duration=$((end_time - start_time))

    log_success "System update completed in ${duration} seconds!"

    log_info "Recommendations:"
    log_info "  - Restart your terminal to ensure all changes take effect"
    log_info "  - Run 'source ~/.zshrc' to reload shell configuration"
    log_info "  - Consider rebooting if system packages were updated"

    if [[ -f "$HOME/.cache/dotfiles-update-"*.log ]]; then
        log_info "  - Check the update report in ~/.cache/ for details"
    fi
}

main "$@"
