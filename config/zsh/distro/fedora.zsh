# Fedora/RHEL specific aliases and functions

# ============================================================================
# DNF Package Management
# ============================================================================
alias dnf-install="sudo dnf install"
alias dnf-search="dnf search"
alias dnf-update="sudo dnf update"
alias dnf-remove="sudo dnf remove"
alias dnf-info="dnf info"
alias dnf-installed="dnf list installed"
alias dnf-clean="sudo dnf clean all"
alias dnf-history="dnf history"

# Short aliases
alias dnfi="sudo dnf install"
alias dnfu="sudo dnf update"
alias dnfs="dnf search"
alias dnfr="sudo dnf remove"
alias dnfl="dnf list installed"
alias dnfh="dnf history"

# ============================================================================
# Repository Management
# ============================================================================
alias add-repo="sudo dnf config-manager --add-repo"
alias enable-repo="sudo dnf config-manager --enable"
alias disable-repo="sudo dnf config-manager --disable"

# ============================================================================
# System Management
# ============================================================================
alias update-system="sudo dnf update"
alias check-updates="dnf check-update"
alias update-all="sudo dnf update && flatpak update"
alias clean-system="sudo dnf autoremove && sudo dnf clean all"

# ============================================================================
# Service Management
# ============================================================================
alias enable-service="sudo systemctl enable"
alias start-service="sudo systemctl start"
alias restart-service="sudo systemctl restart"
alias status-service="systemctl status"
alias services="systemctl list-units --type=service"
alias logs="journalctl -f"

# ============================================================================
# Fedora-Specific
# ============================================================================
alias fedora-version="cat /etc/fedora-release"
alias flatpak-install="flatpak install"
alias flatpak-update="flatpak update"
alias flatpak-list="flatpak list"

# ============================================================================
# Firewall Management
# ============================================================================
alias firewall-list="sudo firewall-cmd --list-all"
alias firewall-reload="sudo firewall-cmd --reload"
alias firewall-status="sudo firewall-cmd --state"

# ============================================================================
# SELinux Shortcuts
# ============================================================================
alias selinux-status="sestatus"
alias selinux-enforcing="sudo setenforce 1"
alias selinux-permissive="sudo setenforce 0"

# ============================================================================
# RPM Shortcuts
# ============================================================================
alias rpm-qa="rpm -qa"
alias rpm-qi="rpm -qi"
alias rpm-ql="rpm -ql"

# ============================================================================
# Development Tools
# ============================================================================
# Use Podman as Docker alias if available
if command -v podman &> /dev/null; then
    alias docker="podman"
fi

# ============================================================================
# Fedora-Specific Paths
# ============================================================================
export PATH="/usr/local/sbin:$PATH"
