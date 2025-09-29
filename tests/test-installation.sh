#!/usr/bin/env bash
# Comprehensive test suite for dotfiles installation
# Supports both local testing and CI/CD environments

set -euo pipefail

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
    
    if test_output=$($test_function 2>&1); then
        ((TESTS_PASSED++))
        log_success "$test_name"
        [[ -n "$test_output" ]] && log_verbose "Test output: $test_output"
        return 0
    else
        test_exit_code=$?
        ((TESTS_FAILED++))
        FAILED_TESTS+=("$test_name")
        log_error "$test_name (exit code: $test_exit_code)"
        [[ -n "$test_output" ]] && log_error "Test output: $test_output"
        return 0  # Don't propagate the failure to avoid script exit
    fi
}

# Utility functions
command_exists() {
    command -v "$1" >/dev/null 2>&1
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

# Test functions

# Test 1: Essential command availability
test_essential_commands() {
    local essential_commands=(
        "git" "curl" "zsh" "vim" "tmux"
    )
    
    local missing_commands=()
    for cmd in "${essential_commands[@]}"; do
        if ! command_exists "$cmd"; then
            missing_commands+=("$cmd")
        fi
    done
    
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        log_error "Missing essential commands: ${missing_commands[*]}"
        return 1
    fi
    
    return 0
}

# Test 2: Modern CLI tools availability
test_modern_cli_tools() {
    local modern_tools=(
        "fzf" "ripgrep" "fd" "bat" "eza" "htop" "tree"
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
    
    # In CI, we only test setup scripts, not actual dotfiles installation
    if [[ "${CI:-}" == "true" ]]; then
        log_verbose "Skipping symlink checks in CI environment (setup-only tests)"
        log_verbose "Symlink creation requires full dotfiles installation"
        return 0
    fi
    
    local missing_symlinks=()
    for file in "${core_files[@]}"; do
        if ! is_symlink "$file"; then
            missing_symlinks+=("$file")
        fi
    done
    
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
    
    # Test zsh syntax
    if ! zsh -n "$HOME/.zshrc" 2>/dev/null; then
        log_error "Zsh configuration syntax error"
        return 1
    fi
    
    # Check for Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]] && [[ "${DOTFILES_SKIP_INTERACTIVE_MODE}" != "true" ]]; then
        log_warning "Oh My Zsh not installed"
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
    
    # Test vim configuration
    if ! vim -u "$HOME/.vimrc" -c 'syntax on' -c 'quit' >/dev/null 2>&1; then
        log_error "Vim configuration error"
        return 1
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
    
    # Test tmux configuration
    if ! tmux -f "$HOME/.tmux.conf" list-keys >/dev/null 2>&1; then
        log_error "Tmux configuration error"
        return 1
    fi
    
    return 0
}

# Test 8: Git configuration
test_git_config() {
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

# Test 9: Shell plugins and extensions
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
    
    # Test starship configuration
    if ! starship config >/dev/null 2>&1; then
        log_warning "Starship configuration error"
    fi
    
    return 0
}

# Test 11: SSH configuration
test_ssh_config() {
    if [[ -f "$HOME/.ssh/config" ]]; then
        # Test SSH config syntax
        if ! ssh -F "$HOME/.ssh/config" -o BatchMode=yes -o ConnectTimeout=1 -T git@github.com 2>/dev/null; then
            log_verbose "SSH config test completed (expected to fail in CI)"
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
    # Test shell startup time
    local startup_time
    if command_exists "zsh"; then
        startup_time=$(time (zsh -c 'exit') 2>&1 | grep real | awk '{print $2}' || echo "unknown")
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
    else
        log_info "Test environment: Local"
    fi
    log_info "Test directory: $TEST_DIR"
    log_info "Skip interactive mode: ${DOTFILES_SKIP_INTERACTIVE_MODE}"
    log_info "Verbose mode: ${VERBOSE}"
    
    # Core functionality tests
    run_test "Essential Commands" test_essential_commands
    run_test "Modern CLI Tools" test_modern_cli_tools
    run_test "Core Symlinks" test_core_symlinks
    run_test "Config Directories" test_config_directories
    
    # Configuration validity tests
    run_test "Zsh Configuration" test_zsh_config
    run_test "Vim Configuration" test_vim_config
    run_test "Tmux Configuration" test_tmux_config
    run_test "Git Configuration" test_git_config
    
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
    
    # Run tests
    run_all_tests
    
    # Print summary and exit with appropriate code
    print_test_summary
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
