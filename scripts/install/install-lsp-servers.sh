#!/usr/bin/env bash
# Install LSP servers for Neovim via Mason

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

# Check if nvim is installed
if ! command -v nvim &> /dev/null; then
    log_error "Neovim is not installed. Please install it first."
    exit 1
fi

log_info "Installing LSP servers via Mason..."
log_info "This will open Neovim briefly to install the servers..."
echo ""

# Create a temporary Lua script for installation
TEMP_SCRIPT=$(mktemp /tmp/mason-install.XXXXXX.lua)

cat > "$TEMP_SCRIPT" << 'EOF'
-- Auto-install LSP servers via Mason
local servers = {
  "clangd",
  "cmake-language-server",
  "yaml-language-server",
  "dockerfile-language-server",
  "lua-language-server",
  "bash-language-server",
}

-- Wait for Mason to be ready
vim.defer_fn(function()
  local mason_registry = require("mason-registry")

  for _, server_name in ipairs(servers) do
    local ok, package = pcall(mason_registry.get_package, server_name)

    if ok then
      if not package:is_installed() then
        print("Installing: " .. server_name)
        package:install()
      else
        print("Already installed: " .. server_name)
      end
    else
      print("Package not found: " .. server_name)
    end
  end

  -- Wait a bit for installations to start, then exit
  vim.defer_fn(function()
    print("\nLSP server installation initiated!")
    print("Installations will continue in the background.")
    print("You can check status later with :Mason")
    vim.cmd("qall!")
  end, 2000)
end, 500)
EOF

# Run Neovim with the installation script
nvim --headless -c "luafile $TEMP_SCRIPT"

# Clean up
rm -f "$TEMP_SCRIPT"

log_success "LSP server installation completed!"
echo ""
log_info "Installed/Installing the following LSP servers:"
echo "  - clangd (C/C++)"
echo "  - cmake-language-server (CMake)"
echo "  - yaml-language-server (YAML/Kubernetes)"
echo "  - dockerfile-language-server (Docker)"
echo "  - lua-language-server (Lua)"
echo "  - bash-language-server (Bash)"
echo ""
log_info "To verify installations, open Neovim and run: :Mason"
log_info "Press 'i' on any server name to install, 'X' to uninstall"
