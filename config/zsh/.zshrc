# Enhanced Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"

# Install Oh My Zsh if not present
if [[ ! -d "$ZSH" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_THEME="robbyrussell"

plugins=(
    git
    sudo
    fzf
)

source $ZSH/oh-my-zsh.sh

# Load additional configurations
[[ -f ~/.config/zsh/aliases.zsh ]] && source ~/.config/zsh/aliases.zsh
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh
[[ -f ~/.config/zsh/exports.zsh ]] && source ~/.config/zsh/exports.zsh
[[ -f ~/.config/zsh/distro.zsh ]] && source ~/.config/zsh/distro.zsh

# Load local configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
