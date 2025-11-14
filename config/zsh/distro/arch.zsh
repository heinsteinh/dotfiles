# Arch Linux specific aliases and functions

# ============================================================================
# Package Management
# ============================================================================
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

# ============================================================================
# AUR Helpers
# ============================================================================
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

# ============================================================================
# System Management
# ============================================================================
alias update-system='sudo pacman -Syu'
alias update-mirrors='sudo reflector --verbose --latest 20 --country US --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias kernel-list='pacman -Q | grep linux'
alias driver-check='lspci -v | grep -A1 -e VGA -e 3D'

# ============================================================================
# Service Management
# ============================================================================
alias enable-service='sudo systemctl enable'
alias start-service='sudo systemctl start'
alias restart-service='sudo systemctl restart'
alias status-service='systemctl status'
alias failed-services='systemctl --failed'

# ============================================================================
# Arch-Specific Functions
# ============================================================================

# Interactive package search and install with fzf
pac_search_install() {
    local package
    package=$(pacman -Ss "$1" | grep -E '^[^[:space:]]' | fzf --preview 'pacman -Si {1}' | awk '{print $1}')
    [[ -n $package ]] && sudo pacman -S "$package"
}

# Check for .pacnew files
alias pacnew='find /etc -name "*.pacnew" 2>/dev/null'
