# Developer Workflows

Practical workflows and productivity tips for software development using this dotfiles configuration.

## 🚀 Daily Development Workflow

### Morning Setup
```bash
# Start your development session
cd ~/Projects
tm                     # Open tmux session manager (custom script)
pf                     # Project finder with fzf (custom script)

# OR create a new project session
tmux new-session -s myproject -c ~/Projects/myproject
```

### Git Workflow Integration
```bash
# Enhanced git workflow with lazygit
lg                     # Open lazygit TUI
gst                    # git status (alias)
gco feature-branch     # git checkout (alias)
gcm "commit message"   # git commit -m (alias)
gp                     # git push (alias)

# Advanced git operations
git lg                 # Beautiful git log
git unstage file       # Remove from staging
git amend             # Amend last commit
git please            # Force push with lease
```

## 🔍 File and Code Navigation

### Finding Files Quickly
```bash
# FZF integration (configured keybindings)
<Ctrl-t>              # Find files in current directory
<Alt-c>               # Change to directory
<Ctrl-r>              # Search command history

# Modern file operations
fd pattern            # Find files/folders
rg "search term"      # Search in files
bat filename          # View file with highlighting
eza --tree           # View directory structure
```

### Code Search and Navigation
```bash
# Project-wide search
rg -i "function.*auth" --type js     # Search JS files for auth functions
rg -A 3 -B 3 "TODO"                 # Find TODOs with context
rg --stats "import.*react"           # Search stats for React imports

# File operations with modern tools
fd -e js -e ts | head -10           # List first 10 JS/TS files
fd node_modules -t d -x rm -rf      # Remove all node_modules folders
```

## 💻 Terminal and Editor Workflow

### Tmux Session Management
```bash
# Session templates for different projects
create-dev-session() {
    tmux new-session -d -s dev -c ~/Projects
    tmux split-window -h -c ~/Projects
    tmux split-window -v -c ~/Projects
    tmux select-pane -t 0
    tmux send-keys 'nvim .' Enter
    tmux attach-session -t dev
}

# Window management
<Ctrl-a> c            # New window
<Ctrl-a> |            # Split vertical
<Ctrl-a> -            # Split horizontal
<Ctrl-a> hjkl         # Navigate panes
```

### Vim/Neovim Productivity
```bash
# Key mappings (Space as leader)
<Space>f              # Find files (FZF)
<Space>rg             # Search in files
<Space>n              # Toggle file tree
<Space>gs             # Git status
<Space>b              # Buffer list

# Quick edit common files
<Space>ev             # Edit vimrc
<Space>ez             # Edit zshrc
<Space>et             # Edit tmux.conf
```

## 🔄 Development Server Management

### Quick Server Startup
```bash
# Python development
python -m http.server 8000          # Static file server
python -m http.server 3000          # Custom port
uvicorn main:app --reload           # FastAPI with hot reload

# Node.js development
npx live-server                     # Static server with hot reload
npm start                           # Project-specific start
yarn dev                           # Development mode

# Multiple services with tmux
dev-start() {
    tmux new-session -d -s services
    tmux send-keys 'cd backend && npm run dev' Enter
    tmux split-window -h
    tmux send-keys 'cd frontend && npm start' Enter
    tmux split-window -v
    tmux send-keys 'docker-compose up' Enter
    tmux attach-session -t services
}
```

## 📊 Monitoring and Debugging

### System Monitoring During Development
```bash
# Resource monitoring
htop                   # Interactive process viewer
btm                    # Modern system monitor (bottom)
du -sh */             # Directory sizes
df -h                 # Disk usage

# Network monitoring
ss -tuln              # Network connections
lsof -i :3000         # What's using port 3000
bandwhich             # Network usage by process
```

### Development Debugging
```bash
# Process management
fkill                 # Interactive process killer with fzf
ps aux | rg node      # Find all Node processes
kill -9 $(lsof -ti:3000)  # Kill process on port 3000

# Log monitoring
tail -f app.log | bat --paging=never    # Live log viewing with syntax highlighting
journalctl -f -u service-name           # Follow systemd service logs
```

## 🛠️ Custom Development Functions

### Project Management Functions (Pre-configured)
```bash
# Project creation
mkproject() {
    mkdir -p ~/Projects/"$1"
    cd ~/Projects/"$1"
    git init
    echo "# $1" > README.md
    code .
}

# Quick backup
backup() {
    local file="$1"
    cp "$file" "${file}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backed up to ${file}.backup.$(date +%Y%m%d_%H%M%S)"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
```

### Docker Development Workflow
```bash
# Docker shortcuts (pre-configured aliases)
dps                   # docker ps
dim                   # docker images
dex container_id sh   # docker exec -it container_id sh
dlogs container_id    # docker logs -f container_id

# Docker cleanup
docker system prune -f                    # Clean up unused containers/images
docker volume prune -f                    # Clean up unused volumes
docker image prune -a -f                  # Remove all unused images
```

## 🎨 Customization Examples

### Personal Development Aliases
Add to `~/.zshrc.local`:
```bash
# Project shortcuts
alias work="cd ~/Projects/work && code ."
alias personal="cd ~/Projects/personal"
alias dotfiles="cd ~/.dotfiles"

# Development shortcuts
alias serve="python -m http.server"
alias api="cd ~/Projects/api && docker-compose up"
alias ui="cd ~/Projects/ui && npm start"

# Git shortcuts
alias gfp="git fetch && git pull"
alias gcm="git checkout main && git pull"
alias gbd="git branch -d"
```

### Custom Functions for Specific Workflows
```bash
# Create and switch to feature branch
feature() {
    git checkout main
    git pull
    git checkout -b "feature/$1"
    echo "Created and switched to feature/$1"
}

# Quick commit and push
qcp() {
    git add .
    git commit -m "$1"
    git push
}

# Open project in preferred editor
edit() {
    if [[ -d "$1/.git" ]]; then
        cd "$1" && code .
    else
        code "$1"
    fi
}
```

## 🔄 Performance Optimization Tips

### Shell Performance
```bash
# Profile zsh startup time
time zsh -i -c exit

# Disable unused plugins temporarily
# Comment out in ~/.zshrc plugins array

# Use lazy loading for heavy tools
lazy_load_nvm() {
    unset -f nvm node npm npx
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}
```

### File System Performance
```bash
# Use .gitignore for fd and ripgrep
echo "node_modules/" >> .gitignore
echo ".git/" >> .gitignore

# Exclude binary files from searches
rg --type-not binary "search term"
fd -E "*.pdf" -E "*.jpg" pattern
```

## 🎯 IDE Integration

### VS Code Integration
```json
// settings.json
{
    "terminal.integrated.shell.osx": "/bin/zsh",
    "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font Mono",
    "terminal.integrated.fontSize": 14,
    "editor.fontFamily": "JetBrains Mono, Fira Code",
    "editor.fontLigatures": true
}
```

### Terminal Integration with Editors
```bash
# Open files from terminal
code filename         # VS Code
nvim filename         # Neovim
vim filename          # Vim

# Open project in editor
code .               # Current directory in VS Code
nvim .               # Current directory in Neovim
```

## 🔍 Debugging Workflows

### Common Development Issues
```bash
# Port conflicts
lsof -i :PORT_NUMBER
kill -9 PID

# Permission issues
ls -la filename
chmod 755 filename
chown user:group filename

# Environment issues
echo $PATH
env | grep NODE
which node npm
```

### Log Analysis
```bash
# Real-time log monitoring with highlighting
tail -f application.log | bat --paging=never

# Search logs with context
rg -A 5 -B 5 "ERROR" app.log

# Filter and format JSON logs
cat app.log | rg '"level":"error"' | jq .
```

This workflow guide helps developers maximize productivity using the modern CLI tools and configurations provided by this dotfiles setup.
