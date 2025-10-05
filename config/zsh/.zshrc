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
    fast-syntax-highlighting
    #zsh-autocomplete
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
# Aliases - Loaded from external files
# ============================================================================
# Aliases are loaded at the end of this file from ~/.config/zsh/aliases.zsh

# ============================================================================
# Functions - Loaded from external files
# ============================================================================
# Functions are loaded at the end of this file from ~/.config/zsh/functions.zsh

# ============================================================================
# Tool Initializations
# ============================================================================
# FZF configuration
if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='command fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='command fd --type d --hidden --follow --exclude .git'
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


# ============================================================================
# Load custom configurations
# ============================================================================
# Load modular configuration files with error handling
# Load functions before aliases to avoid conflicts
[[ -f ~/.config/zsh/exports.zsh ]] && source ~/.config/zsh/exports.zsh
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh
[[ -f ~/.config/zsh/aliases.zsh ]] && source ~/.config/zsh/aliases.zsh
[[ -f ~/.config/zsh/distro.zsh ]] && source ~/.config/zsh/distro.zsh

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
