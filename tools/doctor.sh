#!/usr/bin/env bash
# Comprehensive health check and validation script for dotfiles

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Counters
ISSUES_FOUND=0
WARNINGS_FOUND=0
CHECKS_PASSED=0

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; ((CHECKS_PASSED++)); }
log_warning() { echo -e "${YELLOW}[⚠]${NC} $1"; ((WARNINGS_FOUND++)); }
log_error() { echo -e "${RED}[✗]${NC} $1"; ((ISSUES_FOUND++)); }
log_check() { echo -e "${PURPLE}[CHECK]${NC} $1"; }

# Header
print_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════╗
║                                                  ║
║             🔍 Dotfiles Health Check             ║
║                                                  ║
╚══════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Check file existence
check_file_exists() {
    local file="$1"
    local description="$2"

    if [[ -f "$file" ]]; then
        log_success "$description exists"
        return 0
    else
        log_error "$description missing: $file"
        return 1
    fi
}

# Check directory existence
check_dir_exists() {
    local dir="$1"
    local description="$2"

    if [[ -d "$dir" ]]; then
        log_success "$description exists"
        return 0
    else
        log_error "$description missing: $dir"
        return 1
    fi
}

# Check script syntax
check_script_syntax() {
    local script="$1"
    local name="$(basename "$script")"

    if [[ ! -f "$script" ]]; then
        log_error "Script not found: $script"
        return 1
    fi

    if [[ ! -x "$script" ]]; then
        log_warning "Script not executable: $name"
    fi

    # Check shebang
    local shebang
    shebang=$(head -1 "$script")
    if [[ ! "$shebang" =~ ^#!/ ]]; then
        log_error "Missing or invalid shebang in: $name"
        return 1
    fi

    # Basic syntax check for bash scripts
    if [[ "$shebang" =~ bash|sh ]]; then
        if bash -n "$script" 2>/dev/null; then
            log_success "Syntax check passed: $name"
        else
            log_error "Syntax error in: $name"
            return 1
        fi
    fi

    return 0
}

# Check configuration file syntax
check_config_syntax() {
    local config="$1"
    local type="$2"
    local name="$(basename "$config")"

    if [[ ! -f "$config" ]]; then
        return 1
    fi

    case "$type" in
        "toml")
            if command -v toml-test &> /dev/null; then
                if toml-test "$config" &> /dev/null; then
                    log_success "TOML syntax valid: $name"
                else
                    log_error "TOML syntax error: $name"
                    return 1
                fi
            else
                log_warning "toml-test not available, skipping TOML validation"
            fi
            ;;
        "yaml"|"yml")
            if command -v yamllint &> /dev/null; then
                if yamllint "$config" &> /dev/null; then
                    log_success "YAML syntax valid: $name"
                else
                    log_error "YAML syntax error: $name"
                    return 1
                fi
            elif python3 -c "import yaml" 2>/dev/null; then
                if python3 -c "import yaml; yaml.safe_load(open('$config'))" 2>/dev/null; then
                    log_success "YAML syntax valid: $name"
                else
                    log_error "YAML syntax error: $name"
                    return 1
                fi
            else
                log_warning "No YAML validator available, skipping validation"
            fi
            ;;
        "json")
            if command -v jq &> /dev/null; then
                if jq . "$config" &> /dev/null; then
                    log_success "JSON syntax valid: $name"
                else
                    log_error "JSON syntax error: $name"
                    return 1
                fi
            elif python3 -c "import json" 2>/dev/null; then
                if python3 -c "import json; json.load(open('$config'))" 2>/dev/null; then
                    log_success "JSON syntax valid: $name"
                else
                    log_error "JSON syntax error: $name"
                    return 1
                fi
            else
                log_warning "No JSON validator available, skipping validation"
            fi
            ;;
    esac

    return 0
}

# Check for duplicate files
check_duplicates() {
    log_check "Checking for duplicate or conflicting files..."

    # Check for README duplicates
    if [[ -f "$DOTFILES_DIR/README.md" ]] && [[ -f "$DOTFILES_DIR/README copy.md" ]]; then
        log_warning "Duplicate README files found (README.md and 'README copy.md')"
    fi

    # Check for backup files that shouldn't be committed
    while IFS= read -r -d '' file; do
        log_warning "Backup file found: $(basename "$file")"
    done < <(find "$DOTFILES_DIR" -name "*.bak" -o -name "*.backup" -o -name "*~" -print0 2>/dev/null || true)
}

# Check symlink targets
check_symlinks() {
    log_check "Checking symlink configurations..."

    local symlink_script="$DOTFILES_DIR/scripts/utils/create-symlinks.sh"
    if [[ -f "$symlink_script" ]]; then
        # Extract symlink mappings and validate source files exist
        while IFS= read -r line; do
            if [[ "$line" =~ ln.*-sf.*\"(.*)\".*\"(.*)\" ]]; then
                local source="${BASH_REMATCH[1]}"
                local target="${BASH_REMATCH[2]}"

                # Expand variables in source path
                source="${source/#\$DOTFILES_DIR/$DOTFILES_DIR}"
                source="${source/#\$HOME/$HOME}"

                if [[ ! -e "$source" ]]; then
                    log_error "Symlink source missing: $source"
                fi
            fi
        done < "$symlink_script"
    fi
}

# Check dependencies
check_dependencies() {
    log_check "Checking for common dependencies..."

    local tools=(
        "git:Git version control"
        "zsh:Z shell"
        "vim:Vim editor"
        "tmux:Terminal multiplexer"
        "curl:Data transfer tool"
        "wget:File downloader"
    )

    for tool_desc in "${tools[@]}"; do
        IFS=':' read -r tool desc <<< "$tool_desc"
        if command -v "$tool" &> /dev/null; then
            log_success "$desc available"
        else
            log_warning "$desc not installed"
        fi
    done

    # Check optional modern tools
    local modern_tools=(
        "exa:Modern ls replacement"
        "bat:Enhanced cat"
        "ripgrep:Fast text search (rg)"
        "fd:Modern find replacement"
        "fzf:Fuzzy finder"
        "starship:Cross-shell prompt"
    )

    for tool_desc in "${modern_tools[@]}"; do
        IFS=':' read -r tool desc <<< "$tool_desc"
        if command -v "$tool" &> /dev/null; then
            log_success "$desc available"
        else
            log_info "$desc not installed (optional)"
        fi
    done
}

# Check OS-specific configurations
check_os_support() {
    log_check "Checking OS-specific configurations..."

    local current_os
    case "$(uname -s)" in
        Darwin) current_os="macos" ;;
        Linux)
            if [[ -f /etc/arch-release ]]; then
                current_os="arch"
            elif [[ -f /etc/debian_version ]]; then
                current_os="ubuntu"  # or debian
            elif [[ -f /etc/fedora-release ]]; then
                current_os="fedora"
            else
                current_os="linux"
            fi
            ;;
        *) current_os="unknown" ;;
    esac

    local setup_script="$DOTFILES_DIR/scripts/setup/setup-$current_os.sh"
    if [[ -f "$setup_script" ]]; then
        log_success "OS-specific setup script exists for $current_os"
        check_script_syntax "$setup_script"
    else
        log_warning "No OS-specific setup script for $current_os"
    fi

    # Check distro-specific zsh configs
    local distro_config="$DOTFILES_DIR/config/zsh/distro/$current_os.zsh"
    if [[ -f "$distro_config" ]]; then
        log_success "OS-specific zsh config exists for $current_os"
    else
        log_warning "No OS-specific zsh config for $current_os"
    fi
}

# Check file permissions
check_permissions() {
    log_check "Checking file permissions..."

    # Scripts should be executable
    while IFS= read -r -d '' script; do
        if [[ ! -x "$script" ]]; then
            log_warning "Script not executable: $(basename "$script")"
        else
            log_success "Script executable: $(basename "$script")"
        fi
    done < <(find "$DOTFILES_DIR/scripts" -name "*.sh" -type f -print0 2>/dev/null || true)

    # Git hooks should be executable
    while IFS= read -r -d '' hook; do
        if [[ ! -x "$hook" ]]; then
            log_warning "Git hook not executable: $(basename "$hook")"
        else
            log_success "Git hook executable: $(basename "$hook")"
        fi
    done < <(find "$DOTFILES_DIR/config/git/hooks" -type f -print0 2>/dev/null || true)

    # Tmux scripts should be executable
    local tmux_scripts="$DOTFILES_DIR/config/tmux/scripts"
    if [[ -d "$tmux_scripts" ]]; then
        while IFS= read -r -d '' script; do
            if [[ ! -x "$script" ]]; then
                log_warning "Tmux script not executable: $(basename "$script")"
            else
                log_success "Tmux script executable: $(basename "$script")"
            fi
        done < <(find "$tmux_scripts" -type f -print0 2>/dev/null || true)
    fi
}

# Check configuration consistency
check_config_consistency() {
    log_check "Checking configuration consistency..."

    # Check if referenced files exist
    local zshrc="$DOTFILES_DIR/config/zsh/.zshrc"
    if [[ -f "$zshrc" ]]; then
        # Check sourced files
        while IFS= read -r line; do
            if [[ "$line" =~ source[[:space:]]+([^[:space:]]+) ]]; then
                local sourced_file="${BASH_REMATCH[1]}"
                # Expand tilde and variables
                sourced_file="${sourced_file/#\~/$HOME}"
                sourced_file="${sourced_file/#\$HOME/$HOME}"

                if [[ ! -f "$sourced_file" ]] && [[ ! "$sourced_file" =~ \$ZSH ]]; then
                    log_warning "Referenced file may not exist: $sourced_file"
                fi
            fi
        done < "$zshrc"
    fi

    # Check vim plugin file references
    local vimrc="$DOTFILES_DIR/config/vim/.vimrc"
    if [[ -f "$vimrc" ]]; then
        if grep -q "source.*plugins.vim" "$vimrc"; then
            if [[ ! -f "$DOTFILES_DIR/config/vim/plugins.vim" ]]; then
                log_error "Vim references plugins.vim but file doesn't exist"
            else
                log_success "Vim plugins file exists"
            fi
        fi
    fi
}

# Check gitignore effectiveness
check_gitignore() {
    log_check "Checking .gitignore configuration..."

    local gitignore="$DOTFILES_DIR/.gitignore"
    if [[ -f "$gitignore" ]]; then
        # Check for common patterns
        local patterns=("*.log" "*.tmp" ".DS_Store" "local/" "backups/")

        for pattern in "${patterns[@]}"; do
            if grep -q "$pattern" "$gitignore"; then
                log_success "Gitignore includes: $pattern"
            else
                log_warning "Gitignore missing: $pattern"
            fi
        done

        # Check for merge conflict markers in gitignore
        if grep -q ">>>>>>>" "$gitignore"; then
            log_error "Merge conflict markers found in .gitignore"
        fi
    else
        log_error ".gitignore file missing"
    fi
}

# Check documentation
check_documentation() {
    log_check "Checking documentation..."

    local docs=(
        "README.md:Main documentation"
        "INSTALL.md:Installation guide"
        "docs/CUSTOMIZATION.md:Customization guide"
        "docs/TROUBLESHOOTING.md:Troubleshooting guide"
    )

    for doc_desc in "${docs[@]}"; do
        IFS=':' read -r doc desc <<< "$doc_desc"
        local doc_path="$DOTFILES_DIR/$doc"

        if [[ -f "$doc_path" ]]; then
            log_success "$desc exists"

            # Check if file has content
            if [[ $(wc -l < "$doc_path") -lt 5 ]]; then
                log_warning "$desc seems too short"
            fi
        else
            log_warning "$desc missing: $doc"
        fi
    done
}

# Check template files
check_templates() {
    log_check "Checking template files..."

    local templates_dir="$DOTFILES_DIR/templates"
    if [[ -d "$templates_dir" ]]; then
        while IFS= read -r -d '' template; do
            local name="$(basename "$template")"
            log_success "Template found: $name"

            # Check if template has placeholder content
            if grep -q "PLACEHOLDER\|TODO\|CHANGEME\|your-" "$template" 2>/dev/null; then
                log_success "Template has placeholders: $name"
            else
                log_info "Template may need placeholders: $name"
            fi
        done < <(find "$templates_dir" -name "*.template" -type f -print0 2>/dev/null || true)
    fi
}

# Main check functions
check_core_structure() {
    log_check "Checking core directory structure..."

    local core_dirs=(
        "config:Configuration files"
        "scripts:Installation and utility scripts"
        "docs:Documentation"
        "templates:Template files"
        "fonts:Font files"
        "tests:Test scripts"
        "tools:Additional tools"
    )

    for dir_desc in "${core_dirs[@]}"; do
        IFS=':' read -r dir desc <<< "$dir_desc"
        check_dir_exists "$DOTFILES_DIR/$dir" "$desc"
    done
}

check_config_files() {
    log_check "Checking configuration files..."

    local configs=(
        "config/zsh/.zshrc:Zsh configuration"
        "config/vim/.vimrc:Vim configuration"
        "config/tmux/.tmux.conf:Tmux configuration"
        "config/git/.gitconfig:Git configuration"
        "config/starship/starship.toml:Starship configuration"
    )

    for config_desc in "${configs[@]}"; do
        IFS=':' read -r config desc <<< "$config_desc"
        check_file_exists "$DOTFILES_DIR/$config" "$desc"

        # Check syntax based on file extension
        case "$config" in
            *.toml) check_config_syntax "$DOTFILES_DIR/$config" "toml" ;;
            *.json) check_config_syntax "$DOTFILES_DIR/$config" "json" ;;
            *.yml|*.yaml) check_config_syntax "$DOTFILES_DIR/$config" "yaml" ;;
        esac
    done
}

check_install_scripts() {
    log_check "Checking installation scripts..."

    local scripts=(
        "install.sh:Main installation script"
        "scripts/install/install-fonts.sh:Font installation"
        "scripts/install/install-cli-tools.sh:CLI tools installation"
        "scripts/utils/create-symlinks.sh:Symlink creation"
    )

    for script_desc in "${scripts[@]}"; do
        IFS=':' read -r script desc <<< "$script_desc"
        if check_file_exists "$DOTFILES_DIR/$script" "$desc"; then
            check_script_syntax "$DOTFILES_DIR/$script"
        fi
    done
}

# Summary and recommendations
print_summary() {
    echo
    echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    SUMMARY                       ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo

    echo -e "${GREEN}✓ Checks passed: $CHECKS_PASSED${NC}"
    echo -e "${YELLOW}⚠ Warnings: $WARNINGS_FOUND${NC}"
    echo -e "${RED}✗ Issues found: $ISSUES_FOUND${NC}"

    echo
    if [[ $ISSUES_FOUND -eq 0 ]]; then
        if [[ $WARNINGS_FOUND -eq 0 ]]; then
            echo -e "${GREEN}🎉 Excellent! Your dotfiles are in great shape!${NC}"
        else
            echo -e "${YELLOW}👍 Good! Your dotfiles are mostly healthy with minor warnings.${NC}"
        fi
    else
        echo -e "${RED}⚠️  Issues found that should be addressed.${NC}"
    fi

    if [[ $WARNINGS_FOUND -gt 0 ]] || [[ $ISSUES_FOUND -gt 0 ]]; then
        echo
        echo -e "${BLUE}💡 Recommendations:${NC}"

        if [[ -f "$DOTFILES_DIR/README copy.md" ]]; then
            echo "  • Remove or rename 'README copy.md'"
        fi

        if [[ $WARNINGS_FOUND -gt 0 ]]; then
            echo "  • Review warnings and consider fixing them"
            echo "  • Make scripts executable: chmod +x scripts/**/*.sh"
        fi

        if [[ $ISSUES_FOUND -gt 0 ]]; then
            echo "  • Fix syntax errors in configuration files"
            echo "  • Ensure all referenced files exist"
        fi

        echo "  • Run 'make test' to validate installation"
        echo "  • Test installation in a clean environment"
    fi

    echo
    echo -e "${BLUE}Next steps:${NC}"
    echo "  • Run: make install (to test installation)"
    echo "  • Run: make doctor (to run this check again)"
    echo "  • Check CI/CD pipeline status"
}

# Main execution
main() {
    print_header

    # Change to dotfiles directory
    cd "$DOTFILES_DIR"

    # Run all checks
    check_core_structure
    check_config_files
    check_install_scripts
    check_dependencies
    check_os_support
    check_permissions
    check_config_consistency
    check_duplicates
    check_symlinks
    check_gitignore
    check_documentation
    check_templates

    print_summary

    # Exit with appropriate code
    if [[ $ISSUES_FOUND -gt 0 ]]; then
        exit 1
    elif [[ $WARNINGS_FOUND -gt 0 ]]; then
        exit 2
    else
        exit 0
    fi
}

main "$@"
