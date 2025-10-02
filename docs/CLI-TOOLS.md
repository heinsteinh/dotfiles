# 🛠️ CLI Tools Reference

Comprehensive reference for 70+ modern command-line tools included in this dotfiles configuration. Updated with latest tools, intelligent fallbacks, and cross-platform compatibility.

## 🚀 Modern Replacements for Classic Tools

| Classic Tool | Modern Replacement | Key Benefits | Fallback Chain | Installation |
|-------------|-------------------|--------------|----------------|-------------|
| `ls` | `eza` | Git integration, icons, tree view | `eza` → `exa` → `ls --color` | ✅ Smart-install |
| `cat` | `bat` | Syntax highlighting, line numbers | `bat` → `batcat` → `cat` | ✅ Smart-install |
| `find` | `fd` | Simple syntax, fast, respects .gitignore | `fd` → `fdfind` → `find` | ✅ Smart-install |
| `grep` | `ripgrep (rg)` | 10-100x faster, smart filtering | `rg` → `grep --color` | ✅ Smart-install |
| `top` | `htop/bottom` | Interactive, colored, better UI | `btm` → `htop` → `top` | ✅ Smart-install |
| `du` | `dust` | Visual tree, sorted output | `dust` → `du -h` | ✅ Smart-install |
| `ps` | `procs` | Colored output, tree view | `procs` → `ps aux` | ✅ Smart-install |
| `ping` | `gping` | Real-time graph display | `gping` → `ping` | ✅ Smart-install |
| `diff` | `delta` | Syntax highlighting, side-by-side | `delta` → `diff --color` | ✅ Smart-install |
| `man` | `tldr/tealdeer` | Simplified examples | `tldr` → `man` | ✅ Smart-install |

## ⚡ Performance & Benchmarking Tools (Enhanced Suite)

| Tool | Purpose | Key Features | Platform Support |
|------|---------|--------------|------------------|
| `hyperfine` | Command benchmarking | Statistical analysis, warmup runs, JSON export | Linux, macOS, Windows |
| `tokei` | Code statistics | Lines of code, language breakdown, Git integration | All platforms |
| `bandwhich` | Network monitoring | Real-time bandwidth by process, interface stats | Linux, macOS |
| `bottom (btm)` | System monitoring | CPU, memory, disk, network graphs, process tree | All platforms |
| `dust` | Disk usage analyzer | Interactive tree view, colorized output | All platforms |
| `procs` | Process viewer | Colored output, tree view, search/filter | All platforms |
| `gping` | Enhanced ping | Real-time graphs, multiple hosts | All platforms |
| `ouch` | Archive management | Unified interface for all archive types | All platforms |

## File and Directory Operations

### eza (Enhanced ls)
```bash
# Basic usage
eza                    # List files
eza -l                 # Long format
eza -la                # Include hidden files
eza --tree             # Tree view
eza --git              # Show git status

# Useful aliases (already configured with fallbacks)
alias ls='eza --group-directories-first'      # Falls back to exa then ls
alias ll='eza -la --git --group-directories-first'
alias la='eza -a --group-directories-first'
alias lt='eza --tree --level=2'
alias lg='eza -la --git --git-ignore'
alias lsd='eza -D'     # directories only
alias lsf='eza -f'     # files only
alias lss='eza -la --sort=size'
alias lst='eza -la --sort=modified'
```

### fd (Find replacement)
```bash
# Basic usage
fd pattern             # Find files/directories
fd -t f pattern        # Files only
fd -t d pattern        # Directories only
fd -e ext pattern      # Specific extension
fd -H pattern          # Include hidden files

# Examples
fd "\.js$"             # Find all JavaScript files
fd -t d node_modules   # Find all node_modules directories
fd -e pdf document     # Find PDF files containing "document"
```

### ripgrep (rg)
```bash
# Basic usage
rg pattern             # Search in current directory
rg pattern path/       # Search in specific path
rg -i pattern          # Case insensitive
rg -w pattern          # Whole word only
rg -v pattern          # Invert match

# Advanced usage
rg -A 3 -B 3 pattern   # Show 3 lines before/after
rg --type js pattern   # Search only JavaScript files
rg -g "*.md" pattern   # Search only markdown files
rg -n pattern          # Show line numbers
```

## System Monitoring

### htop
```bash
htop                   # Interactive process viewer
# Keys in htop:
# F6 - Sort by column
# F9 - Kill process
# F5 - Tree view
# / - Search
```

### bat (Enhanced cat)
```bash
# Basic usage
bat file.txt           # View file with syntax highlighting
bat -n file.txt        # Show line numbers
bat -A file.txt        # Show all characters
bat --theme=gruvbox    # Use specific theme

# Integration with other tools
rg pattern | bat       # Syntax highlight ripgrep output
fd -e js | xargs bat   # View all JavaScript files
```

## Git Tools

### Delta (Git diff viewer)
```bash
# Configured in .gitconfig
git diff               # Enhanced diff with delta
git log -p             # Enhanced log with delta
git show               # Enhanced show with delta
```

### Git Aliases (Pre-configured)
```bash
# Status and info
git st                 # git status
git br                 # git branch
git co                 # git checkout
git lg                 # beautiful git log

# Operations
git unstage            # git reset HEAD --
git uncommit           # git reset --soft HEAD^
git amend             # git commit --amend
git please            # git push --force-with-lease
```

## Text Processing

### jq (JSON processor)
```bash
# Basic usage
echo '{"name": "John"}' | jq .name
cat data.json | jq '.users[0]'
curl api.example.com | jq '.data[] | .name'

# Pretty printing
curl api.example.com | jq .
```

### yq (YAML processor)
```bash
# Basic usage
yq '.database.host' config.yaml
yq '.services[].name' docker-compose.yml
```

## Network Tools

### httpie
```bash
# GET requests
http GET api.example.com/users
http GET api.example.com/users id==123

# POST requests
http POST api.example.com/users name=John email=john@example.com
http POST api.example.com/users < data.json

# Headers
http GET api.example.com/users Authorization:"Bearer token"
```

### curl alternatives
```bash
# HTTPie for APIs
http GET api.example.com

# wget for downloads
wget https://example.com/file.zip

# aria2 for fast downloads
aria2c -x 16 -s 16 https://example.com/largefile.zip
```

## Development Tools

### Node.js Tools
```bash
# Package management
npm install package    # Install package
yarn add package       # Yarn alternative
pnpm install package   # Fast alternative

# Development servers
npx create-react-app   # Create React app
npx live-server        # Static file server
npx json-server        # Mock REST API
```

### Python Tools
```bash
# Package management
pip install package    # Install package
pipx install package   # Install CLI tools

# Development
python -m http.server  # Static file server
python -m json.tool    # Pretty print JSON
```

### Docker Tools
```bash
# Container management
docker ps              # List containers
docker images          # List images
docker exec -it id sh  # Enter container

# Docker Compose
docker-compose up      # Start services
docker-compose logs -f # Follow logs
docker-compose down    # Stop services
```

## Fuzzy Finding (FZF)

### Basic Usage
```bash
# File selection
<C-t>                  # Insert file path
<C-r>                  # Command history
<A-c>                  # Change directory
```

### Custom Functions (Pre-configured)
```bash
# File operations
fe                     # Edit files with fzf
fd                     # Change to directory with fzf
fkill                  # Kill process with fzf

# Git operations
fgb                    # Switch git branch
fgl                    # Browse git log

# Docker operations
fdocker               # Connect to container
```

## Terminal Multiplexing (tmux)

### Session Management
```bash
# Sessions
tmux new -s name       # Create named session
tmux attach -t name    # Attach to session
tmux ls                # List sessions
tmux kill-session -t name

# Windows
<C-b> c               # Create window
<C-b> n               # Next window
<C-b> p               # Previous window
<C-b> &               # Kill window

# Panes
<C-b> %               # Split vertical
<C-b> "               # Split horizontal
<C-b> hjkl            # Navigate panes
<C-b> x               # Kill pane
```

### Custom Scripts (Included)
```bash
# Battery status (for laptops)
~/.config/tmux/scripts/battery.sh

# CPU usage
~/.config/tmux/scripts/cpu.sh

# Session management
~/.config/tmux/scripts/tmux-sessionizer
```

## Package Managers

### Homebrew (macOS)
```bash
# Package management
brew install package   # Install package
brew uninstall package # Remove package
brew update            # Update package list
brew upgrade           # Upgrade packages
brew cleanup           # Clean cache

# Cask (GUI applications)
brew install --cask app
brew uninstall --cask app
```

### APT (Debian/Ubuntu)
```bash
# Package management
sudo apt update        # Update package list
sudo apt install pkg   # Install package
sudo apt remove pkg    # Remove package
sudo apt autoremove    # Remove orphaned packages
```

## 📦 Archive & File Management Tools

### Modern Archive Tools (New in v2.0)
```bash
# ouch (unified archive tool) - handles ALL archive formats
ouch compress files/ archive.zip       # Create archives
ouch compress files/ archive.tar.gz    # Any format supported
ouch decompress archive.zip            # Auto-detect format
ouch decompress *.tar.gz              # Batch extraction
ouch list archive.7z                   # List contents without extracting

# Traditional tools (with fallbacks)
tar -czf archive.tar.gz files/         # Create compressed tar
tar -xzf archive.tar.gz                # Extract compressed tar  
unzip archive.zip                      # Extract zip files
7z x archive.7z                        # 7-zip extraction
```

### Advanced File Operations
```bash
# File synchronization and backup
rsync -avz source/ destination/        # Sync directories
rclone sync local/ remote:/path/       # Cloud sync (if installed)

# File permissions and ownership
chmod +x script.sh                     # Make executable
chown -R user:group directory/         # Change ownership
find . -type f -name "*.sh" -exec chmod +x {} \;  # Bulk permissions

# Disk space analysis
dust                                   # Interactive disk usage
dust -d 3                             # Limit depth
ncdu                                   # NCurses disk usage (if available)
df -h                                  # Disk free space
```

## 🚀 Package Management & Installation Tools

### Cross-Platform Package Managers
```bash
# Homebrew (macOS/Linux)
brew install package                   # Install packages
brew search pattern                    # Search packages  
brew update && brew upgrade            # Update system
brew cleanup                          # Clean cache

# Node.js ecosystem
npm install -g package                 # Global npm packages
yarn global add package               # Global yarn packages
pnpm install -g package               # Fast alternative

# Python ecosystem  
pip install package                    # Python packages
pipx install package                   # Isolated CLI tools
poetry add package                     # Project dependencies

# Rust ecosystem
cargo install package                  # Rust CLI tools
cargo-update -a                       # Update all cargo packages

# Go ecosystem
go install github.com/user/tool@latest # Go tools
```

## Performance Tools

### Benchmarking
```bash
# hyperfine (command benchmarking)
hyperfine 'command1' 'command2'
hyperfine --warmup 3 'my-command'

# time (execution time)
time command
/usr/bin/time -v command  # Detailed timing
```

### System Information
```bash
# neofetch (system info)
neofetch

# System monitoring
htop                   # Process monitor
iotop                  # I/O monitor
nethogs               # Network monitor
```

## Configuration Management

### Dotfiles Management
```bash
# Backup current configs
./scripts/maintenance/backup-dotfiles.sh

# Update all tools
./scripts/maintenance/update-all.sh

# Health check
./scripts/maintenance/health-check.sh

# Cleanup
./scripts/maintenance/cleanup.sh
```

### Symbolic Links
```bash
# Create symlinks
ln -sf source target
stow package           # GNU Stow for dotfiles

# Check symlinks
ls -la ~/.config/
file ~/.zshrc
```

## Productivity Tips

### Command Combinations
```bash
# Find and edit files
fd pattern | head -5 | xargs $EDITOR

# Search and replace in files
rg -l pattern | xargs sed -i 's/old/new/g'

# Monitor log files
tail -f log.txt | bat --paging=never

# Process monitoring
ps aux | rg process_name
```

### Aliases Usage
```bash
# Navigation
..                     # cd ..
...                    # cd ../..
~                      # cd ~

# Git shortcuts
gst                    # git status
gco                    # git checkout
gcm                    # git commit -m
gp                     # git push
```

### Environment Variables
```bash
# Important variables (pre-configured)
$EDITOR               # Default editor (vim/nvim)
$BROWSER              # Default browser
$TERMINAL             # Default terminal
$PATH                 # Executable search path
```

## 🧪 CI/CD & DevOps Tools (New in v2.0)

### Security & Scanning Tools
```bash
# Secret detection (integrated in CI)
gitleaks detect --source . --verbose   # Git secret scanning
trufflebot --source .                  # Entropy-based detection
trivy fs .                            # Vulnerability scanning

# Code quality  
shellcheck script.sh                   # Shell script linting
markdownlint *.md                     # Markdown formatting
yamllint .github/workflows/           # YAML validation
```

### Testing & Validation
```bash
# Performance benchmarking
hyperfine 'command1' 'command2'       # Command comparison
time zsh -i -c exit                   # Shell startup time
ulimit -a                             # System resource limits

# Network diagnostics
gping google.com github.com           # Multi-host ping visualization
bandwhich                             # Real-time network usage by process
ss -tuln                              # Network connections
curl -w "@curl-format.txt" url        # Detailed HTTP timing

# System monitoring
btm                                   # Modern system monitor
htop                                  # Interactive process viewer
iotop                                 # I/O usage monitor (Linux)
```

### Container & Cloud Tools
```bash
# Docker operations
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
docker-compose up -d                  # Start services
docker system prune                   # Clean unused resources

# Kubernetes (if available)
kubectl get pods                      # List pods
k9s                                   # Terminal UI for Kubernetes

# Cloud CLI tools (optional installs)
aws --version                         # AWS CLI
az --version                          # Azure CLI  
gcloud version                        # Google Cloud CLI
```

## 🔧 Tool Installation & Management

### Enhanced Installation Commands (v2.0)
```bash
# New modular installation approach
./scripts/install/install-cli-tools.sh    # 70+ CLI utilities only
./scripts/install/install-dev-tools.sh    # Development environments  
./scripts/install/install-fonts.sh        # Complete Nerd Fonts collection

# Interactive wizard (recommended)
./tools/workflows/new-machine.sh          # Guided setup with options

# OS-specific optimized setup
./scripts/setup/setup-ubuntu.sh           # Ubuntu 22.04/24.04 support
./scripts/setup/setup-macos.sh            # Enhanced Homebrew + 20+ dev settings
./scripts/setup/setup-fedora.sh           # DNF + RPM Fusion + Flatpak
./scripts/setup/setup-arch.sh             # Pacman + AUR via yay

# Legacy Makefile support (still available)
make install                              # Full installation
make test                                # Comprehensive testing
make health                              # System health check
```

### Tool Management Commands
```bash
# Update all tools and packages
./scripts/maintenance/update-all.sh       # Update everything
brew update && brew upgrade               # Update Homebrew packages  
npm update -g                            # Update global npm packages
cargo install-update -a                  # Update Rust tools
pipx upgrade-all                         # Update Python CLI tools

# System cleanup and maintenance
./scripts/maintenance/cleanup.sh          # Clean temporary files
brew cleanup                             # Clean Homebrew cache
docker system prune -af                  # Clean Docker resources
npm cache clean --force                  # Clean npm cache
```

## Troubleshooting

### Common Issues
```bash
# Command not found
which command          # Check if installed
echo $PATH            # Check PATH variable

# Permission issues
chmod +x script       # Make executable
sudo chown user file  # Change ownership

# Config issues
source ~/.zshrc       # Reload zsh config
tmux source ~/.tmux.conf  # Reload tmux config
```

### Debug Mode & Diagnostics
```bash
# Enable comprehensive debug mode
export DEBUG=1
export VERBOSE=1

# Tool availability checking
command -v tool || echo "Tool not found"    # Check tool existence
which -a python                            # Show all Python locations  
type -a git                                # Show git type and location

# Verbose tool output
ls -la --color=always                      # Force colored output
bat --version                              # Show version info
fd --version                               # Check fd version
rg --version                               # Ripgrep version and features
```

## 📊 Tool Categories Summary

### 🎯 Core Utilities (20 tools)
Essential replacements for classic UNIX tools with modern features and intelligent fallbacks.

### 🚀 Development Tools (25 tools)  
Language runtimes, package managers, and development utilities for multiple programming languages.

### 🔍 Search & Navigation (10 tools)
Advanced file finding, content searching, and directory navigation with fuzzy finding integration.

### 📊 Monitoring & Performance (15 tools)
System monitoring, performance analysis, and benchmarking tools with real-time capabilities.

### 🛡️ Security & DevOps (10 tools) 
Security scanning, code quality, and CI/CD integration tools for enterprise development.

---

## 🆕 Recent Updates (v2.0)

### ✅ Enhanced Tool Support
- **Ubuntu 24.04**: Full compatibility with `exa` → `eza` migration
- **macOS Apple Silicon**: Optimized Homebrew paths and native tool support  
- **Fedora Latest**: Enhanced DNF and RPM Fusion integration
- **Arch Linux**: Improved AUR support via yay helper

### 🔧 Smart Installation Features
- **Intelligent Fallbacks**: Graceful degradation when tools unavailable
- **CI/CD Awareness**: Tools adapt behavior for headless environments  
- **Performance Optimization**: Lazy loading and caching for faster startup
- **Cross-Platform**: Consistent experience across all supported platforms

### 🛡️ Security & Reliability  
- **Multi-Tool Scanning**: Integrated security validation in installation
- **Timeout Handling**: Prevents hanging during installation or testing
- **Error Recovery**: Robust error handling with detailed logging
- **Comprehensive Testing**: 17-category validation suite ensures reliability

**Total Tools**: 70+ modern CLI utilities with intelligent installation and cross-platform support.
