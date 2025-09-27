# Fedora-specific Zsh Configuration

# Package manager aliases
alias dnfi="sudo dnf install"
alias dnfu="sudo dnf update"
alias dnfs="dnf search"
alias dnfr="sudo dnf remove"
alias dnfl="dnf list installed"
alias dnfh="dnf history"

# System management
alias systemctl="sudo systemctl"
alias services="systemctl list-units --type=service"
alias logs="journalctl -f"

# Fedora-specific paths
export PATH="/usr/local/sbin:$PATH"

# Development tools
if command -v podman &> /dev/null; then
    alias docker="podman"
fi

# Firewall management
alias firewall-list="sudo firewall-cmd --list-all"
alias firewall-reload="sudo firewall-cmd --reload"

# SELinux shortcuts
alias selinux-status="sestatus"
alias selinux-enforcing="sudo setenforce 1"
alias selinux-permissive="sudo setenforce 0"

# RPM shortcuts
alias rpm-qa="rpm -qa"
alias rpm-qi="rpm -qi"
alias rpm-ql="rpm -ql"

# Updates and cleanup
alias update-all="sudo dnf update && flatpak update"
alias clean-system="sudo dnf autoremove && sudo dnf clean all"

# Fedora version
alias fedora-version="cat /etc/fedora-release"
