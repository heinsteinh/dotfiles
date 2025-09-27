# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

# Enhanced tools (if available)
if command -v exa &> /dev/null; then
    alias ls='exa'
    alias ll='exa -la'
fi

if command -v bat &> /dev/null; then
    alias cat='bat'
fi
