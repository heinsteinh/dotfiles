# Debian-specific Zsh Configuration

# Package manager aliases
alias apti="sudo apt install"
alias aptu="sudo apt update && sudo apt upgrade"
alias apts="apt search"
alias aptr="sudo apt remove"
alias aptl="apt list --installed"
alias aptc="sudo apt autoremove && sudo apt autoclean"

# APT shortcuts
alias apt-update="sudo apt update"
alias apt-upgrade="sudo apt upgrade"
alias apt-full-upgrade="sudo apt full-upgrade"
alias apt-dist-upgrade="sudo apt dist-upgrade"

# System management
alias services="systemctl list-units --type=service"
alias logs="journalctl -f"

# Debian-specific paths
export PATH="/usr/local/sbin:$PATH"

# Development tools
if [[ -d "/usr/lib/nodejs" ]]; then
    export PATH="/usr/lib/nodejs/bin:$PATH"
fi

# Package information
alias pkg-info="dpkg -l"
alias pkg-files="dpkg -L"
alias pkg-search="apt-cache search"

# Updates and cleanup
alias update-all="sudo apt update && sudo apt upgrade"
alias clean-system="sudo apt autoremove && sudo apt autoclean"

# System information
alias debian-version="cat /etc/debian_version"
alias lsb-info="lsb_release -a"

# Service management shortcuts
alias restart-service="sudo systemctl restart"
alias stop-service="sudo systemctl stop"
alias start-service="sudo systemctl start"
alias enable-service="sudo systemctl enable"
alias disable-service="sudo systemctl disable"

# Network management
alias network-restart="sudo systemctl restart networking"