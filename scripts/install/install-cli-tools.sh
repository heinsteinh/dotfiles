#!/bin/bash
# Install additional CLI tools for software development

set -euo pipefail

echo "Installing additional CLI tools for software development..."

# Detect package manager and install platform-specific tools
if command -v pacman &> /dev/null; then
    # Arch Linux
    echo "Installing tools for Arch Linux..."
    
    # Core development tools
    sudo pacman -S --needed --noconfirm \
        ranger \
        httpie \
        nmap \
        tldr \
        ncdu \
        tree \
        unzip \
        zip \
        curl \
        wget \
        rsync \
        git-delta \
        starship \
        zoxide \
        mcfly

    # Network and system tools
    sudo pacman -S --needed --noconfirm \
        nload \
        iotop \
        nethogs \
        duf \
        broot \
        choose \
        sd \
        tealdeer

    # Development and debugging tools  
    sudo pacman -S --needed --noconfirm \
        strace \
        ltrace \
        lsof \
        socat \
        netcat \
        tcpdump \
        wireshark-cli

    # Text processing and data tools
    sudo pacman -S --needed --noconfirm \
        miller \
        pandoc \
        shellcheck \
        yamllint \
        hadolint-bin

    # AUR packages (if yay is available)
    if command -v yay &> /dev/null; then
        yay -S --noconfirm \
            thefuck \
            neofetch \
            doggo \
            glow \
            fzf-git-sh \
            git-cliff \
            just \
            silicon \
            zellij \
            helix \
            gitui \
            onefetch \
            tokei \
            watchexec \
            direnv \
            entr \
            viddy \
            xh \
            gh \
            glab
    fi

elif command -v brew &> /dev/null; then
    # macOS  
    echo "Installing tools for macOS..."
    
    # Core development tools (avoiding duplicates from main setup)
    brew install \
        ranger \
        httpie \
        nmap \
        tldr \
        ncdu \
        tree \
        rsync \
        git-delta \
        starship \
        zoxide \
        mcfly

    # Network and system monitoring
    brew install \
        nload \
        iotop-c \
        nethogs \
        duf \
        broot \
        choose \
        sd \
        tealdeer

    # Development and debugging tools
    brew install \
        strace \
        lsof \
        socat \
        netcat \
        tcpdump \
        wireshark

    # Text processing and data tools  
    brew install \
        miller \
        pandoc \
        shellcheck \
        yamllint \
        hadolint

    # Modern development tools
    brew install \
        thefuck \
        neofetch \
        dog \
        glow \
        just \
        silicon \
        zellij \
        helix \
        gitui \
        onefetch \
        watchexec \
        direnv \
        entr \
        viddy \
        xh \
        gh \
        glab

    # Install additional casks for development
    brew install --cask \
        stats \
        tunnelblick \
        wireshark

elif command -v apt &> /dev/null; then
    # Debian/Ubuntu
    echo "Installing tools for Debian/Ubuntu..."
    sudo apt update
    
    # Core development tools
    sudo apt install -y \
        ranger \
        httpie \
        nmap \
        tldr \
        ncdu \
        tree \
        unzip \
        zip \
        curl \
        wget \
        rsync

    # Network and system tools
    sudo apt install -y \
        nload \
        iotop \
        nethogs \
        duf \
        socat \
        netcat \
        tcpdump \
        tshark

    # Development and debugging tools
    sudo apt install -y \
        strace \
        ltrace \
        lsof \
        gdb \
        valgrind

    # Text processing tools
    sudo apt install -y \
        pandoc \
        shellcheck \
        yamllint \
        miller

    # Install modern tools from GitHub releases or snap
    if command -v snap &> /dev/null; then
        sudo snap install \
            starship \
            yq \
            jq \
            glow \
            gh
    fi

    # Install additional tools via apt if available
    sudo apt install -y \
        neofetch \
        thefuck \
        direnv \
        entr \
        watchexec
        
    # Note: Some modern tools might need manual installation on older Ubuntu versions
    echo "Note: Some modern CLI tools may require manual installation on this system."
fi

# Install Node.js global packages (if Node.js is available)
if command -v npm &> /dev/null; then
    echo "Installing Node.js development tools..."
    npm install -g \
        http-server \
        json-server \
        live-server \
        nodemon \
        @angular/cli \
        create-react-app \
        vue-cli \
        typescript \
        ts-node \
        eslint \
        prettier \
        webpack-cli \
        vite \
        serve \
        npm-check-updates \
        tldr \
        fkill-cli \
        gtop \
        speed-test \
        public-ip-cli \
        is-up-cli \
        fast-cli
else
    echo "Node.js not found, skipping npm packages"
fi

# Install Python packages (user-level to avoid system package conflicts)
if command -v pip3 &> /dev/null; then
    echo "Installing Python development tools..."
    pip3 install --user \
        httpie \
        yt-dlp \
        speedtest-cli \
        howdoi \
        pipenv \
        poetry \
        black \
        flake8 \
        mypy \
        pytest \
        jupyter \
        ipython \
        requests \
        rich \
        typer \
        click \
        pydantic \
        fastapi \
        flask \
        django \
        sqlalchemy \
        alembic \
        pre-commit \
        bandit \
        safety \
        cookiecutter \
        virtualenv \
        tox
else
    echo "Python3/pip3 not found, skipping Python packages"
fi

# Install Go packages (if Go is available)
if command -v go &> /dev/null; then
    echo "Installing Go development tools..."
    go install github.com/charmbracelet/glow@latest
    go install github.com/jesseduffield/lazydocker@latest
    go install github.com/isacikgoz/gitbatch@latest
    go install github.com/cli/cli/cmd/gh@latest
    go install github.com/profclems/glab@latest
    go install github.com/antonmedv/fx@latest
    go install github.com/rs/curlie@latest
    go install github.com/mikefarah/yq/v4@latest
    go install github.com/charmbracelet/soft-serve/cmd/soft@latest
else
    echo "Go not found, skipping Go packages"
fi

# Install Rust/Cargo packages (if Rust is available)
if command -v cargo &> /dev/null; then
    echo "Installing Rust development tools..."
    cargo install \
        exa \
        bat \
        ripgrep \
        fd-find \
        starship \
        zoxide \
        bottom \
        procs \
        dust \
        tokei \
        hyperfine \
        bandwhich \
        gping \
        watchexec-cli \
        gitui \
        delta \
        sd \
        choose \
        broot \
        tealdeer \
        zellij \
        helix-term \
        silicon \
        xh \
        just \
        onefetch \
        macchina \
        viddy \
        dog \
        duf-utility
else
    echo "Rust/Cargo not found, skipping Rust packages"
fi

# Install Ruby gems (if Ruby is available)  
if command -v gem &> /dev/null; then
    echo "Installing Ruby development tools..."
    gem install \
        colorls \
        lolcat \
        tmuxinator \
        bundler \
        rails \
        jekyll \
        rubocop \
        pry \
        rspec \
        minitest
else
    echo "Ruby/gem not found, skipping Ruby packages"
fi

# Install additional development databases and tools
echo "Setting up additional development tools..."

# Create useful directories
mkdir -p ~/.local/bin
mkdir -p ~/Projects/{personal,work,learning}
mkdir -p ~/Scripts
mkdir -p ~/.ssh

# Add ~/.local/bin to PATH if not already there
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc.local || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# Install additional useful scripts
if command -v curl &> /dev/null; then
    echo "Installing additional useful scripts..."
    
    # Install fzf-git if not already installed
    if [ ! -f ~/.local/bin/fzf-git.sh ]; then
        curl -fsSL https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh -o ~/.local/bin/fzf-git.sh
        chmod +x ~/.local/bin/fzf-git.sh
    fi
    
    # Install diff-so-fancy for better git diffs
    if [ ! -f ~/.local/bin/diff-so-fancy ]; then
        curl -fsSL https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -o ~/.local/bin/diff-so-fancy
        chmod +x ~/.local/bin/diff-so-fancy
    fi
fi

echo "✅ CLI tools installation complete!"
echo ""
echo "📋 Installed categories:"
echo "  • Core development tools and utilities"
echo "  • Network and system monitoring tools"  
echo "  • Text processing and data manipulation tools"
echo "  • Modern alternatives to classic CLI tools"
echo "  • Language-specific development tools (Node.js, Python, Go, Rust, Ruby)"
echo "  • Version control and Git enhancement tools"
echo "  • Container and DevOps tools"
echo "  • Performance monitoring and debugging tools"
echo ""
echo "🔄 Please restart your terminal or run 'source ~/.zshrc' to use new tools"
echo "💡 Run 'which <tool-name>' to verify installation of specific tools"
