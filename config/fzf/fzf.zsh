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

# FZF options for better UI (Atom Dark theme)
# Colors from config/themes/atom-dark.sh
export FZF_DEFAULT_OPTS="
--height 70%
--layout reverse
--border
--inline-info
--color=bg+:#3e4451,bg:#282c34,spinner:#56b6c2,hl:#61afef
--color=fg:#abb2bf,header:#e06c75,info:#d19a66,pointer:#98c379
--color=marker:#98c379,fg+:#abb2bf,prompt:#61afef,hl+:#61afef
--color=border:#5c6370,gutter:#282c34
"

# FZF options for Ctrl-T (file selection)
export FZF_CTRL_T_OPTS="
--preview 'bat --style=numbers --color=always --line-range :500 {}'
--preview-window right:50%:wrap
--bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# Use fd for Alt-C (directory selection) when available
if command -v fd &> /dev/null; then
    export FZF_ALT_C_COMMAND='command fd --type d --hidden --follow --exclude .git'
elif command -v fdfind &> /dev/null; then
    # Debian/Ubuntu ships fd as fdfind
    export FZF_ALT_C_COMMAND='command fdfind --type d --hidden --follow --exclude .git'
fi

# FZF options for Alt-C (directory selection)
export FZF_ALT_C_OPTS="
--preview 'tree -C {} | head -200'
--preview-window right:50%:wrap
"

# Clipboard command for Ctrl-Y in history search (macOS, Wayland, X11)
if command -v pbcopy &> /dev/null; then
    _fzf_clip='pbcopy'
elif command -v wl-copy &> /dev/null; then
    _fzf_clip='wl-copy'
elif command -v xclip &> /dev/null; then
    _fzf_clip='xclip -selection clipboard'
else
    _fzf_clip='cat > /dev/null'
fi

# FZF options for Ctrl-R (history search)
export FZF_CTRL_R_OPTS="
--preview 'echo {}'
--preview-window down:3:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | $_fzf_clip)+abort'
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

# Search and cd into directories (fuzzy directory)
# Renamed from fd() to fzd() to avoid conflict with fd binary
fzd() {
    local dir
    # Use tree for preview if available, otherwise ls
    if command -v tree &> /dev/null; then
        dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m --preview 'tree -C -L 2 {} 2>/dev/null || ls -la {} 2>/dev/null' --preview-window 'right:50%')
    elif command -v eza &> /dev/null; then
        dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m --preview 'eza -la --icons --git {} 2>/dev/null || ls -la {} 2>/dev/null' --preview-window 'right:50%')
    else
        dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m --preview 'ls -la {} 2>/dev/null' --preview-window 'right:50%')
    fi
    [[ -n $dir ]] && cd "$dir"
}

# Note: fkill() function is defined in functions.zsh
# Removed duplicate to avoid conflicts

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

# Load fzf key bindings (Ctrl-R, Ctrl-T, Alt-C) and **<TAB> completion.
# Each platform installs the shell scripts in a different place, so use the
# first directory that has them. `fzf --zsh` is not used because the fzf
# shipped by Ubuntu 22.04/24.04 is too old to support it.
for _fzf_shell_dir in \
    "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf/shell" \
    /usr/local/opt/fzf/shell \
    "$HOME/.fzf/shell" \
    /usr/share/fzf \
    /usr/share/fzf/shell \
    /usr/share/doc/fzf/examples; do
    if [[ -f "$_fzf_shell_dir/key-bindings.zsh" ]]; then
        source "$_fzf_shell_dir/key-bindings.zsh"
        [[ -f "$_fzf_shell_dir/completion.zsh" ]] && source "$_fzf_shell_dir/completion.zsh"
        break
    fi
done
unset _fzf_shell_dir _fzf_clip
