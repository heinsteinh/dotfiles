#!/usr/bin/env bash
# Test CI environment detection

set -euo pipefail

echo "=== CI Environment Detection Test ==="
echo "CI variable: ${CI:-not set}"
echo "DOTFILES_CI_MODE variable: ${DOTFILES_CI_MODE:-not set}"
echo "GITHUB_ACTIONS variable: ${GITHUB_ACTIONS:-not set}"
echo "Current user: $(whoami)"
echo "Current shell: $SHELL"
echo "Home directory: $HOME"

# Test CI detection logic
if [[ "${CI:-}" == "true" ]] || [[ "${DOTFILES_CI_MODE:-}" == "true" ]]; then
    echo "✅ CI environment detected"
    echo "Shell change would be skipped"
    echo "AUR helper installation would be skipped"
else
    echo "❌ CI environment NOT detected"
    echo "Shell change would be attempted"
    echo "AUR helper installation would proceed"
fi

echo "=== End Test ==="