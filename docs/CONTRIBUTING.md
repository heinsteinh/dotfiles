# 🤝 Contributing to Dotfiles

Thank you for your interest in contributing! This guide will help you understand our development workflow, testing requirements, and contribution standards.

## 🚀 Quick Start

### Prerequisites
- Git (for version control)
- One of the supported platforms: Ubuntu, macOS, Fedora, or Arch Linux
- Basic shell scripting knowledge

### Development Setup
```bash
# 1. Fork the repository on GitHub
# 2. Clone your fork
git clone https://github.com/your-username/dotfiles.git
cd dotfiles

# 3. Create a development branch
git checkout -b feature/your-feature-name

# 4. Test your changes
./tests/test-installation.sh
```

## 🏗️ Development Workflow

### Branch Strategy
- **main**: Stable, production-ready code
- **feature/***: New features and enhancements
- **fix/***: Bug fixes and corrections
- **docs/***: Documentation improvements
- **ci/***: CI/CD and automation changes

### Commit Convention
We follow conventional commits for clear changelog generation:

```bash
# Format
type(scope): description

# Examples
feat(zsh): add new git aliases for enhanced workflow
fix(macos): resolve homebrew installation on Apple Silicon
docs(install): update installation instructions for Fedora
ci(test): add missing dependency for Ubuntu CI
```

**Types:**
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `ci`: CI/CD changes
- `test`: Testing improvements
- `refactor`: Code refactoring
- `style`: Code style changes
- `perf`: Performance improvements

## 🧪 Testing Requirements

### Local Testing
Before submitting any changes, ensure all tests pass locally:

```bash
# Run the comprehensive test suite
./tests/test-installation.sh

# Test specific components
./scripts/install/install-cli-tools.sh --test-mode
./scripts/utils/create-symlinks.sh --dry-run
```

### CI/CD Validation
All contributions are automatically tested across:
- **Ubuntu 22.04 LTS** - Latest stable
- **Ubuntu 24.04 LTS** - Current LTS
- **macOS 14** - Latest macOS
- **Fedora Latest** - Rolling release
- **Arch Linux** - Rolling release

### Security Scanning
Every contribution undergoes automated security scanning:
- **GitLeaks**: Repository secret detection
- **TruffleHog**: Entropy-based secret analysis
- **Trivy**: Vulnerability assessment
- **Custom Patterns**: Dotfiles-specific security checks

## 📝 Contribution Types

### 🆕 Adding New Features

**OS Support:**
```bash
# Add support for a new distribution
1. Create scripts/setup/setup-{distro}.sh
2. Add OS detection logic to scripts/setup/setup-common.sh
3. Update CI matrix in .github/workflows/ci.yml
4. Add tests for the new platform
5. Update documentation
```

**CLI Tools:**
```bash
# Add new CLI tool installation
1. Add to scripts/install/install-cli-tools.sh
2. Include in appropriate OS setup scripts
3. Add validation tests
4. Update tool list in documentation
```

**Configuration Templates:**
```bash
# Add new application configuration
1. Create config/{app}/ directory
2. Add configuration files
3. Update scripts/utils/create-symlinks.sh
4. Add symlink tests
5. Document in CUSTOMIZATION.md
```

### 🐛 Bug Fixes

**Issue Analysis:**
1. **Reproduce** the issue locally
2. **Identify** the root cause
3. **Create** a targeted fix
4. **Test** across affected platforms
5. **Document** the solution

**Common Bug Categories:**
- **OS Compatibility**: Platform-specific issues
- **Package Management**: Installation/update problems
- **Configuration**: Symlink or config file issues
- **Performance**: Startup time or resource usage
- **Security**: Vulnerability or exposure concerns

### 📚 Documentation Improvements

**Documentation Standards:**
- **Clear Examples**: Include working code samples
- **Platform Coverage**: Document OS-specific differences
- **Troubleshooting**: Include common issues and solutions
- **Visual Aids**: Use diagrams and screenshots where helpful
- **Keep Updated**: Ensure documentation matches current code

**Key Documentation Files:**
- `README.md` - Project overview and quick start
- `docs/INSTALLATION.md` - Comprehensive installation guide
- `docs/CUSTOMIZATION.md` - User customization guide
- `docs/TROUBLESHOOTING.md` - Problem resolution guide
- `docs/ARCHITECTURE.md` - System design and implementation
- `CHANGELOG.md` - Version history and changes

### ⚙️ CI/CD Improvements

**Pipeline Enhancements:**
- **New OS Support**: Add platform to test matrix
- **Performance Testing**: Add benchmarking workflows
- **Security Enhancements**: Improve scanning coverage
- **Artifact Management**: Better result collection and reporting

## 🔍 Code Standards

### Shell Scripting Best Practices

**Error Handling:**
```bash
#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Function template
function_name() {
    local arg1="$1"
    local arg2="${2:-default_value}"

    # Validation
    [[ -z "$arg1" ]] && { echo "Error: Missing argument"; return 1; }

    # Implementation with error checking
    if ! command -v some_tool >/dev/null 2>&1; then
        echo "Error: some_tool not found"
        return 1
    fi

    # Success indicator
    echo "✅ Operation completed successfully"
}
```

**Logging Standards:**
```bash
# Use consistent logging prefixes
echo "🔍 Detecting system information..."
echo "📦 Installing packages..."
echo "⚙️  Configuring settings..."
echo "✅ Installation completed successfully"
echo "❌ Error: Operation failed"
echo "⚠️  Warning: Non-critical issue detected"
```

**Platform Compatibility:**
```bash
# Use portable commands
if command -v apt >/dev/null 2>&1; then
    # Ubuntu/Debian specific
elif command -v brew >/dev/null 2>&1; then
    # macOS specific
elif command -v dnf >/dev/null 2>&1; then
    # Fedora specific
elif command -v pacman >/dev/null 2>&1; then
    # Arch specific
fi

# Avoid GNU-specific flags
# Bad: ls --color=auto
# Good: ls -G (macOS) or ls --color=auto (Linux)
```

### Configuration Management

**Symlink Creation:**
```bash
# Template for configuration symlinks
create_config_symlink() {
    local config_name="$1"
    local source_path="${DOTFILES_DIR}/config/${config_name}"
    local target_path="${HOME}/.${config_name}"

    # Backup existing configuration
    if [[ -e "$target_path" && ! -L "$target_path" ]]; then
        mv "$target_path" "${target_path}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "📋 Backed up existing $config_name configuration"
    fi

    # Create symlink
    ln -sf "$source_path" "$target_path"
    echo "🔗 Created symlink: $target_path -> $source_path"
}
```

**Plugin Management:**
```bash
# Oh My Zsh plugin installation template
install_zsh_plugin() {
    local plugin_name="$1"
    local plugin_repo="$2"
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"

    if [[ ! -d "$plugin_dir" ]]; then
        git clone "$plugin_repo" "$plugin_dir"
        echo "📦 Installed plugin: $plugin_name"
    else
        echo "✅ Plugin already installed: $plugin_name"
    fi
}
```

### Testing Standards

**Test Function Template:**
```bash
test_feature() {
    local feature_name="$1"
    local test_passed=true

    echo "🧪 Testing $feature_name..."

    # Test implementation
    if ! validate_feature; then
        echo "❌ $feature_name test failed"
        test_passed=false
    else
        echo "✅ $feature_name test passed"
    fi

    return $([[ "$test_passed" == true ]] && echo 0 || echo 1)
}
```

**CI Environment Handling:**
```bash
# Adapt tests for CI environment
if [[ "${CI:-}" == "true" ]]; then
    # CI-specific test logic (no user configs)
    test_tool_availability
else
    # Local test logic (full configuration)
    test_user_configuration
fi
```

## 🔒 Security Guidelines

### Secret Management
- **Never commit** sensitive information (passwords, tokens, keys)
- **Use templates** for configuration files containing secrets
- **Validate security** with our automated scanning tools
- **Document security** considerations in configuration guides

### Code Review Security
- **Review dependencies** for known vulnerabilities
- **Validate input** in all shell functions
- **Use secure defaults** for all configurations
- **Test security features** thoroughly

### Vulnerability Response
1. **Report** security issues privately via GitHub Security Advisory
2. **Assess** impact and affected versions
3. **Develop** fix with minimal disclosure
4. **Coordinate** release and disclosure timeline
5. **Document** in security advisories

## 📋 Pull Request Process

### Before Submitting
- [ ] Tests pass locally (`./tests/test-installation.sh`)
- [ ] Code follows project standards
- [ ] Documentation updated (if applicable)
- [ ] Commit messages follow conventional format
- [ ] No sensitive information included

### PR Template
```markdown
## Description
Brief description of changes and motivation.

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix/feature causing existing functionality to change)
- [ ] Documentation update

## Testing
- [ ] Local testing completed
- [ ] CI tests passing
- [ ] Manual testing on affected platforms

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or properly documented)

## Screenshots/Logs
Include relevant screenshots or command output.
```

### Review Process
1. **Automated Checks**: CI/CD pipeline validation
2. **Code Review**: Maintainer review for quality and standards
3. **Testing**: Multi-platform validation
4. **Documentation**: Accuracy and completeness check
5. **Security**: Vulnerability and secret scanning
6. **Merge**: Integration into main branch

## 🏆 Recognition

### Contributors
We maintain a contributors list recognizing all contributions:
- **Code Contributors**: Feature development and bug fixes
- **Documentation Contributors**: Guides, examples, and clarity improvements
- **Testing Contributors**: Platform validation and issue identification
- **Community Contributors**: Issue reporting, discussions, and feedback

### Contribution Tracking
- **GitHub Insights**: Automatic contribution tracking
- **Release Notes**: Contributor recognition in changelogs
- **Documentation Credits**: Author attribution in documentation

## 🆘 Getting Help

### Communication Channels
- **Issues**: Bug reports and feature requests
- **Discussions**: Questions, ideas, and general discussion
- **Security**: Private vulnerability reporting via GitHub Security

### Development Questions
- **Architecture**: Refer to `docs/ARCHITECTURE.md`
- **Installation**: Check `docs/INSTALLATION.md`
- **Customization**: Review `docs/CUSTOMIZATION.md`
- **Troubleshooting**: Consult `docs/TROUBLESHOOTING.md`

### Mentoring
New contributors are welcome! Feel free to:
- **Ask questions** in GitHub Discussions
- **Request guidance** on complex changes
- **Propose ideas** before implementation
- **Seek feedback** during development

---

Thank you for contributing to making dotfiles better for everyone! 🎉
