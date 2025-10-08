# macOS specific aliases and functions

# ============================================================================
# Homebrew Management
# ============================================================================
alias brew-install='brew install'
alias brew-search='brew search'
alias brew-update='brew update && brew upgrade'
alias brew-remove='brew uninstall'
alias brew-info='brew info'
alias brew-list='brew list'
alias brew-clean='brew cleanup'
alias brew-doctor='brew doctor'
alias brew-cask='brew install --cask'
alias brew-services='brew services list'
alias brew-outdated='brew outdated'

# ============================================================================
# macOS System Management
# ============================================================================
alias update-system='softwareupdate -i -a'
alias check-updates='softwareupdate -l'
alias macos-version='sw_vers'

# ============================================================================
# macOS Specific Utilities
# ============================================================================
alias show-hidden='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hide-hidden='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias flush-dns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
alias rebuild-launch='sudo /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user && killall Finder'

# ============================================================================
# Quick System Controls
# ============================================================================
alias sleep-display='pmset displaysleepnow'
alias prevent-sleep='caffeinate'
alias lock-screen='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# ============================================================================
# Network Utilities
# ============================================================================
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
alias wifi-scan='airport -s'
alias wifi-info='airport -I'

# ============================================================================
# Application Management
# ============================================================================
alias app-store='mas list'
alias app-install='mas install'
alias app-search='mas search'

# ============================================================================
# Clipboard Utilities
# ============================================================================
alias copy='pbcopy'
alias paste='pbpaste'

# ============================================================================
# macOS-Specific Functions
# ============================================================================

# Interactive Homebrew package search and install with fzf
brew_search_install() {
    local package
    package=$(brew search "$1" | fzf --preview 'brew info {}')
    [[ -n $package ]] && brew install "$package"
}
