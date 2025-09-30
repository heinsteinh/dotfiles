# ~/.config/zsh/aliases.zsh - Comprehensive Aliases

# ============================================================================
# Enhanced File Operations
# ============================================================================
# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Directory shortcuts
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias docs='cd ~/Documents'
alias proj='cd ~/Projects'
alias dotfiles='cd ~/.dotfiles'

# Enhanced ls (with fallbacks)
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first'
    alias ll='eza -la --git --group-directories-first'
    alias la='eza -a --group-directories-first'
    alias lt='eza --tree --level=2'
    alias lg='eza -la --git --git-ignore'
    alias lsd='eza -D'  # directories only
    alias lsf='eza -f'  # files only
    alias lss='eza -la --sort=size'
    alias lst='eza -la --sort=modified'
elif command -v exa &> /dev/null; then
    alias ls='exa --group-directories-first'
    alias ll='exa -la --git --group-directories-first'
    alias la='exa -a --group-directories-first'
    alias lt='exa --tree --level=2'
    alias lg='exa -la --git --git-ignore'
    alias lsd='exa -D'  # directories only
    alias lsf='exa -f'  # files only
    alias lss='exa -la --sort=size'
    alias lst='exa -la --sort=modified'
else
    alias ll='ls -alFh'
    alias la='ls -Ah'
    alias l='ls -CFh'
    alias lsd='ls -d */'
    alias lss='ls -alSh'
    alias lst='ls -altrh'
fi

# File operations with safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# Archive operations
alias tar-create='tar -czf'
alias tar-extract='tar -xzf'
alias tar-list='tar -tzf'

# ============================================================================
# Text Processing & Search
# ============================================================================
# Enhanced cat
if command -v bat &> /dev/null; then
    alias cat='bat'
    alias catn='bat --style=plain'
    alias batl='bat --language'
else
    alias cat='cat -n'
fi

# Enhanced find
if command -v fd &> /dev/null; then
    alias find='fd'
    alias findd='fd -t d'  # directories only
    alias findf='fd -t f'  # files only
    alias finde='fd -e'    # by extension
fi

# Enhanced grep
if command -v rg &> /dev/null; then
    alias grep='rg'
    alias grepi='rg -i'
    alias grepr='rg -r'
    alias grepv='rg -v'
    alias grepw='rg -w'
    alias grepn='rg -n'
else
    alias grep='grep --color=auto'
    alias grepi='grep -i --color=auto'
    alias grepr='grep -r --color=auto'
    alias grepv='grep -v --color=auto'
fi

# Text manipulation
alias lower="tr '[:upper:]' '[:lower:]'"
alias upper="tr '[:lower:]' '[:upper:]'"
alias trim="sed 's/^[[:space:]]*//;s/[[:space:]]*$//'"
alias squeeze="tr -s ' '"

# Count operations
alias count-lines='wc -l'
alias count-words='wc -w'
alias count-chars='wc -c'
alias count-files='find . -type f | wc -l'
alias count-dirs='find . -type d | wc -l'

# ============================================================================
# Package Management by Distribution
# ============================================================================
# Arch Linux (pacman)
if command -v pacman &> /dev/null; then
    # Basic operations
    alias pac='sudo pacman -S'                 # Install
    alias pacs='pacman -Ss'                    # Search
    alias pacu='sudo pacman -Syu'              # Update
    alias pacr='sudo pacman -R'               # Remove
    alias pacrs='sudo pacman -Rs'             # Remove with deps
    alias paci='pacman -Si'                   # Info
    alias pacq='pacman -Q'                    # Query installed
    alias pacqs='pacman -Qs'                  # Query installed search
    alias pacql='pacman -Ql'                  # List files
    alias pacqo='pacman -Qo'                  # Which package owns file

    # Advanced operations
    alias pacorphans='sudo pacman -Rs $(pacman -Qtdq)'
    alias pacclean='sudo pacman -Sc'
    alias paclog='tail -f /var/log/pacman.log'
    alias pacmirror='sudo reflector --verbose --latest 5 --country US --age 6 --sort rate --save /etc/pacman.d/mirrorlist'

    # AUR helpers
    if command -v yay &> /dev/null; then
        alias yay-update='yay -Syu'
        alias yay-clean='yay -Sc'
        alias yay-orphans='yay -Rs $(yay -Qtdq)'
    fi

    if command -v paru &> /dev/null; then
        alias paru-update='paru -Syu'
        alias paru-clean='paru -Sc'
    fi
fi

# Debian/Ubuntu (apt)
if command -v apt &> /dev/null; then
    alias apt-install='sudo apt install'
    alias apt-search='apt search'
    alias apt-update='sudo apt update'
    alias apt-upgrade='sudo apt update && sudo apt upgrade'
    alias apt-remove='sudo apt remove'
    alias apt-purge='sudo apt purge'
    alias apt-autoremove='sudo apt autoremove'
    alias apt-info='apt show'
    alias apt-list='apt list --installed'
    alias apt-files='dpkg -L'
    alias apt-which='dpkg -S'
    alias apt-clean='sudo apt autoclean && sudo apt autoremove'
    alias apt-history='command grep " install \| remove " /var/log/dpkg.log'
fi

# macOS (Homebrew)
if command -v brew &> /dev/null; then
    alias brew-install='brew install'
    alias brew-search='brew search'
    alias brew-update='brew update && brew upgrade'
    alias brew-remove='brew uninstall'
    alias brew-info='brew info'
    alias brew-list='brew list'
    alias brew-clean='brew cleanup'
    alias brew-doctor='brew doctor'
    alias brew-services='brew services list'
    alias brew-cask='brew install --cask'
    alias brew-outdated='brew outdated'
    alias brew-deps='brew deps --tree'
fi

# Flatpak (universal Linux)
if command -v flatpak &> /dev/null; then
    alias flat-install='flatpak install'
    alias flat-search='flatpak search'
    alias flat-update='flatpak update'
    alias flat-remove='flatpak uninstall'
    alias flat-list='flatpak list'
    alias flat-run='flatpak run'
    alias flat-info='flatpak info'
fi

# Snap (Ubuntu/universal Linux)
if command -v snap &> /dev/null; then
    alias snap-install='sudo snap install'
    alias snap-search='snap find'
    alias snap-update='sudo snap refresh'
    alias snap-remove='sudo snap remove'
    alias snap-list='snap list'
    alias snap-info='snap info'
fi

# ============================================================================
# Process Management
# ============================================================================
# Enhanced process viewing
if command -v btop &> /dev/null; then
    alias top='btop'
    alias htop='btop'
elif command -v htop &> /dev/null; then
    alias top='htop'
fi

# Process operations
alias ps-all='ps aux'
alias ps-user='ps -f -u $USER'
alias ps-cpu='ps aux --sort=-%cpu | head -10'
alias ps-mem='ps aux --sort=-%mem | head -10'
alias ps-grep='ps aux | command grep'

# Process shortcuts
alias psg='ps aux | command grep'
alias psk='pkill -f'
alias pskill='pkill -9 -f'

# Jobs and background processes
alias jobs-running='jobs -r'
alias jobs-stopped='jobs -s'
alias bg-list='jobs'

# Kill operations
alias killall-name='killall -9'
alias kill-port='kill -9 $(lsof -t -i:'

# ============================================================================
# System Information & Monitoring
# ============================================================================
# System info
# sysinfo function is defined in distro.zsh
# Use neofetch directly or call the sysinfo function
if command -v neofetch &> /dev/null; then
    alias nf='neofetch'
fi
alias cpu-info='lscpu'
alias mem-info='free -h'
alias disk-info='df -h'
alias disk-usage='du -sh'
alias disk-usage-sort='du -sh * | sort -hr'

# Hardware info
alias hardware='sudo lshw -short'
alias usb-devices='lsusb'
alias pci-devices='lspci'
alias block-devices='lsblk'

# Network info
alias network-interfaces='ip addr show'
alias network-routes='ip route show'
alias network-connections='ss -tuln'
alias network-listening='ss -tln'
alias network-established='ss -t state established'

# System monitoring
alias watch-disk='watch df -h'
alias watch-mem='watch free -h'
alias watch-load='watch uptime'
alias watch-network='watch ss -tuln'

# Logs
alias log-system='sudo journalctl -f | ccze -A'
alias log-kernel='sudo dmesg -T'
alias log-auth='sudo tail -f /var/log/auth.log'
alias log-boot='sudo journalctl -b | ccze -A'

# ============================================================================
# Storage & Disk Management
# ============================================================================
# Disk space
alias df='df -h'
alias du='du -h'
alias du-summary='du -sh'
alias du-top='du -sh * | sort -hr | head -10'
alias du-depth='du -h --max-depth=1'

# Improved disk usage and drive aliases
alias dusub1='du -h --max-depth=1 | sort -hr'
alias dusub2='du -h --max-depth=2 | sort -hr'
alias disks-info='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h; echo ""; echo "╓───── U.U.I.D.s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -f;'
alias drives-list="echo -n '\e[1;32mListing connected drives:\e[0m'  | pv -qL 10 && lsblk -f"

# Find large files
alias find-large='find . -type f -size +100M -exec ls -lh {} \; | sort -k 5 -hr'
alias find-largest='find . -type f -printf "%s %p\n" | sort -nr | head -10'
alias find-empty='find . -empty'

# Mount operations
alias mounts='mount | column -t'
alias mount-list='findmnt'
alias umount-lazy='sudo umount -l'

# Disk operations
alias disk-speed='sudo hdparm -t'
alias disk-info-detail='sudo fdisk -l'
alias disk-smart='sudo smartctl -a'



# ============================================================================
# Network Operations
# ============================================================================
# Network testing
alias ping='ping -c 5'
alias ping-fast='ping -c 3 -i 0.2'
alias pingg='ping google.com'
alias ping1='ping 1.1.1.1'
alias ping8='ping 8.8.8.8'

# Network utilities
alias myip='curl -s ifconfig.me'
alias myipv4='curl -4 -s ifconfig.me'
alias myipv6='curl -6 -s ifconfig.me'
alias localip='hostname -I | cut -d" " -f1'
alias whois-ip='whois'

# Speed tests
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias speedtest-fast='curl -s https://fast.com'

# Port operations
alias ports='netstat -tulanp'
alias ports-listening='netstat -tln'
alias ports-open='nmap localhost'
alias port-test='nc -zv'

# Download utilities
alias wget-continue='wget -c'
alias wget-spider='wget --spider'
alias curl-headers='curl -I'
alias curl-follow='curl -L'
alias curl-time='curl -w "@/dev/stdin" -o /dev/null -s'

# Systemd service management
#alias sstatus="systemctl status"
alias systemd-start="sudo systemctl start"
alias systemd-stop="sudo systemctl stop"
alias systemd-enable="sudo systemctl enable"
alias systemd-disable="sudo systemctl disable"
alias systemd-reload="sudo systemctl reload"
alias systemd-restart="sudo systemctl restart"
alias systemd-daemon-reload="sudo systemctl --system daemon-reload"
alias sstatus="systemctl status"
alias sstart="sudo systemctl start"
alias sstop="sudo systemctl stop"
alias senable="sudo systemctl enable"
alias sdisable="sudo systemctl disable"
alias sreload="sudo systemctl reload"
alias srestart="sudo systemctl restart"
alias sdaemonreload="sudo systemctl --system daemon-reload"

# ============================================================================
# Development Tools
# ============================================================================
# Git shortcuts
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log'
alias glo='git log --oneline'
alias glog='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gss='git status -s'
alias gb='git branch'
alias gba='git branch -a'
alias gm='git merge'
alias gr='git rebase'
alias gri='git rebase -i'
alias gst='git stash'
alias gsp='git stash pop'
alias gsl='git stash list'

# Git advanced
alias git-undo='git reset --soft HEAD~1'
alias git-reset-hard='git reset --hard HEAD'
alias git-clean='git clean -fd'
alias git-branches='git branch -a'
alias git-remotes='git remote -v'
alias git-contributors='git shortlog -sn'
alias git-files-changed='git diff --name-only'

# Lazy git
if command -v lazygit &> /dev/null; then
    alias lg='lazygit'
    alias lgs='lazygit status'
fi

# Docker shortcuts
if command -v docker &> /dev/null; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias drmi='docker rmi'
    alias dv='docker volume ls'
    alias dn='docker network ls'
    # Note: dlog, dexec, and dclean are defined as functions in functions.zsh for better functionality
    alias drun='docker run -it --rm'
    alias dstop='docker stop'
    alias dstart='docker start'
    alias drestart='docker restart'
    alias dclean-all='docker system prune -af'
    alias dstats='docker stats'
fi

# Python development
alias py='python3'
alias py2='python2'
alias pip='pip3'
alias venv='python3 -m venv'
alias venv-activate='source venv/bin/activate'
alias venv-deactivate='deactivate'
alias pip-freeze='pip freeze > requirements.txt'
alias pip-install-req='pip install -r requirements.txt'
alias pip-upgrade='pip install --upgrade pip'

# Node.js development
if command -v node &> /dev/null; then
    alias node-version='node --version'
    alias npm-global='npm list -g --depth=0'
    alias npm-check='npm outdated'
    alias npm-update='npm update'
    alias yarn-global='yarn global list'
fi

# Web development
alias serve='python3 -m http.server'
alias serve-php='php -S localhost:8000'
alias serve-node='npx http-server'
alias live-server='npx live-server'

# ============================================================================
# Text Editing & Quick Access
# Vim and fuzzy editing
alias vi='vim'
alias vim-today='vim $(date +"%Y-%m-%d")'
#v() { (cd-git-root; vim "$(fzf --query=\"$(echo $@ | tr ' ' '\\ ' )\" )"); }
alias vim-recent='vim +:FZFMru'

# Tmux session management
alias tmux2='tmux -2'
alias tmux-attach='tmux attach -t'
alias tmux-new='tmux new -s'
alias tmux-list='tmux ls'
alias tmux-kill='tmux kill-session -t'
# ============================================================================
# Quick edits
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias vimrc='${EDITOR:-vim} ~/.vimrc'
alias tmuxrc='${EDITOR:-vim} ~/.tmux.conf'
alias gitconfig='${EDITOR:-vim} ~/.gitconfig'
alias sshconfig='${EDITOR:-vim} ~/.ssh/config'
alias hosts='sudo ${EDITOR:-vim} /etc/hosts'

# Configuration reloads
alias reload-zsh='source ~/.zshrc'
alias reload-tmux='tmux source-file ~/.tmux.conf'
alias reload-bash='source ~/.bashrc'

# ============================================================================
# Quick Utilities
# ============================================================================
# Time and date
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias timestamp='date +%s'
alias iso-date='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias week='date +%V'


# Directory and process tree visualization
alias tree-find='find . -not -wholename "*/.git/*" -not -wholename "*/.bzr/*" -not -name ".bzr" -not -name ".git" -not -name "*.sw?" -not -name "*~" -print | sed -e "s;[^/]*/;|__;g;s;__|; |;g"'
alias tree-all='tree -A'
alias tree-dirs='tree -d'
alias tree-d1='tree -d -L 1'
alias tree-d2='tree -d -L 2'
alias pstree-color='pstree -U "$@" | sed '\''s/[-a-zA-Z]\+/\x1B[32m&\x1B[0m/g; s/[{}]/\x1B[31m&\x1B[0m/g; s/[─┬─├─└│]/\x1B[34m&\x1B[0m/g'\'''




# Clipboard (cross-platform)
case "$(uname -s)" in
    Darwin)
        alias copy='pbcopy'
        alias paste='pbpaste'
        ;;
    Linux)
        if command -v xclip &> /dev/null; then
            alias copy='xclip -selection clipboard'
            alias paste='xclip -selection clipboard -o'
        elif command -v xsel &> /dev/null; then
            alias copy='xsel --clipboard --input'
            alias paste='xsel --clipboard --output'
        fi
        ;;
esac

# URL operations
alias url-encode='python3 -c "import urllib.parse; import sys; print(urllib.parse.quote(sys.argv[1]))"'
alias url-decode='python3 -c "import urllib.parse; import sys; print(urllib.parse.unquote(sys.argv[1]))"'

# JSON operations
if command -v jq &> /dev/null; then
    alias json-pretty='jq .'
    alias json-compact='jq -c .'
    alias json-keys='jq keys'
    alias json-values='jq .[]'
fi

# Base64 operations
alias b64encode='base64'
alias b64decode='base64 -d'

# Hash operations
alias md5='md5sum'
alias sha1='sha1sum'
alias sha256='sha256sum'

# ============================================================================
# Fun & Productivity
# ============================================================================
# weather function is defined in functions.zsh (supports location parameter)
alias weather-short='curl "wttr.in?format=3"'

# Cheat sheets
if command -v tldr &> /dev/null; then
    alias help='tldr'
    alias man-simple='tldr'
fi

# Random generators
alias random-password='openssl rand -base64 32'
alias random-hex='openssl rand -hex 16'
alias uuid='uuidgen'

# System shortcuts
alias cls='clear'
alias c='clear'
alias h='history'
alias j='jobs'
alias path='echo $PATH | tr ":" "\n"'
alias env-sorted='env | sort'

# Security
alias chmod-script='chmod +x'
alias chmod-private='chmod 600'
alias chmod-public='chmod 644'
alias chmod-dir='chmod 755'

# ============================================================================
# Conditional Aliases (based on available tools)
# ============================================================================
# Enhanced diff
if command -v delta &> /dev/null; then
    alias diff='delta'
elif command -v colordiff &> /dev/null; then
    alias diff='colordiff'
fi

# Enhanced less
if command -v bat &> /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Enhanced du
if command -v dust &> /dev/null; then
    alias du='dust'
fi

# Enhanced ps
if command -v procs &> /dev/null; then
    alias ps='procs'
fi

# ============================================================================
# Platform-specific Aliases
# ============================================================================
case "$(uname -s)" in
    Darwin)
        # macOS specific
        # Clean up macOS metadata files
        alias cleanup-dsstore="find . -type f -name '*.DS_Store' -ls -exec /bin/rm {} \;"
        alias cleanup-appledouble="find . -type d -name .AppleDouble -ls -exec /bin/rm -r {} \;"
        alias flush-dns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
        alias show-hidden='defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
        alias hide-hidden='defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'
        alias desktop-show='defaults write com.apple.finder CreateDesktop true && killall Finder'
        alias desktop-hide='defaults write com.apple.finder CreateDesktop false && killall Finder'
        alias sleep-display='pmset displaysleepnow'
        alias lock-screen='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
        alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
        ;;
    Linux)
        # Linux specific
        alias open='xdg-open'
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
        alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
        alias kernel-version='uname -r'
        alias list-services='systemctl list-units --type=service'
        alias failed-services='systemctl --failed'
        ;;
esac

# ============================================================================
# Custom Functions as Aliases
# ============================================================================
# backup function is defined in functions.zsh (more powerful than simple alias)

# extract function is defined in functions.zsh (more comprehensive than alias)

# Find and replace in files
alias find-replace='command grep -rl "$1" . | xargs sed -i "s/$1/$2/g"'

# mkcd function is defined in functions.zsh

# fkill function is defined in functions.zsh (more interactive with fzf)

# Quick calculator
alias calc='python3 -c "import sys; print(eval(\" \".join(sys.argv[1:])))"'

# Get file size
alias filesize='stat -f%z'

# Show PATH in readable format
alias show-path='echo $PATH | tr ":" "\n" | nl'
