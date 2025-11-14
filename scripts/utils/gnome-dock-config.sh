#!/bin/bash
# Configure GNOME Dock to look modern and clean
# Works with both Dash to Dock and Ubuntu Dock

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_section() {
    echo -e "\n${BLUE}═══${NC} $1 ${BLUE}═══${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

echo "=========================================="
echo "GNOME Dock - Modern Configuration"
echo "=========================================="
echo ""

# Detect which dock extension is available
detect_dock() {
    print_section "Detecting Dock Extension"
    
    # Check for Dash to Dock
    if gsettings list-schemas | grep -q "org.gnome.shell.extensions.dash-to-dock"; then
        DOCK_TYPE="dash-to-dock"
        print_status "Found: Dash to Dock"
        return 0
    fi
    
    # Check for Ubuntu Dock
    if gsettings list-schemas | grep -q "org.gnome.shell.extensions.ubuntu-dock"; then
        DOCK_TYPE="ubuntu-dock"
        print_status "Found: Ubuntu Dock"
        return 0
    fi
    
    # Check for Dash to Panel
    if gsettings list-schemas | grep -q "org.gnome.shell.extensions.dash-to-panel"; then
        DOCK_TYPE="dash-to-panel"
        print_status "Found: Dash to Panel"
        return 0
    fi
    
    # No dock extension found - use built-in dash
    print_warning "No dock extension found"
    echo ""
    echo "Let me install Dash to Dock for you..."
    install_dash_to_dock
}

# Install Dash to Dock
install_dash_to_dock() {
    print_section "Installing Dash to Dock"
    
    echo "Installing via pacman..."
    sudo pacman -S --needed gnome-shell-extension-dash-to-dock
    
    echo "Enabling extension..."
    gnome-extensions enable dash-to-dock@micxgx.gmail.com
    
    DOCK_TYPE="dash-to-dock"
    print_status "Dash to Dock installed and enabled"
    
    echo ""
    echo "Please restart GNOME Shell:"
    echo "  Press Alt+F2, type 'r', press Enter"
    echo "  Then run this script again"
    exit 0
}

# Configure Dash to Dock
configure_dash_to_dock() {
    print_section "Configuring Dash to Dock - Modern Style"
    
    local SCHEMA="org.gnome.shell.extensions.dash-to-dock"
    
    # Position
    gsettings set $SCHEMA dock-position 'BOTTOM'
    gsettings set $SCHEMA extend-height false
    print_status "Position: Bottom, full width"
    
    # Size and appearance
    gsettings set $SCHEMA dash-max-icon-size 48
    gsettings set $SCHEMA icon-size-fixed true
    print_status "Icon size: 48px"
    
    # Behavior
    gsettings set $SCHEMA dock-fixed false
    gsettings set $SCHEMA autohide true
    gsettings set $SCHEMA intellihide true
    gsettings set $SCHEMA intellihide-mode 'FOCUS_APPLICATION_WINDOWS'
    print_status "Intelligent auto-hide enabled"
    
    # Animation
    gsettings set $SCHEMA animation-time 0.2
    gsettings set $SCHEMA hide-delay 0.2
    gsettings set $SCHEMA show-delay 0.2
    print_status "Fast animations"
    
    # Transparency
    gsettings set $SCHEMA transparency-mode 'DYNAMIC'
    gsettings set $SCHEMA background-opacity 0.7
    gsettings set $SCHEMA customize-alphas true
    gsettings set $SCHEMA min-alpha 0.4
    gsettings set $SCHEMA max-alpha 0.9
    print_status "Dynamic transparency"
    
    # Style
    gsettings set $SCHEMA apply-custom-theme false
    gsettings set $SCHEMA custom-theme-shrink true
    gsettings set $SCHEMA running-indicator-style 'DOTS'
    gsettings set $SCHEMA running-indicator-dominant-color false
    print_status "Modern indicators (dots)"
    
    # Click behavior
    gsettings set $SCHEMA click-action 'minimize'
    gsettings set $SCHEMA scroll-action 'cycle-windows'
    gsettings set $SCHEMA shift-click-action 'minimize'
    gsettings set $SCHEMA middle-click-action 'launch'
    print_status "Smart click behavior"
    
    # Apps button
    gsettings set $SCHEMA show-apps-at-top false
    gsettings set $SCHEMA show-show-apps-button true
    gsettings set $SCHEMA show-apps-button-position 'start'
    print_status "Apps button at start"
    
    # Windows preview
    gsettings set $SCHEMA peek-mode true
    gsettings set $SCHEMA show-windows-preview true
    print_status "Window previews enabled"
    
    # Show favorites and running
    gsettings set $SCHEMA show-favorites true
    gsettings set $SCHEMA show-running true
    gsettings set $SCHEMA isolate-workspaces false
    gsettings set $SCHEMA isolate-monitors false
    print_status "Show all apps across workspaces"
    
    # Hot keys
    gsettings set $SCHEMA hot-keys true
    gsettings set $SCHEMA hotkeys-overlay true
    gsettings set $SCHEMA hotkeys-show-dock true
    print_status "Hotkeys: Super+1,2,3... enabled"
    
    # Multi-monitor
    gsettings set $SCHEMA multi-monitor true
    gsettings set $SCHEMA preferred-monitor -2
    
    # Misc
    gsettings set $SCHEMA show-mounts false
    gsettings set $SCHEMA show-trash false
    gsettings set $SCHEMA disable-overview-on-startup false
    
    # Panel integration
    gsettings set $SCHEMA customize-panel true
    gsettings set $SCHEMA show-activities-button false
    print_status "Clean panel (no Activities button)"
}

# Configure Ubuntu Dock
configure_ubuntu_dock() {
    print_section "Configuring Ubuntu Dock - Modern Style"
    
    local SCHEMA="org.gnome.shell.extensions.ubuntu-dock"
    
    # Position
    gsettings set $SCHEMA dock-position 'BOTTOM'
    gsettings set $SCHEMA extend-height false
    print_status "Position: Bottom"
    
    # Size
    gsettings set $SCHEMA dash-max-icon-size 48
    print_status "Icon size: 48px"
    
    # Behavior
    gsettings set $SCHEMA dock-fixed false
    gsettings set $SCHEMA autohide true
    gsettings set $SCHEMA intellihide true
    gsettings set $SCHEMA intellihide-mode 'FOCUS_APPLICATION_WINDOWS'
    print_status "Intelligent auto-hide enabled"
    
    # Transparency
    gsettings set $SCHEMA transparency-mode 'DYNAMIC'
    gsettings set $SCHEMA background-opacity 0.7
    print_status "Dynamic transparency"
    
    # Click behavior
    gsettings set $SCHEMA click-action 'minimize'
    print_status "Click to minimize"
    
    # Show favorites and running
    gsettings set $SCHEMA show-favorites true
    gsettings set $SCHEMA show-running true
    print_status "Show favorites and running apps"
}

# Set favorite apps
set_favorites() {
    print_section "Setting Up Favorite Apps"
    
    # Clean, developer-focused favorites
    gsettings set org.gnome.shell favorite-apps "[
        'org.gnome.Nautilus.desktop',
        'org.gnome.Terminal.desktop',
        'firefox.desktop',
        'org.gnome.TextEditor.desktop',
        'org.gnome.Settings.desktop'
    ]"
    
    print_status "Favorites configured"
}

# Optimize panel
optimize_panel() {
    print_section "Optimizing Top Panel"
    
    # Clock settings
    gsettings set org.gnome.desktop.interface clock-show-weekday true
    gsettings set org.gnome.desktop.interface clock-show-seconds false
    print_status "Clock: Show weekday"
    
    # Show battery percentage
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    print_status "Battery percentage visible"
}

# Main execution
main() {
    detect_dock
    
    case $DOCK_TYPE in
        "dash-to-dock")
            configure_dash_to_dock
            ;;
        "ubuntu-dock")
            configure_ubuntu_dock
            ;;
        "dash-to-panel")
            print_warning "Dash to Panel detected - skipping dock config"
            echo "Dash to Panel uses different settings. Configure via its own settings."
            exit 0
            ;;
    esac
    
    set_favorites
    optimize_panel
    
    print_section "Configuration Complete! ✨"
    echo ""
    echo "Your dock is now configured with:"
    echo "  • Modern, clean appearance"
    echo "  • Intelligent auto-hide (shows when needed)"
    echo "  • Dynamic transparency"
    echo "  • Fast, smooth animations"
    echo "  • Icon size: 48px"
    echo "  • Position: Bottom of screen"
    echo "  • Click to minimize behavior"
    echo "  • Window previews on hover"
    echo "  • Super+1,2,3... hotkeys for apps"
    echo ""
    echo "To see changes immediately:"
    echo "  Press Alt+F2, type 'r', press Enter"
    echo ""
    echo "To customize further:"
    echo "  Right-click the dock → Settings"
    echo ""
    echo "Enjoy your clean, modern dock! 🚀"
}

main