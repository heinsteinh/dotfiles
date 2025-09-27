# FZF Configuration for Zsh
# This file configures FZF (fuzzy finder) behavior and key bindings

# Default FZF command - use ripgrep if available, otherwise find
if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!node_modules/*"'
elif command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
else
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\\.git/*" -not -path "*/node_modules/*"'
fi

# Use the same command for Ctrl-T
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# FZF options for better UI
export FZF_DEFAULT_OPTS="
--height 40%
--layout reverse
--border
--inline-info
--preview 'bat --style=numbers --color=always --line-range :500 {}'
--preview-window right:50%:wrap
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6ac,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6ac,hl+:#f38ba8
"

# FZF options for Ctrl-T (file selection)
export FZF_CTRL_T_OPTS="
--preview 'bat --style=numbers --color=always --line-range :500 {}'
--preview-window right:50%:wrap
--bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# FZF options for Alt-C (directory selection)
export FZF_ALT_C_OPTS="
--preview 'tree -C {} | head -200'
--preview-window right:50%:wrap
"

# FZF options for Ctrl-R (history search)
export FZF_CTRL_R_OPTS="
--preview 'echo {}'
--preview-window down:3:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'
"

# Custom FZF functions

# Search and edit files
fe() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Search and cd into directories
fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}

# Kill processes
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

# Git branch selection
fgb() {
    git branch --all | grep -v HEAD | sed 's/^..//' | sed 's#remotes/origin/##' | sort -u | fzf | xargs git checkout
}

# Git log browser
fgl() {
    git log --oneline --color=always | fzf --ansi --preview 'git show --color=always {1}' --preview-window right:60% | awk '{print $1}' | xargs git show
}

# Search in command history
fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# SSH connection helper
fssh() {
    local host
    host=$(grep -E "^Host " ~/.ssh/config 2>/dev/null | grep -v "*" | cut -d' ' -f2 | fzf)
    [ -n "$host" ] && ssh "$host"
}

# Docker container selection
fdocker() {
    local container
    container=$(docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | fzf --header-lines=1 | awk '{print $1}')
    [ -n "$container" ] && docker exec -it "$container" /bin/bash
}

# Environment variable browser
fenv() {
    env | fzf | cut -d= -f1 | xargs -I {} sh -c 'echo "{}=${!{}}"'
}

# Package search (for different package managers)
if command -v brew &> /dev/null; then
    fbrew() {
        brew search | fzf --multi --preview 'brew info {}' | xargs brew install
    }
fi

if command -v apt &> /dev/null; then
    fapt() {
        apt list 2>/dev/null | grep -v "WARNING" | fzf --multi --preview 'apt show {1}' | cut -d'/' -f1 | xargs sudo apt install
    }
fi

# Key bindings will be loaded by system FZF installation or oh-my-zsh plugin
# Don't manually bind here to avoid conflicts

# Load system FZF completion if available (not this file)
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
