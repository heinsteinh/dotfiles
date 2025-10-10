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

## 🏗️ C++ Development Workflows

### Complete C++ Project Setup

```bash
# Create new C++ CMake project
cd ~/Projects
mkdir myapp && cd myapp

# Initialize project structure
mkdir -p src include tests build docs

# Create CMakeLists.txt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.20)
project(MyApp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(${PROJECT_NAME} src/main.cpp)
target_include_directories(${PROJECT_NAME} PRIVATE include)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
EOF

# Create source files
cat > src/main.cpp << 'EOF'
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF

# Initialize git
git init
cat > .gitignore << 'EOF'
build/
*.o
*.a
*.so
compile_commands.json
.cache/
EOF

# Configure and build
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j$(nproc)

# Open in Neovim
nvim .
```

### C++ Daily Development Session

```bash
# Start tmux session for C++ project
tmux new-session -s cpp-project -c ~/Projects/myapp

# Window 0: Editor (main development)
nvim .

# Split for quick commands
<Ctrl-a> |

# Window 1: Build and Run
<Ctrl-a> c
# Watch and rebuild on file changes
watch -n 1 'cmake --build build 2>&1 | tail -20'

# Window 2: Tests
<Ctrl-a> c
watch -n 2 'ctest --test-dir build --output-on-failure'

# Window 3: Git
<Ctrl-a> c
lg  # lazygit

# Window 4: Monitoring
<Ctrl-a> c
htop
```

### C++ Build Workflow

```bash
# Debug build
cmake -B build -DCMAKE_BUILD_TYPE=Debug -G Ninja
cmake --build build -j$(nproc)
./build/myapp

# Release build
cmake -B build-release -DCMAKE_BUILD_TYPE=Release -G Ninja
cmake --build build-release -j$(nproc)

# With sanitizers
cmake -B build-asan \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_FLAGS="-fsanitize=address -fno-omit-frame-pointer" \
    -G Ninja
cmake --build build-asan
ASAN_OPTIONS=detect_leaks=1 ./build-asan/myapp

# Clean and rebuild
rm -rf build && cmake -B build && cmake --build build
```

### C++ Debugging Session

```bash
# Terminal GDB workflow
gdb ./build/myapp
(gdb) break main
(gdb) run
(gdb) next
(gdb) print variable
(gdb) backtrace
(gdb) quit

# Neovim debugging
nvim src/main.cpp
# Set breakpoint: <leader>db
# Start debugging: F5
# Step over: F10
# Step into: F11
# Continue: F5

# Memory leak detection
valgrind --leak-check=full --log-file=valgrind.log ./build/myapp
bat valgrind.log
```

### C++ Code Navigation Workflow

```bash
# In Neovim - LSP navigation
# gd          - Go to definition
# gr          - Find all references
# K           - Hover documentation
# <leader>rn  - Rename symbol
# <leader>ca  - Code actions
# [d / ]d     - Navigate diagnostics

# Terminal-based code navigation
# Find function definition
rg "void functionName" --type cpp

# Find all usages
rg "functionName\(" --type cpp

# Find class definition
rg "class ClassName" --type cpp

# Switch between header and source
# If in main.cpp:
fd main.h | xargs nvim
# Or in Neovim: <leader>ch
```

### C++ Refactoring Workflow

```bash
# Rename across project
cd ~/Projects/myapp

# Method 1: LSP rename in Neovim
nvim src/myclass.cpp
# Place cursor on symbol
# <leader>rn
# Type new name
# Enter

# Method 2: Command line with ripgrep and sed
# Preview changes
rg "OldClassName" --type cpp --type-add 'h:*.h'

# Apply changes
rg "OldClassName" -l --type cpp --type-add 'h:*.h' | \
  xargs sed -i 's/OldClassName/NewClassName/g'

# Verify
git diff

# Rebuild
cmake --build build
```

### Qt Development Workflow

```bash
# Create Qt project
mkdir myqtapp && cd myqtapp
mkdir -p src include ui resources build

# CMake with Qt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.20)
project(MyQtApp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Widgets Gui)

add_executable(${PROJECT_NAME}
    src/main.cpp
    src/mainwindow.cpp
    include/mainwindow.h
    ui/mainwindow.ui
)

target_include_directories(${PROJECT_NAME} PRIVATE include)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Core Qt6::Widgets Qt6::Gui)
EOF

# Build and run
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
./build/MyQtApp

# Edit UI files
designer ui/mainwindow.ui &
# Or edit XML directly
nvim ui/mainwindow.ui

# After UI changes
cmake --build build --clean-first
```

### C++ Testing Workflow

```bash
# Add Google Test
# In CMakeLists.txt:
# include(FetchContent)
# FetchContent_Declare(googletest ...)
# FetchContent_MakeAvailable(googletest)

# Run tests
ctest --test-dir build --output-on-failure

# Run specific test
ctest --test-dir build -R MyTestName

# Verbose output
ctest --test-dir build -V

# Generate coverage
cmake -B build -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_FLAGS="--coverage"
cmake --build build
ctest --test-dir build
lcov --capture --directory build --output-file coverage.info
genhtml coverage.info --output-directory coverage_report
xdg-open coverage_report/index.html
```

### C++ Performance Profiling

```bash
# Compile with profiling
cmake -B build -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-pg"
cmake --build build

# Run and profile
./build/myapp
gprof ./build/myapp gmon.out > analysis.txt
bat analysis.txt

# Use perf for detailed profiling
perf record -g ./build/myapp
perf report

# Memory profiling with Valgrind
valgrind --tool=massif ./build/myapp
ms_print massif.out.<pid> | bat
```

### C++ Code Review Workflow

```bash
# Review changes before commit
git diff main | bat -l diff

# Review specific file with context
git diff main src/myfile.cpp | bat -l cpp

# Format code before review
find src include -name "*.cpp" -o -name "*.h" | xargs clang-format -i

# Check for common issues
cppcheck --enable=all --inconclusive src/ 2>&1 | tee cppcheck.log

# Review in Neovim with diff mode
nvim -d main.cpp feature-branch.cpp

# Interactive staging for review
git add -p src/myfile.cpp
```

## 🐍 Python Development Workflows

### Python Project Setup

```bash
# Create Python project
mkdir myproject && cd myproject

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Or use alias from dotfiles
venv myproject
venv-activate

# Create project structure
mkdir -p src tests docs
touch src/__init__.py tests/__init__.py

# Create requirements
cat > requirements.txt << 'EOF'
requests>=2.31.0
pytest>=7.4.0
black>=23.0.0
ruff>=0.0.290
EOF

pip install -r requirements.txt

# Initialize git
git init
cat > .gitignore << 'EOF'
venv/
__pycache__/
*.pyc
.pytest_cache/
.coverage
.env
EOF

# Create main module
cat > src/main.py << 'EOF'
def main():
    print("Hello, Python!")

if __name__ == "__main__":
    main()
EOF

# Open in Neovim
nvim .
```

### Python Daily Development Session

```bash
# Start tmux session for Python project
tmux new-session -s py-project -c ~/Projects/myproject

# Activate virtualenv
source venv/bin/activate

# Window 0: Editor
nvim .

# Window 1: Python REPL
<Ctrl-a> c
ipython
# Or regular Python
python

# Window 2: Tests with watch
<Ctrl-a> c
watch -n 2 'pytest -v --tb=short'

# Window 3: Linting
<Ctrl-a> c
watch -n 5 'ruff check src/ && echo "✓ Linting passed"'

# Window 4: Git
<Ctrl-a> c
lg
```

### Python Virtual Environment Management

```bash
# Create and activate venv
python3 -m venv venv
source venv/bin/activate

# Or use dotfiles aliases
venv myenv
venv-activate

# Install dependencies
pip install -r requirements.txt

# Freeze current packages
pip freeze > requirements.txt
# Or use alias
pip-freeze

# Upgrade all packages
pip list --outdated
pip install --upgrade pip
pip install --upgrade -r requirements.txt

# Deactivate
deactivate
# Or use alias
venv-deactivate

# Remove venv
rm -rf venv
```

### Python Testing Workflow

```bash
# Run all tests
pytest

# Verbose output
pytest -v

# Run specific test file
pytest tests/test_mymodule.py

# Run specific test
pytest tests/test_mymodule.py::test_function_name

# Run with coverage
pytest --cov=src --cov-report=html
xdg-open htmlcov/index.html

# Watch and re-run tests
watch -n 1 pytest -v

# Or use pytest-watch
ptw
```

### Python Debugging Workflow

```bash
# Add breakpoint in code
import pdb; pdb.set_trace()
# Or Python 3.7+
breakpoint()

# Run with debugger
python -m pdb src/main.py

# Common pdb commands
# l(ist)      - Show code
# n(ext)      - Next line
# s(tep)      - Step into function
# c(ontinue)  - Continue execution
# p variable  - Print variable
# pp variable - Pretty print
# h(elp)      - Help
# q(uit)      - Quit debugger

# Use ipdb for enhanced debugging
pip install ipdb
# In code:
import ipdb; ipdb.set_trace()

# Debug with Neovim DAP
nvim src/main.py
# <F5> to start debugging
# <F10> step over
# <F11> step into
```

### Python Code Quality Workflow

```bash
# Format code with Black
black src/ tests/

# Check formatting
black --check src/

# Lint with Ruff
ruff check src/

# Fix auto-fixable issues
ruff check --fix src/

# Type checking with mypy
pip install mypy
mypy src/

# Run all quality checks
black src/ tests/ && \
ruff check src/ tests/ && \
mypy src/ && \
pytest

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
black --check src/ tests/ && \
ruff check src/ tests/ && \
pytest
EOF
chmod +x .git/hooks/pre-commit
```

### Python REPL and Interactive Development

```bash
# IPython REPL with auto-reload
ipython
# In IPython:
%load_ext autoreload
%autoreload 2
from src import mymodule
# Make changes to mymodule
# It auto-reloads!

# Jupyter notebook
jupyter notebook

# Quick Python calculations
python -c "print(2**10)"

# Or use calc alias
calc 2**10

# Run Python script and stay in REPL
python -i script.py

# Load module in IPython
ipython -i -c "from src import mymodule"
```

### Python Package Management with Poetry

```bash
# Install Poetry
curl -sSL https://install.python-poetry.org | python3 -

# Create new project
poetry new myproject
cd myproject

# Add dependencies
poetry add requests pytest

# Add dev dependencies
poetry add --group dev black ruff mypy

# Install dependencies
poetry install

# Run commands in venv
poetry run python src/main.py
poetry run pytest

# Activate poetry venv
poetry shell

# Update dependencies
poetry update

# Export requirements
poetry export -f requirements.txt --output requirements.txt
```

### Python FastAPI Development Workflow

```bash
# Create FastAPI project
mkdir api && cd api
python3 -m venv venv
source venv/bin/activate

# Install FastAPI
pip install fastapi uvicorn[standard]

# Create main.py
cat > main.py << 'EOF'
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}
EOF

# Run development server with auto-reload
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# In tmux window, test API
curl http://localhost:8000
# Or open browser
xdg-open http://localhost:8000/docs

# Run in background with logs
uvicorn main:app --reload > api.log 2>&1 &
tail -f api.log | bat --paging=never
```

## 🚀 Multi-Language Project Workflows

### C++ with Python Bindings (pybind11)

```bash
# Project structure
mkdir hybrid-project && cd hybrid-project
mkdir -p cpp/src cpp/include python/src tests

# CMake with pybind11
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.20)
project(HybridProject)

set(CMAKE_CXX_STANDARD 17)

# pybind11
find_package(pybind11 REQUIRED)

# C++ library
add_library(mylib cpp/src/mylib.cpp)
target_include_directories(mylib PUBLIC cpp/include)

# Python module
pybind11_add_module(mypymodule python/src/bindings.cpp)
target_link_libraries(mypymodule PRIVATE mylib)
EOF

# Development workflow
# Window 1: C++ development
nvim cpp/src/mylib.cpp

# Window 2: Build and test
cmake -B build && cmake --build build
python -c "import sys; sys.path.insert(0, 'build'); import mypymodule; print(mypymodule.test())"

# Window 3: Python development
nvim python/src/bindings.cpp

# Window 4: Integration tests
pytest tests/
```

### Microservices Development Environment

```bash
# Multi-service tmux layout
tmux new-session -s microservices -c ~/Projects/microservices

# Window 0: API (Python FastAPI)
cd api
source venv/bin/activate
uvicorn main:app --reload --port 8000

# Window 1: Frontend (Node.js)
<Ctrl-a> c
cd frontend
npm run dev

# Window 2: Background Worker (C++)
<Ctrl-a> c
cd worker
cmake --build build && ./build/worker

# Window 3: Database
<Ctrl-a> c
docker-compose up postgres redis

# Window 4: Monitoring
<Ctrl-a> c
watch 'curl -s http://localhost:8000/health | jq .'

# Window 5: Logs aggregation
<Ctrl-a> c
tail -f api/logs/*.log worker/logs/*.log | bat --paging=never

# Window 6: Editor
<Ctrl-a> c
nvim .
```

### Kubernetes Development Workflow

```bash
# Local development with kubectl
# Window 1: Editor for YAML manifests
nvim deployment.yaml

# Window 2: Apply and watch
kubectl apply -f deployment.yaml
watch kubectl get pods

# Window 3: Logs
kubectl logs -f deployment/myapp

# Window 4: Port forwarding
kubectl port-forward service/myapp 8080:80

# Window 5: Shell into pod
kubectl exec -it deployment/myapp -- /bin/bash

# Quick kubectl aliases (add to ~/.zshrc.local)
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kl='kubectl logs -f'
alias kx='kubectl exec -it'
```

## 🔧 Build System Optimization Workflows

### Optimized C++ Build Pipeline

```bash
# Install build tools
# Ubuntu:
sudo apt install ccache ninja-build

# Arch:
sudo pacman -S ccache ninja

# Configure optimized build
cmake -B build \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON

# Parallel build
cmake --build build -j$(nproc)

# Check build time
time cmake --build build --clean-first

# Monitor ccache stats
ccache -s

# Build statistics
ninja -C build -d stats
```

### CI/CD Local Testing

```bash
# Test build in Docker (like CI)
docker run --rm -v $(pwd):/src -w /src ubuntu:22.04 bash -c "
    apt-get update && apt-get install -y cmake g++ ninja-build
    cmake -B build -G Ninja
    cmake --build build
    ctest --test-dir build
"

# Act - Run GitHub Actions locally
act -j build

# Pre-commit checks
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Format C++
clang-format -i src/*.cpp include/*.h

# Format Python
black .

# Run tests
cmake --build build && ctest --test-dir build --output-on-failure
EOF
chmod +x .git/hooks/pre-commit
```

## 📦 Package Management Workflows

### Ubuntu Development Environment

```bash
# Install C++ development tools
sudo apt install build-essential cmake ninja-build

# Install Qt development
sudo apt install qt6-base-dev qt6-tools-dev

# Install Python tools
sudo apt install python3-dev python3-venv python3-pip

# Install debugging tools
sudo apt install gdb valgrind

# Install LSP servers
sudo apt install clangd

# Search for packages with fzf
apt search cmake | fzf --preview 'apt show {1}'

# Or use alias from dotfiles
# apt-install-fzf (if configured)
```

### Arch Linux Development Environment

```bash
# Install C++ development tools
sudo pacman -S base-devel cmake ninja

# Install Qt development
sudo pacman -S qt6-base qt6-tools

# Install Python tools
sudo pacman -S python python-pip python-virtualenv

# Install debugging tools
sudo pacman -S gdb valgrind

# Install LSP servers
sudo pacman -S clang

# AUR packages with yay
yay -S ccache
yay -S clion  # If needed

# Interactive package search with fzf
pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs sudo pacman -S
# Or use alias: pac-install-fzf
```

## 🎨 Tmux Layout Templates

### C++ Development Layout

```bash
# Save this as ~/bin/tmux-cpp-layout
#!/bin/bash
PROJECT_DIR="${1:-.}"
SESSION_NAME=$(basename "$PROJECT_DIR")

tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Window 0: Editor
tmux send-keys -t "$SESSION_NAME:0" 'nvim .' Enter

# Window 1: Build
tmux new-window -t "$SESSION_NAME:1" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:1" 'cmake -B build -G Ninja && cmake --build build' Enter

# Window 2: Test
tmux new-window -t "$SESSION_NAME:2" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:2" 'watch -n 2 ctest --test-dir build --output-on-failure' Enter

# Window 3: Git
tmux new-window -t "$SESSION_NAME:3" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:3" 'lg' Enter

# Attach
tmux select-window -t "$SESSION_NAME:0"
tmux attach-session -t "$SESSION_NAME"
```

### Python Development Layout

```bash
# Save this as ~/bin/tmux-py-layout
#!/bin/bash
PROJECT_DIR="${1:-.}"
SESSION_NAME=$(basename "$PROJECT_DIR")

tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Activate venv if exists
if [ -d "venv" ]; then
    VENV_CMD="source venv/bin/activate"
else
    VENV_CMD=""
fi

# Window 0: Editor
tmux send-keys -t "$SESSION_NAME:0" "$VENV_CMD" Enter
tmux send-keys -t "$SESSION_NAME:0" 'nvim .' Enter

# Window 1: REPL
tmux new-window -t "$SESSION_NAME:1" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:1" "$VENV_CMD" Enter
tmux send-keys -t "$SESSION_NAME:1" 'ipython' Enter

# Window 2: Tests
tmux new-window -t "$SESSION_NAME:2" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:2" "$VENV_CMD" Enter
tmux send-keys -t "$SESSION_NAME:2" 'watch -n 2 pytest -v' Enter

# Window 3: Git
tmux new-window -t "$SESSION_NAME:3" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:3" 'lg' Enter

# Attach
tmux select-window -t "$SESSION_NAME:0"
tmux attach-session -t "$SESSION_NAME"
```

### Full-Stack Development Layout

```bash
# Save this as ~/bin/tmux-fullstack-layout
#!/bin/bash
PROJECT_DIR="${1:-.}"
SESSION_NAME=$(basename "$PROJECT_DIR")

tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Window 0: Editor
tmux send-keys -t "$SESSION_NAME:0" 'nvim .' Enter

# Window 1: Backend (split)
tmux new-window -t "$SESSION_NAME:1" -c "$PROJECT_DIR/backend"
tmux send-keys -t "$SESSION_NAME:1" 'source venv/bin/activate && uvicorn main:app --reload' Enter

# Window 2: Frontend
tmux new-window -t "$SESSION_NAME:2" -c "$PROJECT_DIR/frontend"
tmux send-keys -t "$SESSION_NAME:2" 'npm run dev' Enter

# Window 3: Database
tmux new-window -t "$SESSION_NAME:3" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:3" 'docker-compose up' Enter

# Window 4: Monitoring (split 3 ways)
tmux new-window -t "$SESSION_NAME:4" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:4" 'htop' Enter
tmux split-window -v -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:4" 'watch -n 2 docker stats' Enter
tmux split-window -v -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:4" 'tail -f backend/logs/*.log | bat --paging=never' Enter
tmux select-layout even-vertical

# Window 5: Git
tmux new-window -t "$SESSION_NAME:5" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION_NAME:5" 'lg' Enter

# Attach
tmux select-window -t "$SESSION_NAME:0"
tmux attach-session -t "$SESSION_NAME"
```

## 📚 Documentation and References

This enhanced workflow guide provides comprehensive examples for:
- **C++ CMake Qt Development** - Complete project workflows
- **Python Development** - Virtual environments, testing, debugging
- **Multi-language Projects** - C++/Python integration
- **Build System Optimization** - Fast iteration cycles
- **Package Management** - Ubuntu and Arch Linux
- **Tmux Layouts** - Pre-configured development environments

### Related Documentation

- [CPP-DEVELOPMENT.md](CPP-DEVELOPMENT.md) - Deep dive into C++ tooling
- [VIM-NEOVIM-ADVANCED.md](VIM-NEOVIM-ADVANCED.md) - Editor mastery
- [PACKAGE-MANAGEMENT.md](PACKAGE-MANAGEMENT.md) - Package management guide (coming soon)
- [KUBERNETES-HOMELAB.md](KUBERNETES-HOMELAB.md) - Kubernetes workflows (coming soon)

This workflow guide helps developers maximize productivity using the modern CLI tools and configurations provided by this dotfiles setup.
