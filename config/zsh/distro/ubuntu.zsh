# Ubuntu/Debian specific aliases and functions

# ============================================================================
# Package Management
# ============================================================================
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

# ============================================================================
# Repository Management
# ============================================================================
alias add-repo='sudo add-apt-repository'
alias remove-repo='sudo add-apt-repository --remove'
alias update-sources='sudo apt update'

# ============================================================================
# System Management
# ============================================================================
alias update-system='sudo apt update && sudo apt upgrade'
alias dist-upgrade='sudo apt update && sudo apt dist-upgrade'
alias check-updates='apt list --upgradable'

# ============================================================================
# Ubuntu-Specific
# ============================================================================
alias ubuntu-version='lsb_release -a'
alias ubuntu-codename='lsb_release -c'
alias snap-list='snap list'
alias snap-install='sudo snap install'
alias snap-remove='sudo snap remove'
alias snap-update='sudo snap refresh'

# ============================================================================
# Service Management
# ============================================================================
alias enable-service='sudo systemctl enable'
alias start-service='sudo systemctl start'
alias restart-service='sudo systemctl restart'
alias status-service='systemctl status'

# ============================================================================
# Debian/Ubuntu-Specific Functions
# ============================================================================

# Interactive package search and install with fzf
apt_search_install() {
    local package
    package=$(apt search "$1" 2>/dev/null | grep -E '^[^[:space:]]' | fzf --preview 'apt show {1}' | awk -F'/' '{print $1}')
    [[ -n $package ]] && sudo apt install "$package"
}
