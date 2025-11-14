# Atom Dark Color Palette
# Based on the Atom One Dark theme
# This file provides a central source of truth for all theme colors across CLI tools

# ============================================================================
# Base Colors
# ============================================================================
export ATOM_BG="#282c34"                # Background
export ATOM_FG="#abb2bf"                # Foreground
export ATOM_BLACK="#21252b"             # True black
export ATOM_WHITE="#c8ccd4"             # Bright white

# ============================================================================
# ANSI Colors (Normal)
# ============================================================================
export ATOM_COLOR0="#282c34"            # Black
export ATOM_COLOR1="#e06c75"            # Red
export ATOM_COLOR2="#98c379"            # Green
export ATOM_COLOR3="#d19a66"            # Yellow
export ATOM_COLOR4="#61afef"            # Blue
export ATOM_COLOR5="#c678dd"            # Magenta/Purple
export ATOM_COLOR6="#56b6c2"            # Cyan
export ATOM_COLOR7="#abb2bf"            # White

# ============================================================================
# ANSI Colors (Bright)
# ============================================================================
export ATOM_COLOR8="#5c6370"            # Bright Black (Comment Gray)
export ATOM_COLOR9="#e06c75"            # Bright Red
export ATOM_COLOR10="#98c379"           # Bright Green
export ATOM_COLOR11="#e5c07b"           # Bright Yellow
export ATOM_COLOR12="#61afef"           # Bright Blue
export ATOM_COLOR13="#c678dd"           # Bright Magenta
export ATOM_COLOR14="#56b6c2"           # Bright Cyan
export ATOM_COLOR15="#c8ccd4"           # Bright White

# ============================================================================
# Semantic Colors
# ============================================================================
export ATOM_RED="#e06c75"               # Errors, deletions
export ATOM_GREEN="#98c379"             # Success, additions
export ATOM_YELLOW="#d19a66"            # Warnings, changes (normal)
export ATOM_YELLOW_BRIGHT="#e5c07b"     # Warnings, changes (bright)
export ATOM_BLUE="#61afef"              # Info, selection
export ATOM_PURPLE="#c678dd"            # Keywords, special
export ATOM_CYAN="#56b6c2"              # Constants, strings
export ATOM_ORANGE="#d19a66"            # Numbers, built-ins

# ============================================================================
# UI Colors
# ============================================================================
export ATOM_COMMENT="#5c6370"           # Comments, disabled text
export ATOM_SELECTION="#3e4451"         # Visual selection background
export ATOM_CURSOR="#528bff"            # Cursor color
export ATOM_LINE_NUMBER="#4b5263"       # Line number gutter
export ATOM_GUTTER_BG="#282c34"         # Gutter background
export ATOM_STATUS_BG="#21252b"         # Status line background
export ATOM_BORDER="#181a1f"            # Borders, dividers

# ============================================================================
# Syntax Highlighting Colors
# ============================================================================
export ATOM_KEYWORD="#c678dd"           # if, for, class, def
export ATOM_FUNCTION="#61afef"          # Function names
export ATOM_STRING="#98c379"            # Strings
export ATOM_NUMBER="#d19a66"            # Numbers
export ATOM_CONSTANT="#d19a66"          # Constants, booleans
export ATOM_TYPE="#e5c07b"              # Types, classes
export ATOM_OPERATOR="#56b6c2"          # Operators (+, -, =, etc.)
export ATOM_VARIABLE="#e06c75"          # Variables

# ============================================================================
# Git Colors
# ============================================================================
export ATOM_GIT_ADD="#98c379"           # Added lines
export ATOM_GIT_CHANGE="#d19a66"        # Modified lines
export ATOM_GIT_DELETE="#e06c75"        # Deleted lines

# ============================================================================
# Helper Functions
# ============================================================================

# Convert hex to RGB (for tools that need RGB values)
hex_to_rgb() {
    local hex="${1#\#}"
    printf "%d %d %d" 0x"${hex:0:2}" 0x"${hex:2:2}" 0x"${hex:4:2}"
}

# Get color by name
get_atom_color() {
    case "$1" in
        bg|background) echo "$ATOM_BG" ;;
        fg|foreground) echo "$ATOM_FG" ;;
        black) echo "$ATOM_BLACK" ;;
        red) echo "$ATOM_RED" ;;
        green) echo "$ATOM_GREEN" ;;
        yellow) echo "$ATOM_YELLOW" ;;
        blue) echo "$ATOM_BLUE" ;;
        purple|magenta) echo "$ATOM_PURPLE" ;;
        cyan) echo "$ATOM_CYAN" ;;
        white) echo "$ATOM_WHITE" ;;
        comment) echo "$ATOM_COMMENT" ;;
        selection) echo "$ATOM_SELECTION" ;;
        cursor) echo "$ATOM_CURSOR" ;;
        *) echo "$ATOM_FG" ;;
    esac
}

# Export function for use in other scripts
export -f get_atom_color 2>/dev/null || true
