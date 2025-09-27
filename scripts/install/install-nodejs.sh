#!/usr/bin/env bash
# Node.js installation script

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../setup/setup-common.sh
source "$SCRIPT_DIR/../setup/setup-common.sh"

# Node.js LTS version to install (if not using version manager)
readonly NODE_VERSION="lts"

install_nodejs() {
    local os
    os=$(detect_os)
    
    log_info "Installing Node.js for $os..."
    
    if confirm "Do you want to install Node.js via Node Version Manager (recommended)?"; then
        install_with_nvm
    else
        install_directly "$os"
    fi
}

install_with_nvm() {
    log_info "Installing Node.js via NVM (Node Version Manager)..."
    
    # Install NVM
    if [[ ! -d "$HOME/.nvm" ]]; then
        log_info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        
        # Source NVM
        export NVM_DIR="$HOME/.nvm"
        [[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
        [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"
    fi
    
    # Install latest LTS Node.js
    log_info "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    
    # Install global packages
    install_global_packages
    
    log_success "Node.js installed via NVM"
}

install_directly() {
    local os="$1"
    
    case "$os" in
        macos)
            if command_exists brew; then
                brew install node npm
            else
                log_error "Homebrew not found. Please install it first or use the direct installer."
            fi
            ;;
        ubuntu|debian)
            # Use NodeSource repository for latest version
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
            log_error "Unsupported OS for direct installation: $os"
            exit 1
            ;;
    esac
    
    install_global_packages
}

install_global_packages() {
    log_info "Installing useful global npm packages..."
    
    local packages=(
        yarn                    # Fast package manager
        typescript              # TypeScript compiler
        ts-node                # TypeScript execution
        eslint                 # JavaScript linter
        prettier               # Code formatter
        nodemon                # Development server
        pm2                    # Process manager
        live-server            # Development server
        http-server            # Simple HTTP server
        json-server            # Mock REST API
        create-react-app       # React application generator
        vue-cli                # Vue.js CLI
        @angular/cli           # Angular CLI
        express-generator      # Express app generator
        serverless             # Serverless framework
        vercel                 # Deployment platform
        netlify-cli            # Netlify CLI
    )
    
    for package in "${packages[@]}"; do
        if ! npm list -g "$package" &>/dev/null; then
            log_info "Installing $package..."
            npm install -g "$package" || log_warning "Failed to install $package"
        fi
    done
}

configure_npm() {
    log_info "Configuring npm..."
    
    # Set npm configuration
    npm config set init-author-name "$(git config user.name 2>/dev/null || echo 'Your Name')"
    npm config set init-author-email "$(git config user.email 2>/dev/null || echo 'your.email@example.com')"
    npm config set init-license "MIT"
    npm config set save-exact true
    
    # Set registry (use official by default)
    npm config set registry https://registry.npmjs.org/
    
    log_success "npm configured successfully"
}

setup_node_aliases() {
    log_info "Setting up Node.js aliases..."
    
    # Create Node.js aliases file
    cat << 'EOF' > "$HOME/.node_aliases"
# Node.js and npm aliases
alias n='node'
alias ni='npm install'
alias nig='npm install -g'
alias nis='npm install --save'
alias nid='npm install --save-dev'
alias nu='npm update'
alias nug='npm update -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nd='npm run dev'
alias nls='npm ls'
alias nlsg='npm ls -g --depth=0'
alias ncc='npm cache clean --force'
alias nrm='rm -rf node_modules package-lock.json && npm install'

# Yarn aliases (if installed)
alias y='yarn'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn remove'
alias yu='yarn upgrade'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias yln='yarn lint'
alias yf='yarn format'

# Package.json shortcuts
alias pj='cat package.json'
alias pje='$EDITOR package.json'

# Node version management (if using nvm)
if command -v nvm &> /dev/null; then
    alias nv='nvm'
    alias nvls='nvm ls'
    alias nvlsr='nvm ls-remote'
    alias nvu='nvm use'
    alias nvi='nvm install'
    alias nvd='nvm use default'
fi

# Useful functions
npmglobal() {
    npm list -g --depth=0
}

npmoutdated() {
    npm outdated
}

npmsearch() {
    npm search "$1"
}

nodeinfo() {
    echo "Node.js version: $(node --version)"
    echo "npm version: $(npm --version)"
    if command -v yarn &> /dev/null; then
        echo "Yarn version: $(yarn --version)"
    fi
    echo "Global packages location: $(npm root -g)"
}
EOF

    log_success "Node.js aliases created in ~/.node_aliases"
}

verify_installation() {
    log_info "Verifying Node.js installation..."
    
    if command_exists node && command_exists npm; then
        echo "  Node.js version: $(node --version)"
        echo "  npm version: $(npm --version)"
        
        if command_exists yarn; then
            echo "  Yarn version: $(yarn --version)"
        fi
        
        log_success "Node.js installation verified successfully"
        
        # Show global packages
        log_info "Installed global packages:"
        npm list -g --depth=0 --silent 2>/dev/null | tail -n +2 | head -10
        
    else
        log_error "Node.js installation verification failed"
        return 1
    fi
}

main() {
    log_info "Starting Node.js installation..."
    
    if command_exists node; then
        log_info "Node.js is already installed: $(node --version)"
        if ! confirm "Do you want to reinstall or update Node.js?"; then
            log_info "Skipping Node.js installation"
            exit 0
        fi
    fi
    
    install_nodejs
    configure_npm
    setup_node_aliases
    verify_installation
    
    log_success "Node.js installation and setup completed!"
    log_info "Please restart your terminal or run 'source ~/.zshrc' to use the new aliases"
    
    if [[ -d "$HOME/.nvm" ]]; then
        log_info "NVM commands:"
        log_info "  nvm ls                 # List installed versions"
        log_info "  nvm install <version>  # Install specific version"
        log_info "  nvm use <version>      # Use specific version"
        log_info "  nvm alias default lts  # Set default to LTS"
    fi
}

main "$@"