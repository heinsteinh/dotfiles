# 🛠️ CLI Tools Reference

Comprehensive reference for 70+ modern command-line tools with 300+ practical examples. This guide focuses on real-world usage patterns for C++/CMake/Qt development, Python projects, and Kubernetes homelab management.

## 📋 Table of Contents

- [Modern Tool Replacements](#modern-tool-replacements)
- [File Management & Navigation](#file-management--navigation)
- [Search & Text Processing](#search--text-processing)
- [System Monitoring & Performance](#system-monitoring--performance)
- [Network & Connectivity](#network--connectivity)
- [Development & Git Tools](#development--git-tools)
- [Docker & Containers](#docker--containers)
- [Documentation & Presentation](#documentation--presentation)
- [Shell & Productivity](#shell--productivity)
- [Code Quality & Linting](#code-quality--linting)
- [Advanced Workflows](#advanced-workflows)
- [Quick Reference](#quick-reference)

## 🚀 Modern Tool Replacements

| Classic Tool | Modern Replacement | Key Benefits | Fallback Chain | Speed Improvement |
|-------------|-------------------|--------------|----------------|-------------------|
| `ls` | `eza` | Git integration, icons, tree view | `eza` → `exa` → `ls --color` | ~2x faster |
| `cat` | `bat` | Syntax highlighting, line numbers | `bat` → `batcat` → `cat` | Feature-rich |
| `find` | `fd` | Simple syntax, fast, respects .gitignore | `fd` → `fdfind` → `find` | 10x faster |
| `grep` | `ripgrep (rg)` | 10-100x faster, smart filtering | `rg` → `grep --color` | 100x faster |
| `top` | `htop/bottom` | Interactive, colored, better UI | `btm` → `htop` → `top` | Feature-rich |
| `du` | `dust` | Visual tree, sorted output | `dust` → `du -h` | 5x faster |
| `ps` | `procs` | Colored output, tree view | `procs` → `ps aux` | Feature-rich |
| `ping` | `gping` | Real-time graph display | `gping` → `ping` | Visual |
| `diff` | `delta` | Syntax highlighting, side-by-side | `delta` → `diff --color` | Feature-rich |
| `man` | `tldr/tealdeer` | Simplified examples | `tldr` → `man` | Faster learning |
| `sed` | `sd` | Simpler syntax, safer | `sd` → `sed` | Easier to use |
| `cut/awk` | `choose` | Intuitive field selection | `choose` → `cut` | Simpler syntax |

---

## 📁 File Management & Navigation

### eza - Modern ls Replacement

**Basic Usage**
```bash
# Simple listing
eza                          # List files with colors and icons
eza -l                       # Long format with metadata
eza -la                      # Include hidden files
eza -lh                      # Human-readable sizes

# Sorting options
eza -ls size                 # Sort by size
eza -ls modified             # Sort by modification time
eza -ls created              # Sort by creation time
eza -ls extension            # Sort by file extension
eza --sort=newest            # Newest first
```

**Advanced Features**
```bash
# Git integration (shows git status for each file)
eza -la --git                # Show git status column
eza -la --git --git-ignore   # Respect .gitignore

# Tree views
eza --tree                   # Tree view (all levels)
eza --tree --level=2         # Limit depth to 2
eza --tree --level=3 src/    # Tree of src directory

# Icons and colors
eza -la --icons              # Show file type icons
eza -la --icons --color=always    # Force colors
eza --icons --group-directories-first    # Directories first

# Special listings
eza -lD                      # Directories only
eza -lf                      # Files only
eza -ld */                   # List only subdirectories
```

**Practical Examples for C++ Development**
```bash
# View C++ project structure
eza --tree --level=3 --icons --git | grep -E '\.(cpp|h|hpp|cmake)$'

# List source files by size
eza -ls size src/ --icons | grep -E '\.(cpp|cc)$'

# Find recently modified headers
eza -ls modified include/ | head -20

# Show only CMake files
eza -la | grep -i cmake

# View build artifacts sorted by size
eza -lsr size build/ | head -20
```

**Custom Aliases (Pre-configured)**
```bash
ll='eza -la --git --group-directories-first --icons'
la='eza -a --group-directories-first --icons'
lt='eza --tree --level=2 --icons'
lg='eza -la --git --git-ignore --icons'
lsd='eza -D --icons'              # Directories only
lsf='eza -f --icons'              # Files only
lss='eza -la --sort=size --icons'
lst='eza -la --sort=modified --icons'
```

### fd - Fast Find Alternative

**Basic Usage**
```bash
# Simple search
fd pattern                   # Find files/directories matching pattern
fd '^main'                   # Find files starting with "main"
fd 'test$'                   # Find files ending with "test"

# Type filters
fd -t f pattern              # Files only
fd -t d pattern              # Directories only
fd -t l pattern              # Symlinks only
fd -t x pattern              # Executable files

# Extension filters
fd -e cpp                    # All .cpp files
fd -e h -e hpp               # All .h and .hpp files
fd -e cmake                  # All CMakeLists.txt or .cmake files
```

**Advanced Search Patterns**
```bash
# Include/exclude patterns
fd -t f -H pattern           # Include hidden files
fd -t f -I pattern           # Don't respect .gitignore
fd -t f --no-ignore-vcs pattern    # Ignore .gitignore
fd -t f -E build -E node_modules   # Exclude directories

# Depth control
fd -d 1 pattern              # Max depth of 1 (current dir only)
fd -d 3 pattern              # Max depth of 3

# Case sensitivity
fd -i pattern                # Case insensitive
fd -s pattern                # Case sensitive (default)

# Show full path
fd -p /usr pattern           # Absolute paths
fd -a pattern                # Show absolute paths
```

**Exec Integration (Powerful)**
```bash
# Execute command on each result
fd -e cpp -x wc -l           # Count lines in all .cpp files
fd -e h -x cat               # Cat all header files
fd -e cpp -x clang-format -i # Format all C++ files

# Batch operations
fd -e cpp -X ls -lh          # List all .cpp files (one command)
fd -t f -x rm                # Delete all matching files (BE CAREFUL!)

# Complex commands with placeholders
fd -e cpp -x echo "File: {}"        # {} = full path
fd -e cpp -x echo "Name: {/}"       # {/} = basename
fd -e cpp -x echo "Dir: {//}"       # {//} = parent directory
fd -e cpp -x echo "No ext: {.}"     # {.} = without extension
```

**Real-World C++/CMake Examples**
```bash
# Find all C++ source files
fd -e cpp -e cc -e cxx

# Find all header files
fd -e h -e hpp -e hxx

# Find CMake files
fd -t f 'CMakeLists\.txt'
fd -e cmake

# Find all Qt files
fd -e ui -e qrc -e qml

# Find test files
fd -t f 'test_.*\.cpp$'
fd -t f '.*_test\.cpp$'

# Find large build artifacts
fd -t f -s '>10M' -e o -e a build/

# Find files modified in last day
fd -t f --changed-within 1d

# Find all Python scripts in a C++ project
fd -e py -E build -E venv

# Search for specific function declarations
fd -e h -x rg 'class.*Widget'
```

### bat - Enhanced Cat with Syntax Highlighting

**Basic Usage**
```bash
# View file with syntax highlighting
bat file.cpp                 # Auto-detect C++ syntax
bat main.py                  # Auto-detect Python syntax
bat CMakeLists.txt           # Auto-detect CMake syntax

# Control output
bat -n file.cpp              # Show line numbers (default)
bat -p file.cpp              # Plain output (no decorations)
bat -A file.cpp              # Show all characters (spaces, tabs, etc.)
bat --paging=never file.cpp  # No paging, print to stdout
```

**Advanced Features**
```bash
# Theme selection
bat --theme=gruvbox file.cpp        # Use specific theme
bat --theme=OneHalfDark file.cpp    # Atom Dark equivalent
bat --list-themes                   # List available themes

# Language override
bat -l cpp file.txt                 # Force C++ syntax
bat -l cmake file.txt               # Force CMake syntax

# Line range selection
bat -r 10:20 file.cpp               # Lines 10-20
bat -r :50 file.cpp                 # First 50 lines
bat -r 100: file.cpp                # From line 100 to end

# Highlighting specific lines
bat -H 15 file.cpp                  # Highlight line 15
bat -H 10:20 file.cpp               # Highlight lines 10-20
bat -H 5 -H 15 -H 25 file.cpp       # Highlight multiple lines
```

**Integration with Other Tools**
```bash
# View ripgrep results with context
rg -C 3 'function_name' | bat -l cpp

# View git diff with syntax highlighting
git diff | bat -l diff

# Preview files in fzf
fd -e cpp | fzf --preview 'bat --color=always --style=numbers {}'

# View command output with syntax
curl https://api.github.com/repos/user/repo | bat -l json

# View logs with highlighting
tail -f /var/log/app.log | bat --paging=never -l log

# Compare files visually
bat file1.cpp file2.cpp
```

**Practical C++/Qt Development Examples**
```bash
# View Qt UI file
bat MainWindow.ui -l xml

# View CMake configuration
bat CMakeLists.txt -l cmake

# View header with line numbers for debugging
bat -n src/widget.h

# Quick preview of multiple files
bat src/*.cpp

# View Python build script
bat setup.py -l python

# Check YAML Kubernetes config
bat deployment.yaml -l yaml

# View JSON configuration
bat config.json -l json
```

### ranger - Terminal File Manager

**Basic Navigation**
```bash
# Launch ranger
ranger                       # Start in current directory
ranger /path/to/dir          # Start in specific directory

# Key Bindings (Inside Ranger)
# h/j/k/l - Left/Down/Up/Right (vim-style navigation)
# S - Open shell in current directory
# zh - Toggle hidden files
# / - Search
# n/N - Next/previous search result
# yy - Copy file
# dd - Cut file
# pp - Paste file
# dD - Delete file
# cw - Rename file
# :mkdir - Create directory
# :touch - Create file
# I - Rename from beginning
# A - Rename from end
# f - Quick find/filter files
```

**Practical Usage**
```bash
# Open ranger and cd to selected directory on exit
# Add to ~/.zshrc or use the pre-configured function:
ranger-cd() {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" && cd "$(cat "$tempfile")"
    rm -f "$tempfile"
}

# Preview files (automatic with bat integration)
# Ranger automatically uses bat for text file previews

# Bulk operations
# 1. Mark files with 'Space' key
# 2. Operate on marked files (yy, dd, :chmod, etc.)
```

### ncdu - NCurses Disk Usage

**Basic Usage**
```bash
# Analyze current directory
ncdu                         # Interactive disk usage

# Analyze specific directory
ncdu /home
ncdu ~/Projects

# Export to file
ncdu -o disk-usage.json      # Save analysis
ncdu -f disk-usage.json      # Load analysis

# Inside ncdu
# d - Delete file/directory
# g - Show graph
# i - Show info
# r - Refresh/recalculate
# n - Sort by name
# s - Sort by size
# c - Sort by items
# a - Toggle between actual size and apparent size
# e - Show/hide hidden files
```

**Real-World Examples**
```bash
# Find large build artifacts
ncdu build/

# Analyze Docker disk usage
ncdu /var/lib/docker

# Check node_modules size
ncdu node_modules/

# Analyze home directory
ncdu ~

# Compare directories
ncdu -o before.json ~/Project
# ... make changes ...
ncdu -o after.json ~/Project
# Compare the JSON files
```

### broot - Better Directory Navigation

**Basic Usage**
```bash
# Launch broot
br                           # Start interactive navigation

# Search and navigate
# Type to filter files/directories
# Alt+Enter - cd to selected directory
# Ctrl+→ - cd and quit
# :q - Quit

# Preview mode
br -p                        # Preview files
br --sizes                   # Show sizes
```

**Advanced Features**
```bash
# Search with preview
br --cmd ':focus myfile'

# Git integration
br --git-ignored             # Show git-ignored files
br --no-hidden               # Hide hidden files

# Custom verbs (defined in broot config)
# Can define custom commands for common operations
```

---

## 🔍 Search & Text Processing

### ripgrep (rg) - Ultra-Fast Grep

**Basic Usage**
```bash
# Simple search
rg pattern                   # Search in current directory
rg pattern path/             # Search in specific path
rg -i pattern                # Case insensitive
rg -w pattern                # Whole word match
rg -v pattern                # Invert match (lines NOT matching)
```

**Advanced Search Patterns**
```bash
# Context control
rg -A 3 pattern              # 3 lines after match
rg -B 3 pattern              # 3 lines before match
rg -C 3 pattern              # 3 lines context (before + after)

# Line numbers and formatting
rg -n pattern                # Show line numbers (default)
rg -N pattern                # No line numbers
rg --no-heading pattern      # Don't group by file
rg --heading pattern         # Group by file (default)

# Count and statistics
rg -c pattern                # Count matches per file
rg --count-matches pattern   # Count all matches
rg --files-with-matches pattern    # Only show filenames
rg --files-without-match pattern   # Files not matching

# Color and output
rg --color=always pattern    # Force colors (for piping)
rg --color=never pattern     # No colors
rg --vimgrep pattern         # Vim-compatible output
```

**File Type Filters**
```bash
# Search specific file types
rg -t cpp pattern            # Only C++ files
rg -t c pattern              # Only C files
rg -t cmake pattern          # Only CMake files
rg -t python pattern         # Only Python files
rg -t yaml pattern           # Only YAML files
rg -t markdown pattern       # Only Markdown files

# List available types
rg --type-list               # Show all file types

# Multiple types
rg -t cpp -t h pattern       # C++ and header files

# Exclude types
rg -T test pattern           # Exclude test files
rg -T cpp pattern            # Exclude C++ files
```

**Glob Patterns**
```bash
# Include/exclude by pattern
rg -g '*.cpp' pattern        # Only .cpp files
rg -g '*.{h,hpp}' pattern    # Only header files
rg -g '!test_*' pattern      # Exclude files starting with test_
rg -g '!build/' pattern      # Exclude build directory

# Multiple patterns
rg -g '*.cpp' -g '*.h' pattern

# Complex exclusions
rg pattern --glob='!{build,node_modules,venv,*.o,*.so}'
```

**Regular Expression Features**
```bash
# Advanced regex
rg 'class \w+Widget'         # Find Qt widget classes
rg 'void \w+\([^)]*\)'       # Find C function declarations
rg '#include <[^>]+>'        # Find include directives
rg 'TODO|FIXME|XXX'          # Find TODO comments

# Multiline search
rg -U 'namespace \w+ \{.*?\}' # Multiline with -U flag
rg -U '(?s)class.*?\{.*?\}'  # Class definitions (multiline)

# Look-ahead/look-behind
rg '(?<=class )\w+'          # Capture class names
rg '\w+(?=\()'               # Capture function names before (
```

**Replacement and Refactoring**
```bash
# Find and replace (dry-run)
rg 'old_name' -l             # List files with matches
rg 'old_name' --files-with-matches | xargs sed -i 's/old_name/new_name/g'

# Better: use sd for replacement
rg 'old_name' -l | xargs sd 'old_name' 'new_name'

# Preview changes before replacing
rg 'old_name' -A 0 -B 0
```

**Real-World C++ Development Examples**
```bash
# Find class definitions
rg 'class \w+' -t cpp

# Find function implementations
rg '^\w+::\w+\(' -t cpp

# Find TODO comments
rg 'TODO|FIXME|XXX|HACK' -t cpp -t h

# Find memory operations
rg 'new |delete |malloc|free' -t cpp

# Find Qt signal/slot declarations
rg 'signals:|slots:' -t cpp

# Find includes of specific header
rg '#include [<"]QtWidgets' -t cpp

# Find main functions
rg 'int main\(' -t cpp

# Find logging statements
rg 'qDebug|std::cout|LOG_' -t cpp

# Security audit - find dangerous functions
rg 'strcpy|strcat|sprintf|gets' -t cpp -t c

# Find commented-out code
rg '^\s*//' -t cpp -A 1

# Find large functions (more than 50 lines)
rg -U '(?s)void \w+\([^)]*\) \{.{500,}?\}' -t cpp

# Find virtual functions
rg 'virtual \w+.*override' -t cpp

# Find CMake find_package calls
rg 'find_package\(' -t cmake

# Find Python imports
rg '^import |^from .* import' -t python
```

**Performance Examples**
```bash
# Find files for batch processing
rg -l 'pattern' | parallel process_file

# Count total matches
rg -c 'pattern' | awk -F: '{sum+=$2} END {print sum}'

# Find most common error patterns
rg 'error' | cut -d: -f3 | sort | uniq -c | sort -rn | head -10
```

### fzf - Fuzzy Finder (Extended Examples)

**Basic Usage**
```bash
# Interactive file finder
fzf                          # Find file
fzf -m                       # Multi-select mode
fzf --preview 'bat {}'       # With preview

# Pipe input
ls | fzf                     # Find from ls output
history | fzf                # Find from history
```

**Advanced Preview**
```bash
# File preview with bat
fd -t f | fzf --preview 'bat --color=always --style=numbers {}' \
              --preview-window 'right:60%:wrap'

# Directory preview
fd -t d | fzf --preview 'ls -la {}' --preview-window 'right:50%'

# Git preview
git log --oneline | fzf --preview 'git show {1}' \
                        --preview-window 'right:60%:wrap'

# Process preview
ps aux | fzf --preview 'echo {}' --header-lines=1
```

**Custom Key Bindings**
```bash
# Configured in ~/.zshrc
# Ctrl+T - Paste selected files
# Ctrl+R - Paste from history
# Alt+C - cd to selected directory

# Custom function: edit file with fzf
fe() {
  local file
  file=$(fd -t f | fzf --preview 'bat --color=always {}') && $EDITOR "$file"
}

# Custom function: cd with preview
fcd() {
  local dir
  dir=$(fd -t d | fzf --preview 'ls -la {}') && cd "$dir"
}

# Custom function: kill process
fkill() {
  local pid
  pid=$(ps aux | fzf --header-lines=1 | awk '{print $2}')
  [ -n "$pid" ] && kill -9 "$pid"
}
```

**Integration with Git**
```bash
# Checkout branch
fgb() {
  local branch
  branch=$(git branch -a | fzf | sed 's/^[\* ]*//' | sed 's#^remotes/origin/##')
  [ -n "$branch" ] && git checkout "$branch"
}

# Interactive git add
fga() {
  local files
  files=$(git status -s | fzf -m | awk '{print $2}')
  [ -n "$files" ] && echo "$files" | xargs git add
}

# View git log with diff preview
fgl() {
  git log --oneline --decorate --color=always | \
    fzf --ansi --preview 'git show --color=always {1}' \
        --preview-window 'right:60%:wrap'
}

# Interactive git stash
fgs() {
  local stash
  stash=$(git stash list | fzf | cut -d: -f1)
  [ -n "$stash" ] && git stash show -p "$stash"
}
```

**Docker Integration**
```bash
# Interactive container selection
fdocker() {
  local cid
  cid=$(docker ps | fzf --header-lines=1 | awk '{print $1}')
  [ -n "$cid" ] && docker exec -it "$cid" bash
}

# View container logs
fdockerlogs() {
  local cid
  cid=$(docker ps -a | fzf --header-lines=1 | awk '{print $1}')
  [ -n "$cid" ] && docker logs -f "$cid"
}

# Remove images interactively
fdockerrmi() {
  docker images | fzf -m --header-lines=1 | awk '{print $3}' | xargs docker rmi
}
```

**Advanced Use Cases**
```bash
# Multi-select with preview and execute
fd -e cpp | fzf -m --preview 'bat --color=always {}' \
                --bind 'ctrl-a:select-all' \
                --bind 'ctrl-d:deselect-all' \
                --bind 'ctrl-t:toggle-all' | \
  xargs clang-format -i

# Interactive directory bookmarks
bookmark() {
  local dir
  dir=$(cat ~/.config/bookmarks | fzf | cut -d: -f2)
  [ -n "$dir" ] && cd "$dir"
}

# Search and edit config files
fconf() {
  local file
  file=$(fd . ~/.config --type f | fzf --preview 'bat --color=always {}')
  [ -n "$file" ] && $EDITOR "$file"
}
```

### sd - Modern Sed Replacement

**Basic Usage**
```bash
# Simple replacement
sd 'old' 'new' file.txt      # Replace first occurrence per line
sd -f m 'old' 'new' file.txt # Replace all occurrences (multiline)

# In-place editing
sd 'old' 'new' file.txt      # Prints to stdout
sd 'old' 'new' file.txt -i   # Edit file in-place

# Stdin/stdout
echo 'hello world' | sd 'world' 'universe'
cat file.txt | sd 'pattern' 'replacement'
```

**Advanced Features**
```bash
# Regex patterns
sd '\d+' 'NUMBER' file.txt   # Replace all numbers
sd '\w+@\w+\.\w+' 'EMAIL' file.txt  # Replace email addresses

# Capture groups
sd '(\w+) (\w+)' '$2 $1' file.txt  # Swap words
sd 'v(\d+)\.(\d+)' 'version $1.$2' file.txt  # Transform versions

# Flags and options
sd -f i 'pattern' 'replacement' file.txt  # Case insensitive
sd -f m 'pattern' 'replacement' file.txt  # Multiline mode
sd -f s 'pattern' 'replacement' file.txt  # . matches newline
```

**Real-World Examples**
```bash
# Replace in all C++ files
fd -e cpp -e h | xargs sd 'old_function' 'new_function'

# Update copyright year
sd '2023' '2024' $(fd -e cpp -e h)

# Remove trailing whitespace
sd '\s+$' '' file.cpp

# Convert tabs to spaces
sd '\t' '    ' file.cpp

# Update include guards
fd -e h | xargs sd 'MYPROJECT_(\w+)_H' 'NEWPROJECT_$1_H'

# Normalize line endings
sd '\r\n' '\n' file.txt

# Clean up multiple spaces
sd '\s+' ' ' file.txt

# Update namespaces
sd 'namespace old_ns' 'namespace new_ns' $(fd -e cpp)

# Replace smart pointers
sd 'std::auto_ptr<(\w+)>' 'std::unique_ptr<$1>' $(fd -e cpp)

# Update Qt4 to Qt5 includes
sd '#include <Q(\w+)>' '#include <Qt$1>' $(fd -e cpp)
```

### choose - Simpler cut/awk Alternative

**Basic Usage**
```bash
# Select fields (0-indexed)
echo 'a b c d' | choose 0          # Select first field: 'a'
echo 'a b c d' | choose 1 3        # Select 2nd and 4th: 'b d'
echo 'a b c d' | choose 0:2        # Range: 'a b c'
echo 'a b c d' | choose -1         # Last field: 'd'
echo 'a b c d' | choose -2:        # Last 2 fields: 'c d'

# Custom delimiter
echo 'a,b,c,d' | choose -f ',' 1   # Use comma as delimiter

# Exclusive ranges
echo 'a b c d' | choose 1:3        # Fields 1-3: 'b c d'
```

**Practical Examples**
```bash
# Extract process IDs
ps aux | choose 1

# Get file sizes
ls -lh | choose 4

# Extract IP addresses
ip addr | grep 'inet ' | choose 1

# Parse CSV (simpler than awk)
cat data.csv | choose -f ',' 0 2 4

# Extract columns from space-separated data
cat metrics.txt | choose 0 2 5

# Pipeline with other tools
fd -e log | xargs tail -1 | choose -f ':' 1
```

### jq - JSON Processing Powerhouse

**Basic Usage**
```bash
# Pretty print JSON
curl api.github.com/users/username | jq .

# Extract specific field
echo '{"name":"John","age":30}' | jq '.name'

# Extract from array
echo '[{"name":"John"},{"name":"Jane"}]' | jq '.[0].name'

# Multiple fields
echo '{"name":"John","age":30}' | jq '.name, .age'
```

**Advanced Queries**
```bash
# Array operations
jq '.[]' data.json              # Iterate array elements
jq '.[0]' data.json             # First element
jq '.[-1]' data.json            # Last element
jq '.[2:5]' data.json           # Slice array
jq '.[] | .name' data.json      # Map over array

# Filtering
jq '.[] | select(.age > 25)' data.json
jq '.[] | select(.name == "John")' data.json
jq '.[] | select(.tags | contains(["important"]))' data.json

# Transformation
jq '.[] | {name, email}' data.json        # Create new objects
jq '.[] | {fullname: "\(.first) \(.last)"}' data.json  # String interpolation
jq 'map({name, age})' data.json           # Map array

# Aggregation
jq 'length' data.json                     # Count elements
jq 'map(.price) | add' data.json          # Sum prices
jq 'map(.age) | min' data.json            # Minimum age
jq 'map(.age) | max' data.json            # Maximum age
jq 'map(.score) | add / length' data.json # Average
```

**Real-World API Examples**
```bash
# GitHub API
curl -s api.github.com/users/username/repos | \
  jq '.[] | {name: .name, stars: .stargazers_count, lang: .language}'

# Extract specific fields from complex JSON
curl -s api.example.com/data | \
  jq '.results[] | {id: .id, title: .title, author: .author.name}'

# Filter and sort
curl -s api.github.com/users/username/repos | \
  jq 'map(select(.stargazers_count > 10)) | sort_by(.stargazers_count) | reverse'

# Create CSV from JSON
jq -r '.[] | [.name, .email, .age] | @csv' data.json

# Transform package.json
jq '.scripts | to_entries[] | "\(.key): \(.value)"' package.json

# Merge JSON files
jq -s '.[0] * .[1]' file1.json file2.json

# Pretty print with colors and sorting
jq -S '.' data.json

# Extract nested data
jq '.data.users[].profile.email' response.json

# Conditional operations
jq '.[] | if .status == "active" then .name else empty end' data.json
```

**CMake/Build System Examples**
```bash
# Parse CMake compile_commands.json
jq '.[] | select(.file | endswith(".cpp")) | .file' compile_commands.json

# Extract compiler flags
jq -r '.[] | .command' compile_commands.json | \
  grep -o '\-I[^ ]*' | sort -u

# Filter build targets
jq '.[] | select(.file | contains("test"))' compile_commands.json
```

### yq - YAML Processor (Essential for Kubernetes)

**Basic Usage**
```bash
# Read values
yq '.database.host' config.yaml
yq '.services[0].name' docker-compose.yml
yq '.spec.replicas' deployment.yaml

# Update values
yq '.database.port = 5432' config.yaml
yq '.spec.replicas = 3' deployment.yaml -i

# Add new fields
yq '.metadata.labels.env = "prod"' deployment.yaml
```

**Kubernetes Workflow Examples**
```bash
# Get all container images
yq '.spec.template.spec.containers[].image' deployment.yaml

# Update image tag
yq '.spec.template.spec.containers[0].image = "myapp:v2.0"' deployment.yaml -i

# Get all service names
yq '.spec.ports[].name' service.yaml

# Change resource limits
yq '.spec.template.spec.containers[0].resources.limits.memory = "512Mi"' deployment.yaml -i

# Extract all environment variables
yq '.spec.template.spec.containers[0].env[] | .name + "=" + .value' deployment.yaml

# Get all ConfigMap keys
yq '.data | keys' configmap.yaml

# Merge YAML files
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' base.yaml overlay.yaml

# Convert YAML to JSON
yq -o json deployment.yaml

# Convert JSON to YAML
yq -P input.json
```

**Docker Compose Examples**
```bash
# List all services
yq '.services | keys' docker-compose.yml

# Get service ports
yq '.services.web.ports[]' docker-compose.yml

# Update service version
yq '.services.db.image = "postgres:15"' docker-compose.yml -i

# Get all volumes
yq '.volumes | keys' docker-compose.yml

# Extract environment variables from all services
yq '.services.[].environment' docker-compose.yml
```

### miller (mlr) - CSV/JSON/TSV Swiss Army Knife

**Basic Usage**
```bash
# CSV operations
mlr --csv cat data.csv            # Pretty print CSV
mlr --csv head -n 10 data.csv     # First 10 rows
mlr --csv tail -n 10 data.csv     # Last 10 rows

# Convert formats
mlr --icsv --ojson cat data.csv   # CSV to JSON
mlr --ijson --ocsv cat data.json  # JSON to CSV
mlr --icsv --omd cat data.csv     # CSV to Markdown table
```

**Data Transformation**
```bash
# Select columns
mlr --csv cut -f name,email data.csv

# Filter rows
mlr --csv filter '$age > 25' data.csv
mlr --csv filter '$status == "active"' data.csv

# Sort
mlr --csv sort -f name data.csv
mlr --csv sort -nr age data.csv   # Numeric reverse sort

# Compute statistics
mlr --csv stats1 -a sum,mean,count -f salary data.csv
mlr --csv stats1 -a min,max -f age -g department data.csv

# Group by
mlr --csv count-distinct -f country data.csv
```

**Real-World Examples**
```bash
# Analyze log files (TSV)
mlr --tsv stats1 -a count -f status_code access.log

# CSV report generation
mlr --csv cut -f name,salary,department employees.csv | \
  mlr --csv filter '$salary > 50000'

# Data cleaning
mlr --csv rename 'old name,new_name' data.csv

# Join CSV files
mlr --csv join -f employees.csv -j id -l employee_id departments.csv

# Create pivot tables
mlr --csv count -g department,role employees.csv

# Calculate percentiles
mlr --csv stats1 -a p50,p90,p99 -f response_time metrics.csv
```

---

## 📊 System Monitoring & Performance

### htop - Interactive Process Viewer

**Basic Usage**
```bash
# Launch htop
htop                         # Interactive process monitor
htop -u username             # Filter by user
htop -p PID1,PID2            # Monitor specific PIDs

# Key Bindings (Inside htop)
# F1 - Help
# F2 - Setup (configure htop)
# F3 - Search for process
# F4 - Filter processes
# F5 - Tree view
# F6 - Sort by column
# F7/F8 - Nice (decrease/increase priority)
# F9 - Kill process
# F10 - Quit
#
# Space - Tag process
# U - Untag all
# t - Tree view toggle
# H - Show/hide user threads
# K - Hide kernel threads
# / - Search
```

**Advanced Features**
```bash
# Sort by different metrics
# Press F6 then select:
# - CPU% - CPU usage
# - MEM% - Memory usage
# - TIME+ - CPU time
# - COMMAND - Process name

# Tree view for process hierarchy
# Press F5 or 't'

# Filter by name
# Press F4, type 'python' to show only Python processes

# Kill multiple processes
# 1. Tag with Space
# 2. Press F9 to kill tagged processes
```

### btm/bottom - Modern System Monitor

**Basic Usage**
```bash
# Launch bottom
btm                          # Default view
btm -b                       # Basic mode
btm -t                       # Tree mode
btm -m                       # Minimal mode

# Key Bindings
# ? - Help
# q - Quit
# / - Search
# Tab - Cycle between widgets
# Ctrl+R - Reset to default
# Ctrl+F - Freeze updates
```

**Advanced Features**
```bash
# Network monitoring
btm --network_use_binary_prefix  # Use KiB, MiB instead of KB, MB
btm --network_use_bytes          # Show bytes instead of bits

# Process filtering
btm --process_command            # Show full command

# Disk monitoring
btm --disk_filter "sda sdb"      # Filter specific disks

# Update interval
btm -r 1000                      # Update every 1000ms (1 second)
```

### procs - Modern ps Replacement

**Basic Usage**
```bash
# List all processes
procs                        # Show all processes

# Search processes
procs firefox                # Find processes matching 'firefox'
procs --or chrome firefox    # Multiple patterns with OR
procs --and python test      # Multiple patterns with AND

# Tree view
procs --tree                 # Show process tree
procs --tree firefox         # Tree for specific process

# Sort options
procs --sortd cpu            # Sort by CPU (descending)
procs --sortd mem            # Sort by memory (descending)
procs --sorta pid            # Sort by PID (ascending)
```

**Advanced Filtering**
```bash
# Filter by user
procs --user $(whoami)       # Your processes
procs --user root            # Root processes

# Filter by state
procs --state running        # Only running processes
procs --state sleeping       # Only sleeping processes

# Custom columns
procs --watch                # Watch mode (auto-refresh)
procs --watch-interval 2     # Custom refresh interval

# Detailed info
procs firefox --tree --pager # Tree view with pager
```

**Real-World Examples**
```bash
# Find memory-hungry processes
procs --sortd mem | head -20

# Find CPU-intensive processes
procs --sortd cpu | head -20

# Monitor C++ build processes
procs --tree cmake
procs --tree make

# Find zombie processes
procs | grep defunct

# Monitor Docker containers
procs docker

# Find processes using a specific port
procs | rg ':8080'

# Watch specific process
watch -n 1 "procs --tree --pid $(pgrep -f 'myapp')"
```

### dust - Intuitive Disk Usage

**Basic Usage**
```bash
# Analyze current directory
dust                         # Show disk usage tree

# Limit depth
dust -d 1                    # Show only immediate subdirectories
dust -d 3                    # Show up to 3 levels deep

# Show more results
dust -n 20                   # Show top 20 directories
dust -n 100                  # Show top 100 directories

# Reverse sort (smallest first)
dust -r

# Different size units
dust -b                      # Show in bytes
dust -s                      # Only show file size
```

**Practical Examples**
```bash
# Find large directories in home
dust ~

# Analyze build artifacts
dust build/ -n 50

# Find space hogs in /var
sudo dust /var -d 2

# Compare different directories
dust ~/Projects ~/Downloads

# Find large node_modules
dust -d 4 | grep node_modules

# Find large build caches
dust ~/.cache

# Exclude patterns
dust --ignore-directory node_modules
```

### bandwhich - Network Bandwidth Monitor

**Basic Usage (Requires Root)**
```bash
# Monitor network usage by process
sudo bandwhich                # Default interface

# Monitor specific interface
sudo bandwhich -i eth0
sudo bandwhich -i wlan0

# Raw mode (packets)
sudo bandwhich -r

# Key Bindings (Inside bandwhich)
# Space - Pause
# Tab - Cycle through views
# q - Quit
```

**Real-World Monitoring**
```bash
# Monitor during build/download
sudo bandwhich &
# Run your process
# Monitor which processes use network

# Find network-heavy applications
sudo bandwhich -r | tee network-usage.log
```

### gping - Visual Ping Tool

**Basic Usage**
```bash
# Ping single host
gping google.com

# Ping multiple hosts
gping google.com github.com cloudflare.com

# Custom interval
gping -i 0.5 google.com      # Ping every 500ms

# Custom buffer size
gping -b 100 google.com      # Keep last 100 results
```

**Practical Monitoring**
```bash
# Monitor connectivity to multiple services
gping api.service1.com api.service2.com db.internal.com

# Test load balancer endpoints
gping lb1.example.com lb2.example.com lb3.example.com

# Monitor local network
gping 192.168.1.1 8.8.8.8

# Watch for network drops
gping -b 200 google.com      # Long history buffer
```

### hyperfine - Command Benchmarking

**Basic Usage**
```bash
# Benchmark single command
hyperfine 'sleep 0.5'

# Compare commands
hyperfine 'command1' 'command2' 'command3'

# With warmup runs
hyperfine --warmup 3 'my-script.sh'

# Multiple runs
hyperfine --runs 100 'quick-command'
```

**Advanced Benchmarking**
```bash
# Parametrized benchmarks
hyperfine -P threads 1 8 'make -j {threads}'

# Setup and cleanup
hyperfine --prepare 'make clean' --cleanup 'make clean' 'make'

# Export results
hyperfine --export-json results.json 'command1' 'command2'
hyperfine --export-markdown results.md 'command1' 'command2'
hyperfine --export-csv results.csv 'command1' 'command2'

# Min/max time limits
hyperfine --min-runs 10 --max-runs 100 'command'
```

**Real-World C++ Build Examples**
```bash
# Compare build systems
hyperfine --warmup 2 --prepare 'make clean' \
  'make -j8' \
  'ninja' \
  'cmake --build build'

# Compare compiler optimizations
hyperfine --warmup 1 \
  'g++ -O0 main.cpp -o test' \
  'g++ -O1 main.cpp -o test' \
  'g++ -O2 main.cpp -o test' \
  'g++ -O3 main.cpp -o test'

# Compare number of build threads
hyperfine -P threads 1 16 --step-size 2 'make -j {threads}'

# Benchmark test suite
hyperfine --warmup 1 './run-tests.sh'

# Compare debug vs release build times
hyperfine --warmup 1 --prepare 'rm -rf build' \
  'cmake -B build -DCMAKE_BUILD_TYPE=Debug && cmake --build build' \
  'cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build'

# Python script benchmarks
hyperfine --warmup 3 'python script1.py' 'python script2.py'

# Compare search tools
hyperfine --warmup 2 'grep -r "pattern" .' 'rg "pattern"' 'ag "pattern"'
```

### tokei - Code Statistics

**Basic Usage**
```bash
# Count lines in current directory
tokei                        # All languages

# Specific directory
tokei ~/Projects/myapp

# Specific language
tokei -l cpp
tokei -l python
tokei -l rust

# Exclude directories
tokei --exclude node_modules --exclude build

# Sort by code lines
tokei --sort code
```

**Advanced Analysis**
```bash
# Output formats
tokei -o json > stats.json   # JSON format
tokei -o yaml > stats.yaml   # YAML format

# Detailed file breakdown
tokei --files                # Show per-file statistics

# Verbose output
tokei -v                     # Include stats for all files

# Type breakdown
tokei -t cpp,h,cmake         # Only specific types
```

**Real-World Project Analysis**
```bash
# Analyze C++ project
tokei -l cpp,c,h,hpp ~/Projects/my-cpp-app

# Compare projects
tokei ~/Projects/project1 ~/Projects/project2

# Track over time (with git)
for commit in $(git rev-list --all); do
  git checkout $commit
  tokei -o json >> ../tokei-history.json
done

# Exclude build artifacts
tokei --exclude build --exclude cmake-build-* --exclude .git

# Get statistics for specific components
tokei src/
tokei tests/
tokei include/

# Analyze Qt project
tokei -t cpp,h,ui,qrc ~/Projects/qt-app
```

---

## 🌐 Network & Connectivity

### httpie (http) - User-Friendly HTTP Client

**Basic Usage**
```bash
# GET requests
http GET https://api.github.com           # GET request
http https://api.github.com               # GET is default

# POST requests
http POST httpbin.org/post name=John age=30
http POST httpbin.org/post < data.json

# PUT/PATCH/DELETE
http PUT httpbin.org/put name=John
http PATCH httpbin.org/patch name=John
http DELETE httpbin.org/delete
```

**Headers and Authentication**
```bash
# Custom headers
http GET example.com User-Agent:MyApp/1.0
http GET example.com Authorization:"Bearer TOKEN"

# Authentication
http -a username:password GET example.com     # Basic auth
http --auth-type=digest -a user:pass GET url  # Digest auth

# Bearer token
http GET example.com Authorization:"Bearer ${TOKEN}"

# Multiple headers
http GET api.example.com \
  Authorization:"Bearer TOKEN" \
  Content-Type:application/json \
  X-Custom-Header:value
```

**Data and Files**
```bash
# JSON data (default)
http POST api.example.com name=John email=john@example.com

# Form data
http --form POST example.com name=John photo@file.jpg

# Upload file
http POST example.com/upload < file.txt
http --multipart POST example.com file@/path/to/file.pdf

# Raw body
http POST example.com --raw '{"key": "value"}'

# From file
http POST example.com @data.json
```

**Advanced Features**
```bash
# Download files
http --download https://example.com/file.zip

# Follow redirects
http --follow GET example.com

# Timeout
http --timeout=5 GET example.com

# Pretty print
http --pretty=all GET api.example.com        # Pretty everything
http --pretty=format GET api.example.com     # Just format, no colors
http --pretty=none GET api.example.com       # No formatting

# View request/response
http --print=HhBb POST api.example.com name=John
# H: request headers
# B: request body
# h: response headers
# b: response body

# Session support
http --session=user1 POST api.example.com/login username=user1
http --session=user1 GET api.example.com/profile  # Reuses cookies
```

**Real-World API Examples**
```bash
# GitHub API
http https://api.github.com/users/username
http https://api.github.com/users/username/repos

# POST JSON data
http POST https://api.example.com/users \
  name=John \
  email=john@example.com \
  age:=30              # := for non-string values

# Testing REST API
http GET localhost:8080/api/users
http POST localhost:8080/api/users name=Test email=test@example.com
http PUT localhost:8080/api/users/123 name=Updated
http DELETE localhost:8080/api/users/123

# Kubernetes API (with token)
http GET https://kubernetes.default.svc/api/v1/namespaces \
  Authorization:"Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"

# With query parameters
http GET api.example.com/search query==python limit==10

# Complex JSON body
http POST api.example.com/data \
  user[name]=John \
  user[email]=john@example.com \
  tags:='["dev","test"]' \
  metadata:='{"version": 1}'

# Save response to file
http GET api.example.com/data > response.json

# Pipe to jq
http GET api.example.com/users | jq '.[] | .name'
```

### dog/doggo - Modern DNS Client

**Basic Usage**
```bash
# Simple DNS lookup
dog example.com              # Default (A records)
doggo example.com            # Alternative syntax

# Specific record types
dog example.com A            # A records
dog example.com AAAA         # IPv6 records
dog example.com MX           # Mail exchange records
dog example.com NS           # Name server records
dog example.com TXT          # Text records
dog example.com CNAME        # Canonical name records
dog example.com SOA          # Start of authority
```

**Advanced Queries**
```bash
# Use specific DNS server
dog example.com @8.8.8.8     # Google DNS
dog example.com @1.1.1.1     # Cloudflare DNS
dog example.com @208.67.222.222  # OpenDNS

# Multiple queries
dog example.com A AAAA MX

# JSON output
dog --json example.com A

# Short output
dog --short example.com

# Time the query
dog --time example.com
```

**Real-World DNS Examples**
```bash
# Check mail servers
dog gmail.com MX

# Verify DNS propagation
dog mysite.com @8.8.8.8
dog mysite.com @1.1.1.1
dog mysite.com @local_dns_server

# Check SPF records
dog example.com TXT | grep spf

# Reverse DNS lookup
dog -x 8.8.8.8               # PTR record

# Check DNSSEC
dog example.com +dnssec

# Trace DNS resolution
dog --trace example.com

# Check all records
dog example.com ANY

# Kubernetes DNS debugging
dog kubernetes.default.svc.cluster.local
dog myservice.mynamespace.svc.cluster.local
```

### nmap - Network Scanner

**Basic Usage**
```bash
# Scan single host
nmap 192.168.1.1

# Scan range
nmap 192.168.1.1-254
nmap 192.168.1.0/24

# Scan specific ports
nmap -p 80,443 192.168.1.1
nmap -p 1-1000 192.168.1.1
nmap -p- 192.168.1.1         # All ports (1-65535)

# Fast scan (top 100 ports)
nmap -F 192.168.1.1

# Service version detection
nmap -sV 192.168.1.1

# OS detection
nmap -O 192.168.1.1
```

**Advanced Scanning**
```bash
# Aggressive scan
nmap -A 192.168.1.1          # OS detection, version, script, traceroute

# Stealth scan
nmap -sS 192.168.1.1         # SYN scan (requires root)

# UDP scan
nmap -sU 192.168.1.1

# Disable ping
nmap -Pn 192.168.1.1         # Scan even if host seems down

# Verbose output
nmap -v 192.168.1.1
nmap -vv 192.168.1.1         # Extra verbose

# Output formats
nmap -oN scan.txt 192.168.1.1       # Normal output
nmap -oX scan.xml 192.168.1.1       # XML output
nmap -oG scan.gnmap 192.168.1.1     # Grepable output
nmap -oA scan 192.168.1.1           # All formats
```

**Real-World Security Examples**
```bash
# Scan local network
nmap -sn 192.168.1.0/24      # Ping scan (host discovery)

# Find web servers
nmap -p 80,443 192.168.1.0/24

# Scan for vulnerabilities
nmap --script vuln 192.168.1.1

# Check specific service
nmap -p 22 --script ssh-auth-methods 192.168.1.1

# Scan Kubernetes nodes
nmap -p 6443,10250,10251,10252 kubernetes-node

# Check open ports on localhost
nmap localhost

# Fast scan of local services
nmap -F -T4 localhost

# Scan Docker bridge network
nmap 172.17.0.0/16

# Find live hosts quickly
nmap -sn --min-rate 100 192.168.1.0/24
```

---

## 🐙 Development & Git Tools

### lazygit - Terminal UI for Git

**Basic Usage**
```bash
# Launch lazygit
lg                           # Alias to lazygit
lazygit                      # Full command

# Navigate (Inside lazygit)
# 1-5 - Switch between panels (Files, Branches, Commits, Stash, Logs)
# Tab - Cycle through panels
# ? - Show help
# q - Quit
```

**Common Workflows**
```bash
# Staging and Committing (In Files panel)
# Space - Stage/unstage file
# a - Stage all
# c - Commit
# A - Amend commit
# e - Edit file

# Branch Operations (In Branches panel)
# Space - Checkout branch
# n - Create new branch
# d - Delete branch
# M - Merge into current branch
# r - Rebase current branch onto selected
# F - Pull
# P - Push
# f - Fast-forward

# Commit Operations (In Commits panel)
# Enter - View commit details
# Space - Checkout commit
# d - View diff
# c - Copy commit SHA
# r - Reword commit
# R - Rebase from commit
# s - Squash commits
# f - Fixup commit
# g - Reset to commit (soft)
# G - Reset to commit (hard)

# Stash Operations (In Stash panel)
# Space - Apply stash
# g - Pop stash
# d - Drop stash
```

**Advanced Features**
```bash
# From Files panel:
# i - Ignore file (add to .gitignore)
# d - Discard changes
# o - Open file in editor
# M - Resolve merge conflicts

# From Commits panel:
# C - Cherry-pick commit
# v - Paste (cherry-picked) commits
# t - Create tag
# T - Push tag

# Custom commands (configured in ~/.config/lazygit/config.yml)
# Can define shortcuts for common operations
```

**Real-World Workflows**
```bash
# Standard commit workflow
# 1. Open lazygit: lg
# 2. Press 'a' to stage all files (or Space for individual files)
# 3. Press 'c' to commit
# 4. Type commit message
# 5. Press 'P' to push

# Interactive rebase
# 1. Go to Commits panel (press 2)
# 2. Navigate to base commit
# 3. Press 'R' for interactive rebase
# 4. Use s/f/r to squash/fixup/reword
# 5. Confirm rebase

# Resolve merge conflicts
# 1. Files panel shows conflicts
# 2. Press 'M' to open merge tool
# 3. Or press 'o' to open in editor
# 4. After resolving, stage files and commit

# Quick stash workflow
# 1. Press 4 for Stash panel
# 2. lazygit auto-shows stashes
# 3. Space to apply, g to pop
```

### delta - Enhanced Git Diff

**Configuration (in ~/.gitconfig)**
```ini
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    features = line-numbers decorations
    syntax-theme = OneHalfDark
    plus-style = syntax "#003800"
    minus-style = syntax "#3f0001"

[delta "decorations"]
    commit-decoration-style = bold yellow box ul
    file-style = bold yellow ul
    file-decoration-style = none
    hunk-header-decoration-style = cyan box ul

[delta "line-numbers"]
    line-numbers-left-style = cyan
    line-numbers-right-style = cyan
    line-numbers-minus-style = 124
    line-numbers-plus-style = 28
```

**Usage**
```bash
# Delta is automatically used with git commands
git diff                     # Enhanced diff
git show                     # Enhanced show
git log -p                   # Enhanced log with patches
git blame file.cpp           # Enhanced blame

# Manual use
delta file1.cpp file2.cpp    # Diff two files

# Side-by-side mode
git diff | delta --side-by-side
git diff | delta -s          # Short flag

# Custom width
git diff | delta --width=200

# Navigate mode (n/N for next/prev change)
git diff | delta --navigate

# With line numbers
git diff | delta --line-numbers
```

### gh - GitHub CLI

**Basic Usage**
```bash
# Authentication
gh auth login                # Login to GitHub

# Repository operations
gh repo clone user/repo      # Clone repository
gh repo create new-repo      # Create new repository
gh repo view                 # View current repository
gh repo fork                 # Fork repository
```

**Pull Request Workflows**
```bash
# Create PR
gh pr create                 # Interactive PR creation
gh pr create --title "Fix bug" --body "Description"
gh pr create --fill          # Use commit message

# List PRs
gh pr list                   # List all PRs
gh pr list --state open      # Open PRs only
gh pr list --author @me      # Your PRs
gh pr list --label bug       # PRs with 'bug' label

# View PR
gh pr view 123               # View PR #123
gh pr view 123 --web         # Open in browser

# Checkout PR
gh pr checkout 123           # Checkout PR #123 locally

# Review PR
gh pr review 123 --approve
gh pr review 123 --comment --body "Looks good"
gh pr review 123 --request-changes --body "Please fix X"

# Merge PR
gh pr merge 123              # Interactive merge
gh pr merge 123 --squash     # Squash merge
gh pr merge 123 --rebase     # Rebase merge
gh pr merge 123 --merge      # Regular merge

# PR status
gh pr status                 # Your PR status
gh pr checks 123             # CI/CD checks for PR
```

**Issue Management**
```bash
# Create issue
gh issue create              # Interactive
gh issue create --title "Bug" --body "Description"

# List issues
gh issue list
gh issue list --assignee @me
gh issue list --label bug
gh issue list --state closed

# View issue
gh issue view 42
gh issue view 42 --comments

# Close/reopen
gh issue close 42
gh issue reopen 42

# Comment on issue
gh issue comment 42 --body "Fixed in PR #123"
```

**Workflow and CI/CD**
```bash
# View workflow runs
gh run list                  # List recent runs
gh run list --workflow=ci.yml

# View specific run
gh run view 123456
gh run view 123456 --log     # View logs

# Rerun workflow
gh run rerun 123456

# Watch workflow
gh run watch                 # Watch latest run
```

**Real-World Examples**
```bash
# Quick PR from current branch
git checkout -b feature/new-widget
# ... make changes ...
git commit -am "Add new widget"
git push
gh pr create --fill          # Create PR from commit message

# Review PRs
gh pr list | fzf | awk '{print $1}' | xargs gh pr checkout

# Create issue from terminal
gh issue create --title "$(git branch --show-current)" \
                --body "$(git log --oneline -1)"

# Check CI status
watch -n 5 gh pr checks

# Bulk close old issues
gh issue list --state open --json number --jq '.[].number' | \
  xargs -I {} gh issue close {}

# Create release
gh release create v1.0.0 --notes "Release notes"
gh release upload v1.0.0 ./build/myapp-linux-x64.tar.gz
```

### git-cliff - Changelog Generator

**Basic Usage**
```bash
# Generate changelog from git history
git cliff                    # Print to stdout
git cliff -o CHANGELOG.md    # Write to file

# For specific version
git cliff --tag v1.0.0

# Range of commits
git cliff v0.9.0..v1.0.0

# Prepend to existing changelog
git cliff --prepend CHANGELOG.md
```

**Configuration (cliff.toml)**
```toml
[changelog]
header = """
# Changelog\n
All notable changes to this project will be documented in this file.\n
"""
body = """
{% for group, commits in commits | group_by(attribute="group") %}
    ### {{ group | upper_first }}
    {% for commit in commits %}
        - {{ commit.message | upper_first }}\
    {% endfor %}
{% endfor %}\n
"""

[git]
conventional_commits = true
filter_unconventional = true
commit_parsers = [
    { message = "^feat", group = "Features"},
    { message = "^fix", group = "Bug Fixes"},
    { message = "^doc", group = "Documentation"},
    { message = "^perf", group = "Performance"},
    { message = "^refactor", group = "Refactor"},
    { message = "^style", group = "Styling"},
    { message = "^test", group = "Testing"},
    { message = "^chore", group = "Miscellaneous Tasks"},
]
```

### onefetch - Git Repository Summary

**Basic Usage**
```bash
# Show repository info
onefetch                     # Current repository
onefetch /path/to/repo       # Specific repository

# Customize output
onefetch --no-art            # Without ASCII art
onefetch --no-color-palette  # Without color palette
onefetch -l cpp              # Show specific language

# Different ASCII art
onefetch --ascii-language c++
onefetch --ascii-language python

# Output formats
onefetch --output json
onefetch --output yaml
```

**Real-World Usage**
```bash
# Quick project overview
cd ~/Projects/myapp && onefetch

# Include/exclude specific info
onefetch --no-title --no-color-palette

# Multiple repositories
for repo in ~/Projects/*; do
  echo "=== $repo ===" && onefetch "$repo" --no-art
done

# Export project stats
onefetch --output json > project-stats.json
```

### watchexec - File Watcher

**Basic Usage**
```bash
# Watch and run command on change
watchexec -e cpp,h make      # Rebuild on C++ file change
watchexec npm test           # Run tests on any file change

# Specific files/patterns
watchexec -w src/ make       # Watch src/ directory
watchexec -f '*.py' pytest   # Watch Python files

# Clear screen before running
watchexec -c pytest

# Debounce (wait for changes to settle)
watchexec -d 500 make        # Wait 500ms after last change

# Restart on change (kill previous run)
watchexec -r ./server
```

**Real-World Development Examples**
```bash
# Auto-rebuild C++ project
watchexec -e cpp,h,cmake -c 'cmake --build build'

# Run tests on change
watchexec -e cpp,h -c 'ctest --test-dir build --output-on-failure'

# Auto-format on save
watchexec -e cpp,h -c 'clang-format -i src/*.cpp include/*.h'

# Hot reload development server
watchexec -r -w src/ './build/myapp'

# Python development
watchexec -e py -c 'python script.py'
watchexec -e py -c 'pytest tests/'

# Qt UI compilation
watchexec -e ui -c 'uic MainWindow.ui -o ui_MainWindow.h'

# Docker image rebuild
watchexec -w Dockerfile -c 'docker build -t myapp .'

# Kubernetes manifest validation
watchexec -e yaml -c 'kubectl apply --dry-run=client -f deployment.yaml'

# Documentation generation
watchexec -e cpp,h -c 'doxygen Doxyfile'

# Run on specific events
watchexec --on-busy-update=restart -r npm start
```

### direnv - Directory-Specific Environments

**Setup**
```bash
# Install direnv (already in dotfiles)
# Hook into shell (add to ~/.zshrc, already configured)
eval "$(direnv hook zsh)"
```

**Basic Usage**
```bash
# Create .envrc in project directory
echo 'export PROJECT_ENV=development' > .envrc
echo 'export DATABASE_URL=localhost:5432' >> .envrc

# Allow the .envrc
direnv allow .

# Now environment is automatically loaded when you cd into directory
cd ~/Projects/myapp
echo $PROJECT_ENV         # outputs: development

# Leave directory, environment is unloaded
cd ..
echo $PROJECT_ENV         # outputs: (empty)
```

**Advanced .envrc Examples**
```bash
# C++ project with custom paths
# .envrc
export CMAKE_PREFIX_PATH=/usr/local/qt6
export CC=clang
export CXX=clang++
export MAKEFLAGS="-j8"
PATH_add ./build/bin

# Python project with venv
# .envrc
layout python python3.11
export DJANGO_SETTINGS_MODULE=myapp.settings.dev
dotenv .env.local

# Node.js project
# .envrc
use node 18
export NODE_ENV=development
PATH_add ./node_modules/.bin

# Kubernetes context
# .envrc
export KUBECONFIG=$PWD/kubeconfig.yaml
export KUBECTL_NAMESPACE=development

# Multi-language project
# .envrc
use nix
layout python3
use node 18
export DATABASE_URL=postgresql://localhost/myapp_dev
export REDIS_URL=redis://localhost:6379
```

**Pre-built Layouts**
```bash
# Activate Python virtual environment
layout python python3

# Activate Ruby environment
layout ruby

# Load .env file
dotenv

# Add directory to PATH
PATH_add bin/

# Load entire directory as env vars
dotenv_if_exists .env.local
```

---

## 🐳 Docker & Containers

### Docker with FZF Integration

**Container Management**
```bash
# Interactive container selection and exec
dexec() {
  local cid
  cid=$(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | \
        fzf --header-lines=1 | awk '{print $1}')
  [ -n "$cid" ] && docker exec -it "$cid" ${1:-bash}
}

# Interactive log viewer
dlog() {
  local cid
  cid=$(docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | \
        fzf --header-lines=1 | awk '{print $1}')
  [ -n "$cid" ] && docker logs -f "$cid"
}

# Interactive container stop
dstop() {
  docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | \
    fzf -m --header-lines=1 | awk '{print $1}' | xargs -r docker stop
}

# Interactive container removal
drm() {
  docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | \
    fzf -m --header-lines=1 | awk '{print $1}' | xargs -r docker rm
}

# Interactive image removal
drmi() {
  docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | \
    fzf -m --header-lines=1 | awk '{print $1":"$2}' | xargs -r docker rmi
}
```

**Docker Compose Workflows**
```bash
# View logs for specific service
docker-compose logs -f $(docker-compose ps --services | fzf)

# Restart specific service
docker-compose restart $(docker-compose ps --services | fzf)

# Exec into service
dcexec() {
  local service
  service=$(docker-compose ps --services | fzf)
  [ -n "$service" ] && docker-compose exec "$service" ${1:-bash}
}

# Scale services
docker-compose up -d --scale web=3
```

**Real-World Docker Examples**
```bash
# Clean up everything
docker system prune -af --volumes

# Clean up dangling images only
docker image prune

# View container resource usage
docker stats

# View container resource usage (one-time)
docker stats --no-stream

# Copy files from/to container
docker cp container:/app/log.txt ./
docker cp ./config.json container:/app/

# Export container as image
docker commit container new-image:tag

# Save/load images
docker save myimage:tag | gzip > myimage.tar.gz
docker load < myimage.tar.gz

# Inspect container networking
docker inspect container | jq '.[0].NetworkSettings'

# View container environment variables
docker inspect container | jq '.[0].Config.Env'

# Monitor container with ctop (if installed)
ctop

# Scan for vulnerabilities
trivy image myimage:tag

# Analyze image layers
dive myimage:tag
```

**Kubernetes-Docker Integration**
```bash
# Build and push to registry
docker build -t registry.example.com/myapp:v1.0 .
docker push registry.example.com/myapp:v1.0

# Update Kubernetes deployment
kubectl set image deployment/myapp myapp=registry.example.com/myapp:v1.0

# Port forward for local testing
docker run -d -p 8080:8080 myapp:latest
# Test locally before deploying to k8s

# Export Docker logs for debugging
docker logs container 2>&1 | tee debug.log
```

---

## 📚 Documentation & Presentation

### glow - Markdown Terminal Renderer

**Basic Usage**
```bash
# Render markdown file
glow README.md

# From URL
glow https://github.com/user/repo/blob/main/README.md

# From stdin
cat README.md | glow -

# Pager mode
glow -p README.md

# Width control
glow -w 80 README.md        # Fixed width
```

**Real-World Usage**
```bash
# View project README
glow README.md

# Preview before commit
glow -p CHANGELOG.md

# Read documentation
find docs/ -name "*.md" | fzf --preview 'glow {}'

# View GitHub README directly
glow https://raw.githubusercontent.com/user/repo/main/README.md

# Local documentation server
glow -s dark README.md       # Dark style
glow -s light README.md      # Light style
```

### pandoc - Universal Document Converter

**Basic Usage**
```bash
# Markdown to HTML
pandoc input.md -o output.html

# Markdown to PDF
pandoc input.md -o output.pdf

# Markdown to DOCX
pandoc input.md -o output.docx

# Multiple inputs
pandoc chapter1.md chapter2.md chapter3.md -o book.pdf
```

**Advanced Conversions**
```bash
# With table of contents
pandoc input.md -o output.pdf --toc --toc-depth=3

# With syntax highlighting
pandoc input.md -o output.html --highlight-style=tango

# With custom CSS
pandoc input.md -o output.html --css=style.css

# Standalone HTML
pandoc input.md -o output.html --standalone

# With metadata
pandoc input.md -o output.pdf \
  --metadata title="My Document" \
  --metadata author="Your Name" \
  --metadata date="2024-01-01"

# Different input/output formats
pandoc input.rst -f rst -t markdown -o output.md
pandoc input.org -f org -t latex -o output.tex
```

**Real-World Documentation Examples**
```bash
# Generate PDF documentation from multiple markdown files
pandoc docs/*.md -o manual.pdf \
  --toc \
  --number-sections \
  --highlight-style=tango \
  --metadata title="Project Manual" \
  --metadata author="Development Team"

# Convert C++ Doxygen XML to markdown
pandoc doxygen/xml/*.xml -o api-docs.md

# Create presentation from markdown
pandoc slides.md -o presentation.pptx

# Generate EPUB from markdown
pandoc book.md -o book.epub --toc

# Convert Jupyter notebook to markdown
pandoc notebook.ipynb -o notebook.md

# LaTeX to PDF with custom template
pandoc paper.tex -o paper.pdf --template=academic.latex

# Man page generation
pandoc README.md -s -t man -o myapp.1
```

### silicon - Code Screenshot Generator

**Basic Usage**
```bash
# Generate code screenshot
silicon main.cpp -o screenshot.png

# From stdin
cat main.cpp | silicon -o screenshot.png

# Specific language
silicon -l cpp input.txt -o output.png
silicon -l python script.py -o output.png

# Different theme
silicon --theme OneHalfDark main.cpp -o screenshot.png
silicon --theme Dracula main.cpp -o screenshot.png

# List available themes
silicon --list-themes
```

**Advanced Options**
```bash
# Line numbers
silicon --line-number main.cpp -o screenshot.png

# Line range
silicon --line-range 10:20 main.cpp -o screenshot.png

# Custom font
silicon --font 'JetBrains Mono' main.cpp -o screenshot.png

# No window controls
silicon --no-window-controls main.cpp -o screenshot.png

# Shadow
silicon --shadow-blur-radius 10 main.cpp -o screenshot.png

# Background color
silicon --background '#282c34' main.cpp -o screenshot.png

# Tab width
silicon --tab-width 4 main.cpp -o screenshot.png
```

**Real-World Examples**
```bash
# Create screenshots for documentation
silicon src/main.cpp -o docs/images/main.png \
  --theme OneHalfDark \
  --line-number \
  --font 'JetBrains Mono'

# Screenshot code snippet for blog
cat > snippet.cpp << EOF
int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF
silicon snippet.cpp -o blog-post-code.png --theme Dracula

# Batch generate screenshots
for file in examples/*.cpp; do
  silicon "$file" -o "screenshots/$(basename $file .cpp).png" \
    --line-number --theme OneHalfDark
done

# Screenshot with custom style
silicon main.cpp -o presentation-code.png \
  --no-window-controls \
  --shadow-blur-radius 15 \
  --background '#ffffff00' \
  --theme GitHub
```

### tldr/tealdeer - Simplified Man Pages

**Basic Usage**
```bash
# View simplified manual
tldr command                 # View tldr page
tldr tar                     # Example: tar command
tldr git-commit              # Git subcommands

# tealdeer (Rust implementation, faster)
tldr command

# Update cache
tldr --update

# List all pages
tldr --list

# Search for command
tldr --search keyword
```

**Real-World Examples**
```bash
# Quick reference for common commands
tldr tar                     # Tar examples
tldr ffmpeg                  # FFmpeg examples
tldr docker                  # Docker examples
tldr kubectl                 # Kubernetes examples

# When you forget syntax
tldr rsync                   # Quick rsync reference
tldr find                    # Find command patterns
tldr awk                     # Awk one-liners

# Language-specific pages
tldr -l es tar               # Spanish version
```

---

## 🚀 Shell & Productivity

### starship - Fast Prompt

**Configuration (~/.config/starship.toml)**
```toml
# Timeout for commands
command_timeout = 500

# Format
format = """
[┌───────────────────](bold green)
[│](bold green)$directory$git_branch$git_status
[└─>](bold green) """

# Directory
[directory]
truncation_length = 3
truncate_to_repo = true
style = "bold cyan"

# Git branch
[git_branch]
symbol = " "
style = "bold purple"

# Git status
[git_status]
style = "bold red"
conflicted = "⚔️ "
ahead = "⬆️ ${count}"
behind = "⬇️ ${count}"
diverged = "⬍ ⬆️ ${ahead_count} ⬇️ ${behind_count}"
untracked = "🤷 ${count}"
stashed = "📦 "
modified = "📝 ${count}"
staged = "✅ ${count}"
renamed = "👅 ${count}"
deleted = "🗑️ ${count}"

# Show command duration
[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow)"

# C++
[cmake]
symbol = "△ "
style = "bold blue"

# Python
[python]
symbol = " "
style = "bold green"

# Node.js
[nodejs]
symbol = " "
style = "bold green"

# Docker
[docker_context]
symbol = " "
style = "bold blue"

# Kubernetes
[kubernetes]
disabled = false
format = 'on [⎈ $context\($namespace\)](bold purple) '

[kubernetes.context_aliases]
"dev" = "development"
"prod" = "production"
```

**Features Automatically Shown**
- Current directory with Git repo awareness
- Git branch and status
- Programming language versions (Python, Node.js, Go, Rust, etc.)
- Package versions (shows package.json, Cargo.toml, etc.)
- Command execution time
- Exit code (if error)
- Kubernetes context
- Docker context
- Battery status (if laptop)

### zoxide - Smart Directory Jumping

**Basic Usage**
```bash
# Jump to directory (frecency-based)
z projects                   # Jump to most frequent 'projects' dir
z doc                        # Jump to most frequent 'doc' dir
z foo bar                    # Jump to directory matching 'foo' and 'bar'

# Interactive selection with fzf
zi projects                  # Interactive selection

# Add directory manually
zoxide add /path/to/dir

# Remove directory
zoxide remove /path/to/dir

# Query database
zoxide query projects        # Show matching paths
zoxide query -l              # List all paths with scores
zoxide query -s              # Show statistics
```

**Real-World Usage**
```bash
# Navigate to frequently used directories
z dot                        # Jump to ~/.dotfiles
z proj                       # Jump to ~/Projects
z conf                       # Jump to ~/.config

# Works from anywhere
pwd                          # /some/deep/nested/path
z myproject                  # Jump to ~/Projects/myproject

# Multiple matches - interactive selection
z test                       # If multiple dirs match, shows fzf selector

# Integration with other tools
cd "$(zoxide query projects)"     # Use in scripts

# View your most used directories
zoxide query -l | head -20
```

### mcfly - Neural Network Command History

**Basic Usage**
```bash
# Bound to Ctrl+R (replaces default history search)
# Press Ctrl+R to search command history with McFly

# Features:
# - Learns from your command patterns
# - Prioritizes commands based on:
#   - Current directory
#   - Exit status (successful commands ranked higher)
#   - Frequency of use
#   - Recency
# - Real-time fuzzy search

# Inside McFly (after pressing Ctrl+R):
# Type to search
# Up/Down arrows to navigate
# Enter to execute
# Tab to edit before executing
# Esc to cancel
```

**Integration**
```bash
# Already configured in ~/.zshrc
# mcfly init zsh is automatically loaded

# View McFly database
mcfly search "command"       # Search command history

# Train McFly
# Just use your shell normally, McFly learns automatically
```

### thefuck - Command Correction

**Basic Usage**
```bash
# Make a typo
gti status                   # typo: gti instead of git

# Fix it
fuck                         # Suggests: git status

# Press Enter to execute suggestion
# Press Ctrl+C to cancel

# Multiple suggestions
sl                           # typo: sl instead of ls
fuck                         # Shows multiple options to choose from
```

**Common Corrections**
```bash
# Forgotten sudo
apt install package
fuck                         # Suggests: sudo apt install package

# Git typos
git comit -m "message"
fuck                         # Suggests: git commit -m "message"

# Wrong command
pytohn script.py
fuck                         # Suggests: python script.py

# Docker typos
docker rn nginx
fuck                         # Suggests: docker run nginx

# Kubernetes
kuberctl get pods
fuck                         # Suggests: kubectl get pods
```

**Custom Rules**
```python
# ~/.config/thefuck/settings.py
# Configure which rules are enabled
```

### just - Command Runner (Modern Make Alternative)

**Basic Justfile**
```make
# justfile - Place in project root

# Variables
build_dir := "build"
app_name := "myapp"

# Default recipe (runs when you type 'just')
default:
    @just --list

# Build the project
build:
    mkdir -p {{build_dir}}
    cmake -B {{build_dir}} -G Ninja
    cmake --build {{build_dir}}

# Clean build artifacts
clean:
    rm -rf {{build_dir}}

# Run tests
test:
    ctest --test-dir {{build_dir}} --output-on-failure

# Format code
fmt:
    find src include -name '*.cpp' -o -name '*.h' | xargs clang-format -i

# Run linters
lint:
    cppcheck src/ include/

# Full CI workflow
ci: fmt lint build test

# Development mode with hot reload
dev:
    watchexec -e cpp,h -- just build && ./{{build_dir}}/{{app_name}}

# Generate documentation
docs:
    doxygen Doxyfile

# Install application
install:
    cmake --install {{build_dir}}

# Recipe with arguments
run *args:
    ./{{build_dir}}/{{app_name}} {{args}}

# Recipe with dependencies
release: clean build test
    echo "Building release..."
    cmake -B {{build_dir}}-release -DCMAKE_BUILD_TYPE=Release
    cmake --build {{build_dir}}-release
```

**Advanced Justfile Examples**
```make
# C++ Qt Project Justfile
qt_version := "6"
qmake := "qmake" + qt_version

configure:
    {{qmake}} -o {{build_dir}}/Makefile myapp.pro

build-qt: configure
    make -C {{build_dir}} -j8

run-qt: build-qt
    ./{{build_dir}}/myapp

# Python Project Justfile
venv:
    python3 -m venv venv
    . venv/bin/activate && pip install -r requirements.txt

test-py:
    pytest tests/ -v --cov=src

lint-py:
    ruff check src/
    mypy src/

fmt-py:
    black src/ tests/
    isort src/ tests/

# Docker Justfile
docker-build:
    docker build -t myapp:latest .

docker-run:
    docker run -d -p 8080:8080 --name myapp myapp:latest

docker-logs:
    docker logs -f myapp

docker-stop:
    docker stop myapp && docker rm myapp

# Kubernetes Justfile
k8s-apply:
    kubectl apply -f k8s/

k8s-delete:
    kubectl delete -f k8s/

k8s-logs:
    kubectl logs -f deployment/myapp

k8s-restart:
    kubectl rollout restart deployment/myapp

k8s-port-forward:
    kubectl port-forward service/myapp 8080:80
```

**Usage**
```bash
# List recipes
just                         # or: just --list

# Run recipe
just build
just test
just ci

# Recipe with arguments
just run --port 8080 --verbose

# Run from subdirectory (searches for justfile up the tree)
cd src/ && just build

# Choose recipe interactively
just --choose

# Show recipe
just --show build

# Run recipe even if up-to-date
just --force build

# Dry run
just --dry-run build

# Set variables
just build_dir=custom-build build
```

---

## 🔍 Code Quality & Linting

### shellcheck - Shell Script Analysis

**Basic Usage**
```bash
# Check script
shellcheck script.sh

# Check multiple scripts
shellcheck *.sh

# Severity levels
shellcheck -S error script.sh    # Only errors
shellcheck -S warning script.sh  # Warnings and above
shellcheck -S info script.sh     # All messages

# Output formats
shellcheck -f json script.sh     # JSON output
shellcheck -f gcc script.sh      # GCC-style output
shellcheck -f checkstyle script.sh  # Checkstyle XML
```

**Advanced Analysis**
```bash
# Ignore specific warnings
shellcheck -e SC2034 script.sh   # Ignore unused variable warning
shellcheck -e SC2086,SC2046 script.sh  # Multiple warnings

# Inline ignore
#!/bin/bash
# shellcheck disable=SC2034
unused_var="value"

# Follow sourced files
shellcheck -x script.sh

# Check stdin
cat script.sh | shellcheck -

# Specific shell dialect
shellcheck -s bash script.sh
shellcheck -s sh script.sh       # POSIX sh
```

**Real-World Examples**
```bash
# Check all shell scripts in project
find . -name '*.sh' -exec shellcheck {} \;

# Check with ripgrep
fd -e sh -x shellcheck

# Integrate into CI
shellcheck scripts/*.sh || exit 1

# With git hooks (pre-commit)
git diff --cached --name-only --diff-filter=ACM '*.sh' | xargs shellcheck

# Generate report
shellcheck -f json scripts/*.sh > shellcheck-report.json

# Check Makefile shell commands
shellcheck -f gcc Makefile  # Requires -f gcc for proper reporting
```

### yamllint - YAML Linter

**Basic Usage**
```bash
# Lint YAML file
yamllint file.yaml

# Lint directory
yamllint kubernetes/

# Lint with specific config
yamllint -c .yamllint.yaml file.yaml

# Output format
yamllint -f parsable file.yaml   # For editors/CI
yamllint -f github file.yaml     # GitHub Actions format
```

**Configuration (.yamllint.yaml)**
```yaml
extends: default

rules:
  line-length:
    max: 120
    level: warning
  indentation:
    spaces: 2
    indent-sequences: true
  comments:
    min-spaces-from-content: 1
  braces:
    min-spaces-inside: 0
    max-spaces-inside: 1
  brackets:
    min-spaces-inside: 0
    max-spaces-inside: 0
  trailing-spaces: enable
  truthy:
    allowed-values: ['true', 'false', 'yes', 'no']
```

**Real-World Kubernetes Examples**
```bash
# Lint Kubernetes manifests
yamllint k8s/*.yaml

# Lint with custom rules for k8s
yamllint -d "{extends: default, rules: {line-length: {max: 200}}}" k8s/

# Integrate with kubectl
yamllint deployment.yaml && kubectl apply --dry-run=client -f deployment.yaml

# Lint Ansible playbooks
yamllint playbooks/*.yml

# Lint CI/CD files
yamllint .github/workflows/*.yml
yamllint .gitlab-ci.yml

# Pre-commit hook
git diff --cached --name-only '*.yaml' '*.yml' | xargs yamllint
```

### hadolint - Dockerfile Linter

**Basic Usage**
```bash
# Lint Dockerfile
hadolint Dockerfile

# Lint with specific rules
hadolint --ignore DL3008 Dockerfile  # Ignore specific rule

# Output formats
hadolint -f json Dockerfile
hadolint -f codeclimate Dockerfile
hadolint -f gitlab_codeclimate Dockerfile

# Strict mode
hadolint --no-fail Dockerfile   # Report but don't fail
```

**Common Issues Detected**
```dockerfile
# Bad practices detected by hadolint:
# DL3008: Pin versions for apt-get
RUN apt-get install -y curl
# Fixed:
RUN apt-get install -y curl=7.68.0-1ubuntu2

# DL3009: Delete apt cache
RUN apt-get update && apt-get install -y curl
# Fixed:
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# DL3025: Use JSON for CMD/ENTRYPOINT
CMD npm start
# Fixed:
CMD ["npm", "start"]

# DL3018: Pin versions for apk
RUN apk add --no-cache curl
# Fixed:
RUN apk add --no-cache curl=7.79.1-r0
```

**Real-World Examples**
```bash
# Lint all Dockerfiles in project
fd -g 'Dockerfile*' -x hadolint

# Integrate with CI
hadolint Dockerfile || exit 1

# Generate report
hadolint -f json Dockerfile > hadolint-report.json

# Lint with custom rules
cat > .hadolint.yaml << EOF
ignored:
  - DL3008
  - DL3009
trustedRegistries:
  - docker.io
  - ghcr.io
EOF
hadolint Dockerfile

# Pre-build validation
hadolint Dockerfile && docker build -t myapp .
```

---

## 🎯 Advanced Workflows & Combinations

### Multi-Tool Pipeline Examples

**Log Analysis Pipeline**
```bash
# Find, filter, and analyze logs
# 1. Find log files from last hour
fd -e log --changed-within 1h /var/log |
  # 2. Search for errors
  xargs rg -i 'error|exception' |
  # 3. Extract and count error types
  cut -d: -f3 | sort | uniq -c | sort -rn |
  # 4. Show top 10 with nice formatting
  head -10 | bat -l log

# Alternative with better preview
fd -e log | fzf --preview 'bat --color=always {}' --preview-window up:60% |
  xargs rg -C 3 'ERROR'

# Real-time log monitoring with filtering
tail -f /var/log/app.log | rg --line-buffered 'ERROR|WARN' | bat --paging=never -l log
```

**Code Refactoring Pipeline**
```bash
# Find and replace function names across project
# 1. Find all occurrences
rg -l 'old_function_name' |
  # 2. Preview changes
  fzf -m --preview 'rg -C 3 --color=always old_function_name {}' |
  # 3. Perform replacement
  xargs sd 'old_function_name' 'new_function_name'

# Verify changes
rg 'new_function_name' --stats

# Alternative with git integration
# 1. Find files
rg -l 'old_function' |
  # 2. Replace
  xargs sd 'old_function' 'new_function'
# 3. Review with lazygit
lg
```

**Build Optimization Pipeline**
```bash
# Analyze and optimize build times
# 1. Measure current build time
hyperfine --warmup 1 --prepare 'make clean' 'make -j1'

# 2. Compare different thread counts
hyperfine -P threads 1 16 'make clean && make -j {threads}' \
  --export-markdown build-benchmark.md

# 3. Analyze which files take longest to compile
ninja -C build -t compdb | jq -r '.[].file' |
  xargs -I {} bash -c 'time g++ -c {} 2>&1' |
  grep real | sort -h

# 4. Use ccache and compare
hyperfine --warmup 1 \
  'make clean && make' \
  'make clean && CC="ccache gcc" CXX="ccache g++" make'
```

**Dependency Analysis Pipeline**
```bash
# Analyze C++ project dependencies
# 1. Extract include directives
rg '^#include [<"](.+)[>"]' -or '$1' -t cpp -t h | sort -u

# 2. Find which headers are most included
rg '^#include' -t cpp -t h | cut -d: -f2 | sort | uniq -c | sort -rn | head -20

# 3. Find circular dependencies
fd -e h -e hpp -x bash -c '
  echo "=== {} ==="
  rg -l "$(basename {} | sed "s/\.[^.]*$//")" --type cpp
'

# 4. Generate dependency graph (with graphviz)
rg '^#include [<"](.+)[>"]' -or '$1' -t cpp |
  awk '{print "\""FILENAME"\" -> \""$1"\""}' |
  sed 's/:/ /g' > deps.dot
dot -Tpng deps.dot -o dependencies.png
```

**Security Audit Pipeline**
```bash
# Comprehensive security check
# 1. Find potential vulnerabilities in C++ code
rg 'strcpy|strcat|sprintf|gets' -t cpp -t c --stats

# 2. Check for TODO security items
rg 'TODO.*security|FIXME.*security|XXX.*security' -i

# 3. Find hardcoded credentials
rg -i 'password\s*=|api_key\s*=|secret\s*=' --type yaml --type json --type env

# 4. Check Docker security
fd Dockerfile -x hadolint

# 5. Check YAML security
fd -e yaml -e yml -x yamllint

# 6. Scan dependencies (if using tools like trivy)
trivy fs --security-checks vuln,config .
```

**Git Repository Analysis**
```bash
# Comprehensive repo analysis
# 1. Code statistics
tokei

# 2. Visual summary
onefetch

# 3. Find large files in history
git rev-list --objects --all |
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
  awk '/^blob/ {print $3, $4}' | sort -rn | head -20

# 4. Find who wrote most code
git log --all --format='%aN' | sort | uniq -c | sort -rn | head -10

# 5. Commit activity over time
git log --date=short --pretty=format:%ad | sort | uniq -c

# 6. Find largest commits
git log --all --pretty=format:'%H' |
  xargs -I {} bash -c 'echo "$(git show --stat {} | tail -1)" {}'  |
  sort -rn | head -10
```

**Docker Development Workflow**
```bash
# Complete Docker development cycle
# 1. Lint Dockerfile
hadolint Dockerfile

# 2. Build image with progress
docker build -t myapp:dev --progress=plain .

# 3. Scan for vulnerabilities
trivy image myapp:dev

# 4. Test image
docker run --rm myapp:dev npm test

# 5. Compare image sizes
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" |
  grep myapp | sort -k3 -h

# 6. If all good, tag and push
docker tag myapp:dev myapp:v1.0.0
docker push myapp:v1.0.0

# All in one command
hadolint Dockerfile &&
  docker build -t myapp:dev . &&
  trivy image myapp:dev &&
  docker run --rm myapp:dev npm test &&
  docker tag myapp:dev myapp:v1.0.0
```

**Kubernetes Deployment Workflow**
```bash
# Complete k8s deployment cycle
# 1. Validate YAML
yamllint k8s/*.yaml

# 2. Dry run
kubectl apply --dry-run=client -f k8s/

# 3. Diff with server
kubectl diff -f k8s/

# 4. Apply with confirmation
kubectl apply -f k8s/ --record

# 5. Watch rollout
kubectl rollout status deployment/myapp

# 6. Check logs
kubectl logs -f deployment/myapp

# 7. Port forward for testing
kubectl port-forward service/myapp 8080:80

# Test endpoint
http localhost:8080/health

# All with just commands (using justfile)
just k8s-validate  # yamllint + kubectl dry-run
just k8s-apply     # kubectl apply
just k8s-wait      # wait for rollout
just k8s-test      # port-forward and test
```

**Performance Profiling Workflow**
```bash
# Profile C++ application
# 1. Build with profiling enabled
cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_FLAGS="-pg"
cmake --build build

# 2. Run application
./build/myapp

# 3. Analyze with gprof
gprof ./build/myapp gmon.out > profile.txt
bat profile.txt

# 4. Alternatively, use perf
perf record -g ./build/myapp
perf report

# 5. Memory profiling with Valgrind
valgrind --tool=massif ./build/myapp
massif-visualizer massif.out.*

# 6. Or use heaptrack
heaptrack ./build/myapp
heaptrack_gui heaptrack.myapp.*.gz
```

---

## 📖 Quick Reference

### Tool Categories Cheat Sheet

**File Operations**
```bash
eza -la --git            # List files with git status
fd -e cpp                # Find C++ files
bat file.cpp             # View with syntax highlighting
ranger                   # Visual file manager
ncdu                     # Disk usage analyzer
```

**Search & Text**
```bash
rg pattern               # Fast search
rg -t cpp 'class'        # Search C++ files only
sd 'old' 'new' file      # Replace text
choose 0 2               # Select columns
jq '.key' data.json      # JSON processing
yq '.spec' file.yaml     # YAML processing
```

**System Monitoring**
```bash
htop                     # Process monitor
btm                      # Modern system monitor
procs firefox            # Find process
dust                     # Disk usage
bandwhich                # Network usage (sudo)
hyperfine 'command'      # Benchmark command
tokei                    # Code statistics
```

**Network**
```bash
http GET api.com         # HTTP client
dog example.com          # DNS lookup
nmap 192.168.1.1         # Port scan
gping google.com         # Visual ping
```

**Git & Development**
```bash
lg                       # Lazygit TUI
gh pr create             # GitHub CLI
git diff | delta         # Enhanced diff
onefetch                 # Repo summary
watchexec make           # Auto-rebuild
direnv allow             # Enable env
```

**Docker & Kubernetes**
```bash
docker ps | fzf          # Interactive container
kubectl get pods         # List pods
trivy image app:latest   # Scan image
hadolint Dockerfile      # Lint Dockerfile
```

**Documentation**
```bash
glow README.md           # Render markdown
pandoc doc.md -o doc.pdf # Convert document
silicon code.cpp -o pic.png  # Code screenshot
tldr command             # Quick examples
```

**Quality**
```bash
shellcheck script.sh     # Lint shell script
yamllint file.yaml       # Lint YAML
hadolint Dockerfile      # Lint Dockerfile
```

### Common Workflows Quick Reference

**C++ Build Cycle**
```bash
# Standard
cmake -B build -G Ninja
cmake --build build
ctest --test-dir build

# With tools
fd -e cpp -e h | xargs clang-format -i
shellcheck scripts/*.sh
watchexec -e cpp,h 'cmake --build build'
```

**Python Development**
```bash
# Setup
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Development
watchexec -e py pytest
black src/
ruff check src/
```

**Kubernetes Management**
```bash
# Apply
yamllint k8s/*.yaml
kubectl apply -f k8s/ --dry-run=client
kubectl apply -f k8s/

# Monitor
kubectl get pods
kubectl logs -f deployment/app
kubectl port-forward svc/app 8080:80
```

**Git Workflow**
```bash
# Daily work
lg                       # Lazygit for staging/commits
gh pr create             # Create PR
gh pr list               # View PRs
git cliff -o CHANGELOG.md  # Generate changelog
```

### Performance Tips

**Faster Command Execution**
```bash
# Use modern tools
rg instead of grep       # 10-100x faster
fd instead of find       # 5-10x faster
bat instead of cat       # With features
eza instead of ls        # With icons/git

# Parallel execution
fd -e cpp -x parallel clang-format -i
rg -l pattern | parallel process_file

# Efficient piping
rg pattern | fzf | xargs $EDITOR  # Interactive selection
```

**Optimize Build Times**
```bash
# Use Ninja instead of Make
cmake -G Ninja

# Use ccache
export CC="ccache gcc"
export CXX="ccache g++"

# Parallel builds
make -j$(nproc)

# Benchmark to find optimal thread count
hyperfine -P threads 1 16 'make -j {threads}'
```

---

## 🎓 Learning Resources

### Man Pages and Help

```bash
# Traditional man pages
man command

# TLDR pages (examples)
tldr command

# Built-in help
command --help
command -h

# Detailed info
info command
```

### Online Resources

- **eza**: https://github.com/eza-community/eza
- **ripgrep**: https://github.com/BurntSushi/ripgrep
- **fd**: https://github.com/sharkdp/fd
- **bat**: https://github.com/sharkdp/bat
- **fzf**: https://github.com/junegunn/fzf
- **lazygit**: https://github.com/jesseduffield/lazygit
- **delta**: https://github.com/dandavison/delta
- **starship**: https://starship.rs
- **zoxide**: https://github.com/ajeetdsouza/zoxide

### Interactive Learning

```bash
# Explore fzf keybindings
# Press Ctrl+R to search history
# Press Ctrl+T to search files
# Press Alt+C to change directory

# Try lazygit
lg
# Press ? for help
# Navigate with 1-5 keys

# Experiment with ripgrep
rg --help
rg 'pattern' --type-list  # See available types

# Try hyperfine benchmarks
hyperfine --help
hyperfine 'sleep 0.1' 'sleep 0.2'
```

---

## 📝 Notes

### Fallback Chains

All modern tools have fallback chains to ensure compatibility:

```bash
# eza falls back to exa then ls
# fd falls back to fdfind then find
# bat falls back to batcat then cat
# rg falls back to grep

# This ensures commands work even if tools aren't installed
```

### Platform Differences

Some tools have different installation names:
- Ubuntu/Debian: `fd` → `fdfind`, `bat` → `batcat`
- macOS: Standard names via Homebrew
- Arch Linux: Standard names via pacman/AUR

The dotfiles handle these differences automatically with aliases.

### CI/CD Integration

All tools work in CI/CD pipelines with appropriate flags:
```bash
# Non-interactive mode
fd -e cpp -x clang-format --dry-run
rg pattern --quiet
shellcheck --format=json

# JSON output for parsing
tokei --output json
hyperfine --export-json results.json
```

---

**Total Tools Covered**: 70+ modern CLI utilities with 300+ practical examples
**Last Updated**: 2024-01-10
**Compatible With**: Ubuntu 22.04+, macOS 14+, Fedora, Arch Linux

For more dotfiles documentation, see:
- [DEVELOPER-WORKFLOWS.md](DEVELOPER-WORKFLOWS.md) - Development workflows
- [CPP-DEVELOPMENT.md](CPP-DEVELOPMENT.md) - C++ specific workflows
- [VIM-NEOVIM-ADVANCED.md](VIM-NEOVIM-ADVANCED.md) - Editor workflows
- [KUBERNETES-HOMELAB.md](KUBERNETES-HOMELAB.md) - Kubernetes workflows
