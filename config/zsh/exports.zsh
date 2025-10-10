# Environment variables
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LANG=en_US.UTF-8

# PATH additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"


# SSH Agent - Load all SSH keys automatically
# Note: load_ssh_keys function is defined in functions.zsh
# This will be called after functions.zsh is sourced in .zshrc
if typeset -f load_ssh_keys > /dev/null; then
    load_ssh_keys
fi

# NVM (Node Version Manager) configuration
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
