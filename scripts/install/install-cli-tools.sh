#!/bin/bash
# Install CLI utilities and system tools (no development tools)

set -euo pipefail

echo "Installing CLI utilities and system tools..."

# Detect package manager and install platform-specific tools
if command -v pacman &> /dev/null; then
    # Arch Linux
    echo "Installing CLI tools for Arch Linux..."
    
    # Core CLI utilities
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

    # Network and system monitoring tools
    sudo pacman -S --needed --noconfirm \
        nload \
        iotop \
        nethogs \
        duf \
        broot \
        choose \
        sd \
        tealdeer

    # System debugging and analysis tools  
    sudo pacman -S --needed --noconfirm \
        strace \
        ltrace \
        lsof \
        socat \
        netcat \
        tcpdump \
        wireshark-cli

    # Text processing and data manipulation tools
    sudo pacman -S --needed --noconfirm \
        miller \
        pandoc \
        shellcheck \
        yamllint \
        hadolint-bin

elif command -v brew &> /dev/null; then
    # macOS  
    echo "Installing CLI tools for macOS..."
    
    # Core CLI utilities
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

    # System debugging and analysis tools
    brew install \
        strace \
        lsof \
        socat \
        netcat \
        tcpdump \
        wireshark

    # Text processing and data manipulation tools  
    brew install \
        miller \
        pandoc \
        shellcheck \
        yamllint \
        hadolint

    # Modern CLI alternatives and utilities
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
        glab \
        bat \
        exa \
        ripgrep \
        fd \
        fzf \
        jq \
        yq

    # Install additional casks for system utilities
    brew install --cask \
        stats \
        tunnelblick

elif command -v apt &> /dev/null; then
    # Debian/Ubuntu
    echo "Installing CLI tools for Debian/Ubuntu..."
    sudo apt update
    
    # Core CLI utilities
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

    # Network and system monitoring tools
    sudo apt install -y \
        nload \
        iotop \
        nethogs \
        socat \
        netcat \
        tcpdump \
        tshark

    # System debugging and analysis tools
    sudo apt install -y \
        strace \
        ltrace \
        lsof \
        gdb \
        valgrind

    # Text processing and data manipulation tools
    sudo apt install -y \
        pandoc \
        shellcheck \
        yamllint \
        miller \
        jq

    # Install modern tools from snap if available
    if command -v snap &> /dev/null; then
        sudo snap install \
            starship \
            yq \
            glow \
            gh
    fi

    # Install additional CLI utilities via apt if available
    sudo apt install -y \
        neofetch \
        thefuck \
        direnv \
        entr \
        watchexec \
        bat \
        exa \
        ripgrep \
        fd-find \
        fzf
        
    echo "Note: Some modern CLI tools may require manual installation on this system."

elif command -v dnf &> /dev/null; then
    # Fedora
    echo "Installing CLI tools for Fedora..."
    
    # Core CLI utilities
    sudo dnf install -y \
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
        zoxide

    # Network and system monitoring
    sudo dnf install -y \
        nload \
        iotop \
        nethogs \
        socat \
        netcat \
        tcpdump \
        wireshark-cli

    # System debugging and analysis tools
    sudo dnf install -y \
        strace \
        ltrace \
        lsof \
        gdb \
        valgrind

    # Text processing and data manipulation tools
    sudo dnf install -y \
        pandoc \
        shellcheck \
        yamllint \
        miller \
        jq \
        yq

    # Modern CLI alternatives
    sudo dnf install -y \
        neofetch \
        thefuck \
        direnv \
        entr \
        bat \
        exa \
        ripgrep \
        fd-find \
        fzf
fi

echo "✅ CLI tools installation complete!"
echo ""
echo "📋 Installed CLI tool categories:"
echo "  • File managers and navigation: ranger, tree, exa"
echo "  • Network utilities: httpie, nmap, curl, wget"
echo "  • System monitoring: iotop, nethogs, nload"  
echo "  • Text processing: pandoc, miller, jq, yq"
echo "  • Modern CLI alternatives: bat, ripgrep, fd, fzf"
echo "  • Git enhancement tools: git-delta, gh, glab, gitui"
echo "  • System debugging: strace, lsof, gdb"
echo "  • Shell utilities: starship, zoxide, direnv"
echo ""
echo "🔄 Please restart your terminal or run 'source ~/.zshrc' to use new tools"
echo "💡 Run 'which <tool-name>' to verify installation of specific tools"#!/bin/bash
# Install CLI utilities and system tools (no development tools)

set -euo pipefail

echo "Installing CLI utilities and system tools..."

# Detect package manager and install platform-specific tools
if command -v pacman &> /dev/null; then
    # Arch Linux
    echo "Installing CLI tools for Arch Linux..."
    
    # Core CLI utilities
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

    # Network and system monitoring tools
    sudo pacman -S --needed --noconfirm \
        nload \
        iotop \
        nethogs \
        duf \
        broot \
        choose \
        sd \
        tealdeer

    # System debugging and analysis tools  
    sudo pacman -S --needed --noconfirm \
        strace \
        ltrace \
        lsof \
        socat \
        netcat \
        tcpdump \
        wireshark-cli

    # Text processing and data manipulation tools
    sudo pacman -S --needed --noconfirm \
        miller \
        pandoc \
        shellcheck \
        yamllint \
        hadolint-bin

elif command -v brew &> /dev/null; then
    # macOS  
    echo "Installing CLI tools for macOS..."
    
    # Core CLI utilities
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

    # System debugging and analysis tools
    brew install \
        strace \
        lsof \
        socat \
        netcat \
        tcpdump \
        wireshark

    # Text processing and data manipulation tools  
    brew install \
        miller \
        pandoc \
        shellcheck \
        yamllint \
        hadolint

    # Modern CLI alternatives and utilities
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
        glab \
        bat \
        exa \
        ripgrep \
        fd \
        fzf \
        jq \
        yq

    # Install additional casks for system utilities
    brew install --cask \
        stats \
        tunnelblick

elif command -v apt &> /dev/null; then
    # Debian/Ubuntu
    echo "Installing CLI tools for Debian/Ubuntu..."
    sudo apt update
    
    # Core CLI utilities
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

    # Network and system monitoring tools
    sudo apt install -y \
        nload \
        iotop \
        nethogs \
        socat \
        netcat \
        tcpdump \
        tshark

    # System debugging and analysis tools
    sudo apt install -y \
        strace \
        ltrace \
        lsof \
        gdb \
        valgrind

    # Text processing and data manipulation tools
    sudo apt install -y \
        pandoc \
        shellcheck \
        yamllint \
        miller \
        jq

    # Install modern tools from snap if available
    if command -v snap &> /dev/null; then
        sudo snap install \
            starship \
            yq \
            glow \
            gh
    fi

    # Install additional CLI utilities via apt if available
    sudo apt install -y \
        neofetch \
        thefuck \
        direnv \
        entr \
        watchexec \
        bat \
        exa \
        ripgrep \
        fd-find \
        fzf
        
    echo "Note: Some modern CLI tools may require manual installation on this system."

elif command -v dnf &> /dev/null; then
    # Fedora
    echo "Installing CLI tools for Fedora..."
    
    # Core CLI utilities
    sudo dnf install -y \
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
        zoxide

    # Network and system monitoring
    sudo dnf install -y \
        nload \
        iotop \
        nethogs \
        socat \
        netcat \
        tcpdump \
        wireshark-cli

    # System debugging and analysis tools
    sudo dnf install -y \
        strace \
        ltrace \
        lsof \
        gdb \
        valgrind

    # Text processing and data manipulation tools
    sudo dnf install -y \
        pandoc \
        shellcheck \
        yamllint \
        miller \
        jq \
        yq

    # Modern CLI alternatives
    sudo dnf install -y \
        neofetch \
        thefuck \
        direnv \
        entr \
        bat \
        exa \
        ripgrep \
        fd-find \
        fzf
fi

echo "✅ CLI tools installation complete!"
echo ""
echo "📋 Installed CLI tool categories:"
echo "  • File managers and navigation: ranger, tree, exa"
echo "  • Network utilities: httpie, nmap, curl, wget"
echo "  • System monitoring: iotop, nethogs, nload"  
echo "  • Text processing: pandoc, miller, jq, yq"
echo "  • Modern CLI alternatives: bat, ripgrep, fd, fzf"
echo "  • Git enhancement tools: git-delta, gh, glab, gitui"
echo "  • System debugging: strace, lsof, gdb"
echo "  • Shell utilities: starship, zoxide, direnv"
echo ""
echo "🔄 Please restart your terminal or run 'source ~/.zshrc' to use new tools"
echo "💡 Run 'which <tool-name>' to verify installation of specific tools"