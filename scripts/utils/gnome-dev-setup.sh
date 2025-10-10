#!/bin/bash
# GNOME Desktop Customization for Developers & CLI Power Users
# Optimized for light theme and productivity
# Run as regular user (no sudo needed)

set -e

echo "=========================================="
echo "GNOME Developer Customization Script"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_section() {
    echo -e "\n${BLUE}═══${NC} $1 ${BLUE}═══${NC}"
}

# 1. Interface & Appearance
customize_interface() {
    print_section "Configuring Interface & Appearance"
    
    # Light theme
    gsettings set org.gnome.desktop.interface color-scheme 'default'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    print_status "Light theme enabled"
    
    # Font settings for developers
    gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'
    gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 11'
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10'
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 11'
    print_status "Developer fonts configured"
    
    # Show battery percentage
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    
    # Show weekday in clock
    gsettings set org.gnome.desktop.interface clock-show-weekday true
    
    # Enable night light (easy on eyes)
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4000
    print_status "Night light enabled (4000K)"
}

# 2. Window Management
customize_windows() {
    print_section "Configuring Window Management"
    
    # Center new windows
    gsettings set org.gnome.mutter center-new-windows true
    
    # Enable window maximization on double-click titlebar
    gsettings set org.gnome.desktop.wm.preferences action-double-click-titlebar 'toggle-maximize'
    
    # Focus follows mouse (optional - uncomment if you want)
    # gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'
    
    # Attach modal dialogs to parent window
    gsettings set org.gnome.mutter attach-modal-dialogs true
    
    # Dynamic workspaces
    gsettings set org.gnome.mutter dynamic-workspaces false
    gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
    print_status "4 static workspaces configured"
    
    # Show windows from all workspaces in overview
    gsettings set org.gnome.shell.app-switcher current-workspace-only false
    print_status "Window management optimized"
}

# 3. Keyboard Shortcuts
setup_shortcuts() {
    print_section "Configuring Keyboard Shortcuts"
    
    # Custom keybindings array
    CUSTOM_KEYBINDINGS="['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
    
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$CUSTOM_KEYBINDINGS"
    
    # Terminal shortcut (Super+Enter)
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>Return'
    print_status "Terminal: Super+Enter"
    
    # File Manager (Super+E)
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Files'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'nautilus'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super>e'
    print_status "Files: Super+E"
    
    # System Monitor (Ctrl+Shift+Esc)
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'System Monitor'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'gnome-system-monitor'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Primary><Shift>Escape'
    print_status "System Monitor: Ctrl+Shift+Esc"
    
    # Window management shortcuts
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
    gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"
    print_status "Window shortcuts: Super+Q (close), Super+M (maximize), Super+F (fullscreen)"
    
    # Workspace switching (Super+1,2,3,4)
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
    print_status "Workspace switching: Super+1,2,3,4"
    
    # Move window to workspace (Super+Shift+1,2,3,4)
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
    print_status "Move to workspace: Super+Shift+1,2,3,4"
    
    # Screenshot shortcuts
    gsettings set org.gnome.shell.keybindings screenshot "['Print']"
    gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift>Print']"
    print_status "Screenshots: Print / Shift+Print"
}

# 4. File Manager (Nautilus)
customize_nautilus() {
    print_section "Configuring File Manager"
    
    # Show hidden files
    gsettings set org.gnome.nautilus.preferences show-hidden-files true
    
    # List view as default
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
    
    # Show full path in title bar
    gsettings set org.gnome.nautilus.preferences always-use-location-entry true
    
    # Enable tree view in sidebar
    gsettings set org.gnome.nautilus.list-view use-tree-view true
    
    # Sort folders before files
    gsettings set org.gtk.Settings.FileChooser sort-directories-first true
    
    print_status "Nautilus configured for power users"
}

# 5. Terminal Settings
customize_terminal() {
    print_section "Configuring GNOME Terminal"
    
    # Get default profile UUID
    PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
    PROFILE_PATH="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/"
    
    # Font
    dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/font "'JetBrains Mono 11'"
    dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/use-system-font false
    
    # Colors - light theme with good contrast
    dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/use-theme-colors false
    dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/background-color "'rgb(255,255,255)'"
    dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/foreground-color "'rgb(46,52,64)'"
    
    # Scrollback
    dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/scrollback-lines 10000
    dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/scrollback-unlimited false
    
    # Bell
    dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/audible-bell false
    
    print_status "Terminal configured with JetBrains Mono font"
}

# 6. Power Settings
customize_power() {
    print_section "Configuring Power Settings"
    
    # Never dim screen when plugged in
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
    
    # Sleep after 30 minutes on AC
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 1800
    
    # Sleep after 15 minutes on battery
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
    
    # Show percentage
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    
    print_status "Power settings optimized for development"
}

# 7. Privacy & Security
customize_privacy() {
    print_section "Configuring Privacy Settings"
    
    # Disable recent files tracking
    gsettings set org.gnome.desktop.privacy remember-recent-files false
    
    # Clear recent files
    gsettings set org.gnome.desktop.privacy recent-files-max-age 7
    
    # Disable file history
    gsettings set org.gnome.desktop.privacy remember-app-usage false
    
    # Location services off
    gsettings set org.gnome.system.location enabled false
    
    print_status "Privacy settings configured"
}

# 8. Performance Tweaks
customize_performance() {
    print_section "Configuring Performance"
    
    # Disable animations for snappier feel
    gsettings set org.gnome.desktop.interface enable-animations true
    
    # Reduce animation speed (faster)
    gsettings set org.gnome.desktop.interface gtk-enable-animations true
    
    # Disable mouse acceleration (better for precision work)
    gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
    
    # Touchpad settings
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
    gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
    
    print_status "Performance optimized"
}

# 9. Developer-specific tweaks
customize_developer() {
    print_section "Developer-specific Configuration"
    
    # Enable hot corners (top-left for Activities)
    gsettings set org.gnome.desktop.interface enable-hot-corners true
    
    # Disable automatic screen lock (annoying during development)
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    
    # Blank screen after 15 minutes
    gsettings set org.gnome.desktop.session idle-delay 900
    
    # Show mounted drives in sidebar
    gsettings set org.gnome.nautilus.preferences show-mounted-devices true
    
    print_status "Developer tweaks applied"
}

# 10. Favorites bar
setup_favorites() {
    print_section "Setting up Favorites Bar"
    
    # Add common development apps to favorites
    gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'firefox.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Screenshot.desktop']"
    
    print_status "Favorites bar configured"
}

# Main execution
main() {
    echo "This script will customize your GNOME desktop for development work."
    echo "Press Enter to continue or Ctrl+C to cancel..."
    read
    
    customize_interface
    customize_windows
    setup_shortcuts
    customize_nautilus
    customize_terminal
    customize_power
    customize_privacy
    customize_performance
    customize_developer
    setup_favorites
    
    print_section "Configuration Complete!"
    echo ""
    echo "Summary of changes:"
    echo "  • Light theme with developer fonts (JetBrains Mono)"
    echo "  • 4 static workspaces with Super+1,2,3,4 shortcuts"
    echo "  • Terminal: Super+Enter"
    echo "  • Files: Super+E"
    echo "  • System Monitor: Ctrl+Shift+Esc"
    echo "  • Window management: Super+Q/M/F"
    echo "  • Nautilus: show hidden files, list view, tree sidebar"
    echo "  • Terminal: JetBrains Mono 11, light theme, 10k scrollback"
    echo "  • Privacy: recent files disabled"
    echo "  • Performance: flat mouse profile, tap-to-click"
    echo ""
    echo "Restart GNOME Shell: Alt+F2, type 'r', press Enter"
    echo "Or logout/login to see all changes take effect."
    echo ""
    echo "Enjoy your optimized GNOME desktop! 🚀"
}

main