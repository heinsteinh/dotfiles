# CLI Tools Reference

A comprehensive reference for all the command-line tools included in this dotfiles configuration.

## Modern Replacements for Classic Tools

| Classic Tool | Modern Replacement | Description |
|-------------|-------------------|-------------|
| `ls` | `eza` | Modern replacement with colors and git integration |
| `cat` | `bat` | Syntax highlighting and git integration |
| `find` | `fd` | Fast and user-friendly alternative |
| `grep` | `ripgrep (rg)` | Extremely fast text search |
| `top` | `htop` | Interactive process viewer |
| `du` | `dust` | Intuitive disk usage analyzer |
| `ps` | `procs` | Modern process information |

## File and Directory Operations

### eza (Enhanced ls)
```bash
# Basic usage
eza                    # List files
eza -l                 # Long format
eza -la                # Include hidden files
exa --tree             # Tree view
exa --git              # Show git status

# Useful aliases (already configured)
alias ls='exa'
alias ll='exa -l'
alias la='exa -la'
alias tree='exa --tree'
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

## Archive Tools

### Modern Archive Tools
```bash
# ouch (unified archive tool)
ouch compress file.txt archive.zip
ouch decompress archive.zip
ouch list archive.tar.gz

# Traditional tools
tar -czf archive.tar.gz files/
unzip archive.zip
7z x archive.7z
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

## Tool Installation

### Quick Installation Commands
```bash
# Install everything
make install

# Install specific categories
make fonts            # Install fonts only
make cli-tools        # Install CLI tools only  
make dev-tools        # Install development tools

# OS-specific setup
make setup-macos      # macOS specific
make setup-ubuntu     # Ubuntu specific
make setup-arch       # Arch Linux specific
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

### Debug Mode
```bash
# Enable debug mode
export DEBUG=1

# Verbose output
command -v            # Verbose version
ls -la               # Detailed listing
```