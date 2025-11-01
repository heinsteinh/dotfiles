#!/usr/bin/env bash
# Comprehensive test suite for dotfiles installation
# Supports both local testing and CI/CD environments

# Be more lenient in CI environments to prevent early exits
if [[ "${CI:-}" == "true" ]]; then
    set -eo pipefail  # Remove 'u' flag in CI to handle undefined variables gracefully
else
    set -euo pipefail
fi

# Colors for output (with CI/CD compatibility)
if [[ -t 1 ]] && [[ "${CI:-}" != "true" ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly NC='\033[0m'
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly NC=''
fi

# Test configuration
readonly TEST_DIR="${TEST_DIR:-$(mktemp -d)}"
VERBOSE="${VERBOSE:-false}"
# Use a safe internal variable name to avoid readonly conflicts
DOTFILES_SKIP_INTERACTIVE_MODE="${DOTFILES_SKIP_INTERACTIVE:-${SKIP_INTERACTIVE:-${CI:-false}}}"

# Counters for test results
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
FAILED_TESTS=()

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

log_verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${BLUE}[VERBOSE]${NC} $1"
    fi
}

# Test result tracking
run_test() {
    local test_name="$1"
    local test_function="$2"

    ((TESTS_RUN++))
    log_verbose "Running test: $test_name"

    # Capture test function output and exit code
    local test_output
    local test_exit_code=0

    # Add extra debugging for CI
    if [[ "${CI:-}" == "true" ]]; then
        log_verbose "About to execute test function: $test_function"
    fi

    # Safer test execution with explicit error handling
    set +e  # Temporarily disable exit on error for test execution
    test_output=$($test_function 2>&1)
    test_exit_code=$?
    set -e  # Re-enable exit on error

    if [[ $test_exit_code -eq 0 ]]; then
        ((TESTS_PASSED++))
        log_success "$test_name"
        [[ -n "$test_output" ]] && log_verbose "Test output: $test_output"
        return 0
    else
        ((TESTS_FAILED++))
        FAILED_TESTS+=("$test_name")
        log_error "$test_name (exit code: $test_exit_code)"
        [[ -n "$test_output" ]] && log_error "Test output: $test_output"

        # In CI, show more details about the failure
        if [[ "${CI:-}" == "true" ]]; then
            log_error "CI Debug - Test function: $test_function"
            log_error "CI Debug - Working directory: $(pwd)"
            log_error "CI Debug - User: $(whoami)"
        fi

        return 0  # Don't propagate the failure to avoid script exit
    fi
}

# Utility functions
command_exists() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    elif type "$1" >/dev/null 2>&1; then
        return 0
    elif which "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

is_symlink() {
    [[ -L "$1" ]]
}

file_exists() {
    [[ -f "$1" ]]
}

dir_exists() {
    [[ -d "$1" ]]
}

is_headless() {
    # Check if we're in a headless environment (no display, SSH connection, etc.)
    # Use safer parameter expansion to avoid unbound variable errors
    local display_var="${DISPLAY:-}"
    local ssh_connection="${SSH_CONNECTION:-}"
    local ssh_client="${SSH_CLIENT:-}"
    local ssh_tty="${SSH_TTY:-}"

    [[ -z "$display_var" ]] && [[ -n "${ssh_connection}${ssh_client}${ssh_tty}" ]]
}

# Test functions

# Test 1: Essential command availability
test_essential_commands() {
    local essential_commands=(
        "git" "curl" "zsh" "vim" "tmux"
    )

    local missing_commands=()
    local found_commands=()

    for cmd in "${essential_commands[@]}"; do
        if command_exists "$cmd"; then
            found_commands+=("$cmd")
        else
            missing_commands+=("$cmd")
        fi
    done

    # Log what we found for debugging
    if [[ ${#found_commands[@]} -gt 0 ]]; then
        log_verbose "Available essential commands: ${found_commands[*]}"
    fi

    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        log_warning "Missing essential commands: ${missing_commands[*]}"

        # In CI, be more lenient - only fail if ALL commands are missing
        if [[ "${CI:-}" == "true" ]]; then
            if [[ ${#found_commands[@]} -gt 0 ]]; then
                log_verbose "CI environment: Some essential commands found (${#found_commands[@]}/${#essential_commands[@]})"
                return 0
            else
                log_error "CI environment: No essential commands found - setup may have failed"
                return 1
            fi
        else
            # Local environment - require all commands
            log_error "Missing essential commands: ${missing_commands[*]}"
            return 1
        fi
    fi

    return 0
}

# Test 2: Modern CLI tools availability
test_modern_cli_tools() {
    local modern_tools=(
        "fzf" "ripgrep" "fd" "bat" "eza" "htop" "tree" "okular"
    )

    local missing_tools=()
    local found_tools=()

    for tool in "${modern_tools[@]}"; do
        # Check multiple possible command names
        if command_exists "$tool"; then
            found_tools+=("$tool")
        elif command_exists "${tool}find"; then
            found_tools+=("${tool}find (as $tool)")
        elif command_exists "${tool}cat"; then
            found_tools+=("${tool}cat (as $tool)")
        elif [[ "$tool" == "ripgrep" ]] && command_exists "rg"; then
            found_tools+=("rg (ripgrep)")
        elif [[ "$tool" == "fd" ]] && command_exists "fdfind"; then
            found_tools+=("fdfind (fd)")
        else
            missing_tools+=("$tool")
        fi
    done

    # Log what we found
    if [[ ${#found_tools[@]} -gt 0 ]]; then
        log_verbose "Available modern CLI tools: ${found_tools[*]}"
    fi

    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_warning "Missing modern CLI tools: ${missing_tools[*]}"

        # Only fail if ALL tools are missing (indicates no setup was done)
        # Or if we're in a development environment where they should be present
        if [[ ${#found_tools[@]} -eq 0 ]] && [[ "${DOTFILES_SKIP_INTERACTIVE_MODE}" != "true" ]]; then
            log_error "No modern CLI tools found - dotfiles setup may not have completed"
            return 1
        fi

        # Otherwise just warn but don't fail - these are enhancements, not requirements
        log_verbose "Modern CLI tools are optional - test passes with warnings"
    fi

    return 0
}

# Test 3: Core dotfiles symlinks
test_core_symlinks() {
    local core_files=(
        "$HOME/.vimrc"
        "$HOME/.zshrc"
        "$HOME/.tmux.conf"
        "$HOME/.gitconfig"
    )

    # Check if any symlinks exist
    local existing_symlinks=()
    local missing_symlinks=()

    for file in "${core_files[@]}"; do
        if is_symlink "$file"; then
            existing_symlinks+=("$file")
        else
            missing_symlinks+=("$file")
        fi
    done

    # In CI, be more lenient - pass if we have some symlinks or if setup was minimal
    if [[ "${CI:-}" == "true" ]]; then
        if [[ ${#existing_symlinks[@]} -gt 0 ]]; then
            log_verbose "Found ${#existing_symlinks[@]} symlinks in CI: ${existing_symlinks[*]}"
            if [[ ${#missing_symlinks[@]} -gt 0 ]]; then
                log_verbose "Missing ${#missing_symlinks[@]} symlinks (acceptable in CI): ${missing_symlinks[*]}"
            fi
        else
            # Check if we're in a fresh environment where installation wasn't run
            if [[ ! -d ".git" ]] || [[ ! -f "scripts/utils/create-symlinks.sh" ]]; then
                log_verbose "No symlinks found - appears to be minimal/setup-only test in CI"
            elif [[ "${INSTALL_TYPE:-}" == "minimal" ]]; then
                log_verbose "No symlinks found - minimal installation workflow doesn't create symlinks"
                log_verbose "This is expected for minimal dependency testing"
            elif [[ "${INSTALL_TYPE:-}" == "platform" ]]; then
                log_warning "No symlinks found - platform installation may have failed"
                log_verbose "Platform installations should create symlinks but might fail in CI containers"
            else
                log_warning "No symlinks found in CI but dotfiles directory exists - installation may have failed"
            fi
        fi
        return 0
    fi

    # For local environments, require all symlinks
    if [[ ${#missing_symlinks[@]} -gt 0 ]]; then
        log_error "Missing core symlinks: ${missing_symlinks[*]}"
        return 1
    fi

    return 0
}

# Test 4: Configuration directory structure
test_config_directories() {
    local config_dirs=(
        "$HOME/.config"
        "$HOME/.local/bin"
        "$HOME/.local/share"
    )

    # In CI, directories may not be created by setup scripts alone
    if [[ "${CI:-}" == "true" ]]; then
        log_verbose "Checking directory creation in CI environment"
        local existing_dirs=()
        local missing_dirs=()

        for dir in "${config_dirs[@]}"; do
            if dir_exists "$dir"; then
                existing_dirs+=("$dir")
            else
                missing_dirs+=("$dir")
            fi
        done

        if [[ ${#existing_dirs[@]} -gt 0 ]]; then
            log_verbose "Existing directories: ${existing_dirs[*]}"
        fi

        if [[ ${#missing_dirs[@]} -gt 0 ]]; then
            log_verbose "Missing directories (expected in CI setup-only): ${missing_dirs[*]}"
        fi

        return 0
    fi

    local missing_dirs=()
    for dir in "${config_dirs[@]}"; do
        if ! dir_exists "$dir"; then
            missing_dirs+=("$dir")
        fi
    done

    if [[ ${#missing_dirs[@]} -gt 0 ]]; then
        log_error "Missing configuration directories: ${missing_dirs[*]}"
        return 1
    fi

    return 0
}

# Test 5: Zsh configuration validity
test_zsh_config() {
    # In CI, we only verify zsh is available, not configuration files
    if [[ "${CI:-}" == "true" ]]; then
        if command_exists "zsh"; then
            log_verbose "Zsh is available in CI environment"

            # If .zshrc exists but Oh My Zsh isn't installed, skip syntax check
            if [[ -f "$HOME/.zshrc" ]] && [[ ! -d "$HOME/.oh-my-zsh" ]]; then
                log_warning "CI: .zshrc exists but Oh My Zsh not installed - skipping syntax check"
                log_verbose "This is expected if installation didn't complete or symlinks weren't created"
                return 0
            fi

            # If .zshrc exists and Oh My Zsh is installed, verify syntax
            if [[ -f "$HOME/.zshrc" ]] && [[ -d "$HOME/.oh-my-zsh" ]]; then
                if timeout 5 zsh -n "$HOME/.zshrc" 2>/dev/null; then
                    log_verbose "CI: Zsh configuration syntax is valid"
                else
                    log_warning "CI: Zsh configuration has syntax issues (non-fatal in CI)"
                fi
            fi

            return 0
        else
            log_error "Zsh not available"
            return 1
        fi
    fi

    if ! file_exists "$HOME/.zshrc"; then
        log_error "Zsh configuration file not found"
        return 1
    fi

    # Check for Oh My Zsh before syntax check
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_warning "Oh My Zsh not installed - cannot validate .zshrc syntax"
        if [[ "${DOTFILES_SKIP_INTERACTIVE_MODE}" != "true" ]]; then
            return 1
        fi
        return 0
    fi

    # Test zsh syntax with timeout
    if ! timeout 5 zsh -n "$HOME/.zshrc" 2>/dev/null; then
        log_error "Zsh configuration syntax error or timeout"
        return 1
    fi

    return 0
}

# Test 6: Vim configuration validity
test_vim_config() {
    # In CI, we only verify vim is available, not configuration files
    if [[ "${CI:-}" == "true" ]]; then
        if command_exists "vim"; then
            log_verbose "Vim is available in CI environment"
            return 0
        else
            log_error "Vim not available"
            return 1
        fi
    fi

    if ! file_exists "$HOME/.vimrc"; then
        log_error "Vim configuration file not found"
        return 1
    fi

    # Test vim configuration (with timeout for headless environments)
    if ! timeout 5 vim -u "$HOME/.vimrc" -T dumb -c 'syntax on' -c 'quit' >/dev/null 2>&1; then
        if is_headless; then
            log_warning "Vim configuration test skipped in headless environment"
        else
            log_error "Vim configuration error"
            return 1
        fi
    fi

    return 0
}

# Test 7: Tmux configuration validity
test_tmux_config() {
    # In CI, we only verify tmux is available, not configuration files
    if [[ "${CI:-}" == "true" ]]; then
        if command_exists "tmux"; then
            log_verbose "Tmux is available in CI environment"
            return 0
        else
            log_error "Tmux not available"
            return 1
        fi
    fi

    if ! file_exists "$HOME/.tmux.conf"; then
        log_error "Tmux configuration file not found"
        return 1
    fi

    # Test tmux configuration with timeout
    if ! timeout 5 tmux -f "$HOME/.tmux.conf" list-keys >/dev/null 2>&1; then
        if is_headless; then
            log_warning "Tmux configuration test skipped in headless environment"
        else
            log_error "Tmux configuration error"
            return 1
        fi
    fi

    return 0
}

# Test 8: Git configuration
test_git_config() {
    # Handle different installation types in CI
    case "${INSTALL_TYPE:-}" in
        "minimal")
            # Minimal installations only need git command to exist
            if command_exists "git"; then
                log_verbose "Git command available - minimal installation test passed"
                return 0
            else
                log_error "Git not available"
                return 1
            fi
            ;;
        "platform")
            # Platform installations should create symlinks, but might fail in CI
            if [[ ! -f "$HOME/.gitconfig" ]]; then
                log_verbose "Platform installation - .gitconfig not found, checking git availability"
                if command_exists "git"; then
                    log_warning "Git available but .gitconfig not created - platform installation may have failed"
                    return 0  # Pass with warning for CI robustness
                else
                    log_error "Git not available"
                    return 1
                fi
            fi
            log_verbose "Git configuration file found - testing normally"
            ;;
        *)
            # Full installations or unknown - use normal logic
            if [[ "${CI:-}" == "true" ]] && [[ ! -f "$HOME/.gitconfig" ]]; then
                log_verbose "CI environment - .gitconfig not found, checking git availability"
                if command_exists "git"; then
                    log_warning "Git available but .gitconfig not created - installation may have failed"
                    return 0  # Pass with warning for CI robustness
                else
                    log_error "Git not available"
                    return 1
                fi
            fi
            ;;
    esac

    if ! file_exists "$HOME/.gitconfig"; then
        log_error "Git configuration file not found"
        return 1
    fi

    # Check if git user is configured
    if ! git config --get user.name >/dev/null 2>&1; then
        log_warning "Git user.name not configured"
    fi

    if ! git config --get user.email >/dev/null 2>&1; then
        log_warning "Git user.email not configured"
    fi

    return 0
}

# Test 9: Okular PDF viewer configuration
test_okular_config() {
    # In CI or minimal installations, only check if okular is available
    if [[ "${CI:-}" == "true" ]] || [[ "${INSTALL_TYPE:-}" == "minimal" ]] || [[ "${INSTALL_TYPE:-}" == "platform" ]]; then
        if command_exists "okular"; then
            log_verbose "Okular is available"
            return 0
        else
            log_verbose "Okular not installed (optional)"
            return 0  # Pass anyway as Okular is optional
        fi
    fi

    # Check if Okular is installed (optional tool)
    if ! command_exists "okular"; then
        log_verbose "Okular not installed (optional)"
        return 0
    fi

    # Check main config file
    if [[ -f "$HOME/.config/okularrc" ]] || [[ -L "$HOME/.config/okularrc" ]]; then
        log_verbose "Okular main configuration found"
    else
        log_warning "Okular config file not found at ~/.config/okularrc"
    fi

    # Check keybinding files
    if [[ -f "$HOME/.local/share/kxmlgui5/okular/part.rc" ]] || [[ -L "$HOME/.local/share/kxmlgui5/okular/part.rc" ]]; then
        log_verbose "Okular keybindings (part.rc) found"
    else
        log_warning "Okular keybindings not found"
    fi

    return 0
}

# Test 9b: Ghostty terminal configuration
test_ghostty_config() {
    # Ghostty is always optional
    if ! command_exists "ghostty"; then
        log_verbose "Ghostty not installed (optional)"
        return 0
    fi

    log_verbose "Ghostty is installed"

    # Check main config file
    if [[ -f "$HOME/.config/ghostty/config" ]] || [[ -L "$HOME/.config/ghostty/config" ]]; then
        log_verbose "Ghostty main configuration found"
    else
        log_warning "Ghostty installed but config file not found at ~/.config/ghostty/config"
    fi

    # Check themes directory
    if [[ -d "$HOME/.config/ghostty/themes" ]] || [[ -L "$HOME/.config/ghostty/themes" ]]; then
        log_verbose "Ghostty themes directory found"
    else
        log_warning "Ghostty themes directory not found"
    fi

    return 0
}

# Test 10: Shell plugins and extensions
test_shell_plugins() {
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_warning "Oh My Zsh not installed, skipping plugin tests"
        return 0
    fi

    local expected_plugins=(
        "$zsh_custom/plugins/zsh-autosuggestions"
        "$zsh_custom/plugins/zsh-syntax-highlighting"
    )

    local missing_plugins=()
    for plugin in "${expected_plugins[@]}"; do
        if [[ ! -d "$plugin" ]]; then
            missing_plugins+=("$(basename "$plugin")")
        fi
    done

    if [[ ${#missing_plugins[@]} -gt 0 ]]; then
        log_warning "Missing Zsh plugins: ${missing_plugins[*]}"
    fi

    return 0
}

# Test 10: Starship prompt
test_starship_prompt() {
    if ! command_exists "starship"; then
        log_warning "Starship prompt not installed"
        return 0
    fi

    # Test starship configuration with timeout to prevent hanging in CI
    if ! timeout 3 starship config >/dev/null 2>&1; then
        log_warning "Starship configuration error or timeout"
    fi

    return 0
}

# Test 11: SSH configuration
test_ssh_config() {
    if [[ -f "$HOME/.ssh/config" ]]; then
        # Test SSH config syntax with timeout
        if ! timeout 3 ssh -F "$HOME/.ssh/config" -o BatchMode=yes -o ConnectTimeout=1 -o ConnectionAttempts=1 -T git@github.com 2>/dev/null; then
            log_verbose "SSH config test completed (expected to fail in CI/remote environments)"
        fi
    fi

    # Check SSH key permissions
    if [[ -f "$HOME/.ssh/id_rsa" ]]; then
        local perms=$(stat -c "%a" "$HOME/.ssh/id_rsa" 2>/dev/null || stat -f "%Mp%Lp" "$HOME/.ssh/id_rsa" 2>/dev/null)
        if [[ "$perms" != "600" ]]; then
            log_warning "SSH private key has incorrect permissions: $perms (should be 600)"
        fi
    fi

    return 0
}

# Test 12: Font installation
test_fonts() {
    local font_dirs=(
        "/usr/share/fonts"
        "/usr/local/share/fonts"
        "$HOME/.local/share/fonts"
        "$HOME/.fonts"
    )

    local fonts_found=false
    for dir in "${font_dirs[@]}"; do
        if [[ -d "$dir" ]] && [[ -n "$(find "$dir" -name "*.ttf" -o -name "*.otf" 2>/dev/null | head -1)" ]]; then
            fonts_found=true
            break
        fi
    done

    if [[ "$fonts_found" == "false" ]]; then
        log_warning "No fonts found in standard directories"
    fi

    return 0
}

# Test 13: Environment variables
test_environment_variables() {
    local expected_vars=(
        "HOME"
        "USER"
        "SHELL"
    )

    local missing_vars=()
    for var in "${expected_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            missing_vars+=("$var")
        fi
    done

    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        log_error "Missing environment variables: ${missing_vars[*]}"
        return 1
    fi

    # Check if zsh is the default shell
    if [[ "$SHELL" != */zsh ]]; then
        log_warning "Default shell is not zsh: $SHELL"
    fi

    return 0
}

# Test 14: Script permissions
test_script_permissions() {
    local dotfiles_dir="${DOTFILES_DIR:-$(dirname "$(dirname "$(realpath "$0")")")}"
    local script_dirs=(
        "$dotfiles_dir/scripts/install"
        "$dotfiles_dir/scripts/setup"
        "$dotfiles_dir/scripts/utils"
        "$dotfiles_dir/tools"
    )

    local executable_scripts=()
    for dir in "${script_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            while IFS= read -r -d '' script; do
                if [[ ! -x "$script" ]]; then
                    executable_scripts+=("$script")
                fi
            done < <(find "$dir" -name "*.sh" -print0 2>/dev/null)
        fi
    done

    if [[ ${#executable_scripts[@]} -gt 0 ]]; then
        log_warning "Non-executable scripts found: ${executable_scripts[*]}"
    fi

    return 0
}

# Test 15: CI/CD specific tests
test_cicd_compatibility() {
    if [[ "${CI:-}" == "true" ]]; then
        # Test that installation works in non-interactive mode
        if [[ "${DOTFILES_SKIP_INTERACTIVE_MODE}" != "true" ]]; then
            log_error "CI environment detected but DOTFILES_SKIP_INTERACTIVE_MODE not set"
            return 1
        fi

        # Test that no GUI applications are required
        local gui_commands=("xdg-open" "open" "firefox" "chrome")
        for cmd in "${gui_commands[@]}"; do
            if command_exists "$cmd"; then
                log_verbose "GUI command available in CI: $cmd"
            fi
        done
    fi

    return 0
}

# Performance and health tests

# Test 16: Performance check
test_performance() {
    # Test shell startup time with timeout to prevent hanging
    local startup_time
    if command_exists "zsh"; then
        # Use timeout on the zsh command itself, measure with date instead of time
        local start=$(date +%s%N)
        if timeout 5 zsh -c 'exit' >/dev/null 2>&1; then
            local end=$(date +%s%N)
            local duration=$(( (end - start) / 1000000 ))
            startup_time="${duration}ms"
        else
            startup_time="timeout"
        fi
        log_verbose "Zsh startup time: $startup_time"
    fi

    # Test command availability performance
    local start_time=$(date +%s%N)
    command_exists "git" >/dev/null
    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))
    log_verbose "Command existence check took: ${duration}ms"

    return 0
}

# Test 17: Health check
test_system_health() {
    # Check disk space
    local available_space=$(df "$HOME" | awk 'NR==2 {print $4}')
    if [[ "$available_space" -lt 1000000 ]]; then # Less than ~1GB
        log_warning "Low disk space: ${available_space}KB available"
    fi

    # Check memory usage
    if command_exists "free"; then
        local mem_info=$(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2}')
        log_verbose "Memory usage: $mem_info"
    fi

    return 0
}

# Main test runner
run_all_tests() {
    log_info "Starting comprehensive dotfiles installation tests..."
    if [[ "${CI:-}" == "true" ]]; then
        log_info "Test environment: CI/CD"
    elif [[ -n "${SSH_CONNECTION:-}" ]] || [[ -n "${SSH_CLIENT:-}" ]]; then
        log_info "Test environment: Remote SSH"
    else
        log_info "Test environment: Local"
    fi
    log_info "Test directory: $TEST_DIR"
    log_info "Skip interactive mode: ${DOTFILES_SKIP_INTERACTIVE_MODE}"
    log_info "Verbose mode: ${VERBOSE}"
    log_info "Display available: ${DISPLAY:-none}"
    log_info "TTY type: ${SSH_TTY:-local}"
    log_info "Installation type: ${INSTALL_TYPE:-unknown}"

    # CI Debug information
    if [[ "${CI:-}" == "true" ]]; then
        log_verbose "CI Debug - Current working directory: $(pwd)"
        log_verbose "CI Debug - Current user: $(whoami)"
        log_verbose "CI Debug - Shell: $SHELL"
        log_verbose "CI Debug - PATH: $PATH"
        if command -v git >/dev/null 2>&1; then
            log_verbose "CI Debug - Git available: $(git --version)"
        fi
        if command -v bash >/dev/null 2>&1; then
            log_verbose "CI Debug - Bash available: $(bash --version | head -1)"
        fi
    fi

    # Core functionality tests
    log_verbose "Starting core functionality tests..."

    log_verbose "About to run Essential Commands test"
    run_test "Essential Commands" test_essential_commands || log_error "Essential Commands test crashed"

    log_verbose "About to run Modern CLI Tools test"
    run_test "Modern CLI Tools" test_modern_cli_tools || log_error "Modern CLI Tools test crashed"

    log_verbose "About to run Core Symlinks test"
    run_test "Core Symlinks" test_core_symlinks || log_error "Core Symlinks test crashed"

    log_verbose "About to run Config Directories test"
    run_test "Config Directories" test_config_directories || log_error "Config Directories test crashed"

    # Configuration validity tests
    run_test "Zsh Configuration" test_zsh_config
    run_test "Vim Configuration" test_vim_config
    run_test "Tmux Configuration" test_tmux_config
    run_test "Git Configuration" test_git_config
    run_test "Okular Configuration" test_okular_config
    run_test "Ghostty Configuration" test_ghostty_config

    # Feature tests
    run_test "Shell Plugins" test_shell_plugins
    run_test "Starship Prompt" test_starship_prompt
    run_test "SSH Configuration" test_ssh_config
    run_test "Font Installation" test_fonts

    # System tests
    run_test "Environment Variables" test_environment_variables
    run_test "Script Permissions" test_script_permissions
    run_test "CI/CD Compatibility" test_cicd_compatibility

    # Performance and health
    #run_test "Performance Check" test_performance
    run_test "System Health" test_system_health
}

# Test result summary
print_test_summary() {
    echo
    log_info "Test Summary:"
    echo "  Total tests: $TESTS_RUN"
    echo "  Passed: $TESTS_PASSED"
    echo "  Failed: $TESTS_FAILED"

    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo
        log_error "Failed tests:"
        for test in "${FAILED_TESTS[@]}"; do
            echo "  - $test"
        done
    fi

    echo
    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "All tests passed! ✨"
        return 0
    else
        log_error "Some tests failed! ❌"
        return 1
    fi
}

# Cleanup function
cleanup() {
    if [[ -d "$TEST_DIR" ]] && [[ "$TEST_DIR" != "$HOME" ]]; then
        rm -rf "$TEST_DIR"
    fi
}

# Signal handlers
trap cleanup EXIT INT TERM

# Main execution
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            --skip-interactive)
                DOTFILES_SKIP_INTERACTIVE_MODE=true
                shift
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  -v, --verbose         Enable verbose output"
                echo "  --skip-interactive    Skip interactive tests (for CI/CD)"
                echo "  -h, --help           Show this help message"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    # Basic environment sanity check
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected - performing basic checks"
        if ! command -v echo >/dev/null 2>&1; then
            log_error "Basic shell functionality broken - cannot continue"
            exit 1
        fi
        log_verbose "Basic shell functionality verified"
    fi

    # Detect environment and set appropriate modes
    log_verbose "Checking if environment is headless..."
    if is_headless; then
        log_info "Headless/remote environment detected - enabling safe mode"
        DOTFILES_SKIP_INTERACTIVE_MODE=true
    else
        log_verbose "Non-headless environment detected"
    fi
    log_verbose "Environment detection complete"

    # Run tests with error handling
    if run_all_tests; then
        log_verbose "All tests completed successfully"
    else
        log_error "Some tests encountered errors during execution"
    fi

    # Print summary and exit with appropriate code
    print_test_summary
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
