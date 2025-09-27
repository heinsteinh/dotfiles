# ~/.zshrc - Enhanced Zsh Configuration

# ============================================================================
# Oh My Zsh Configuration
# ============================================================================
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo
    docker
    docker-compose
    npm
    yarn
    pip
    python
    virtualenv
    tmux
    fzf
    systemd
    ssh-agent
    gpg-agent
)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# Environment Variables
# ============================================================================
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export BROWSER='firefox'
export TERM='xterm-256color'

# Path additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History configuration
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ============================================================================
# Aliases
# ============================================================================
# Enhanced ls commands
if command -v exa &> /dev/null; then
    alias ls='exa'
    alias ll='exa -la --git'
    alias la='exa -a'
    alias lt='exa --tree'
    alias lg='exa -la --git --git-ignore'
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# Enhanced cat
if command -v bat &> /dev/null; then
    alias cat='bat'
    alias catn='bat --style=plain'
fi

# Enhanced find
if command -v fd &> /dev/null; then
    alias find='fd'
fi

# Git shortcuts
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gb='git branch'
alias gm='git merge'
alias gr='git rebase'

# Git with lazygit
if command -v lazygit &> /dev/null; then
    alias lg='lazygit'
fi

# System shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias c='clear'
alias h='history'
alias j='jobs'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# System information
alias ports='netstat -tulanp'
alias top='htop'
if command -v btop &> /dev/null; then
    alias top='btop'
fi

# Package management (OS specific)
if command -v pacman &> /dev/null; then
    alias pac='sudo pacman -S'
    alias pacs='pacman -Ss'
    alias pacu='sudo pacman -Syu'
    alias pacr='sudo pacman -R'
elif command -v apt &> /dev/null; then
    alias apt-i='sudo apt install'
    alias apt-s='apt search'
    alias apt-u='sudo apt update && sudo apt upgrade'
    alias apt-r='sudo apt remove'
elif command -v brew &> /dev/null; then
    alias brew-i='brew install'
    alias brew-s='brew search'
    alias brew-u='brew update && brew upgrade'
    alias brew-r='brew uninstall'
fi

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dimg='docker images'
alias dlog='docker logs -f'
alias dexec='docker exec -it'

# Python/Virtual environments
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Network
alias myip='curl ipinfo.io/ip'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'

# File operations
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias df='df -H'
alias du='du -ch'

# Quick edits
alias zshrc='$EDITOR ~/.zshrc'
alias vimrc='$EDITOR ~/.vimrc'
alias tmuxrc='$EDITOR ~/.tmux.conf'

# ============================================================================
# Functions
# ============================================================================
# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find process and kill
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Git functions
gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Quick backup
backup() {
    cp "$1"{,.bak}
}

# Weather function
weather() {
    curl -4 http://wttr.in/${1:-}
}

# URL encode/decode
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('''$1'''))"
}

urldecode() {
    python3 -c "import urllib.parse; print(urllib.parse.unquote('''$1'''))"
}

# ============================================================================
# Tool Initializations
# ============================================================================
# FZF configuration
if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    elif command -v rg &> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
    
    # Key bindings and completion
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
    [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
fi

# Zoxide (better cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdi='zi'
fi

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# thefuck
if command -v thefuck &> /dev/null; then
    eval $(thefuck --alias)
fi

# direnv
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# ============================================================================
# Key Bindings
# ============================================================================
# Vim mode
bindkey -v

# Edit command line in vim
autoload edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# Search history
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# Move by words
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ============================================================================
# Completion
# ============================================================================
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Colored completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Menu selection
zstyle ':completion:*' menu select

# ============================================================================
# OS Specific Configuration
# ============================================================================
case "$(uname -s)" in
    Darwin)
        # macOS specific
        export HOMEBREW_NO_ANALYTICS=1
        export HOMEBREW_NO_AUTO_UPDATE=1
        
        # Add Homebrew to PATH
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        # macOS aliases
        alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
        alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
        alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
        ;;
    Linux)
        # Linux specific
        if command -v xclip &> /dev/null; then
            alias pbcopy='xclip -selection clipboard'
            alias pbpaste='xclip -selection clipboard -o'
        elif command -v xsel &> /dev/null; then
            alias pbcopy='xsel --clipboard --input'
            alias pbpaste='xsel --clipboard --output'
        fi
        
        # Linux aliases
        alias open='xdg-open'
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
        ;;
esac

# ============================================================================
# Load local customizations
# ============================================================================
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# ============================================================================
# Powerlevel10k instant prompt
# ============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Load custom configurations
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/functions.zsh
source ~/.config/zsh/distro.zsh