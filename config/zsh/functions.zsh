# ~/.config/zsh/functions.zsh - Essential Shell Functions

# ============================================================================
# File Operations
# ============================================================================

# Create directory and cd into it
mkcd() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi
    mkdir -p "$1" && cd "$1"
}

# Quick backup with timestamp
backup() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: backup <file>"
        return 1
    fi
    local timestamp=$(date +%Y%m%d_%H%M%S)
    cp "$1" "${1}.bak.${timestamp}"
    echo "Backed up $1 to ${1}.bak.${timestamp}"
}

# Extract any archive format
extract() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: extract <archive>"
        return 1
    fi
    
    if [[ ! -f $1 ]]; then
        echo "Error: '$1' is not a valid file"
        return 1
    fi
    
    case $1 in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" ;;
        *.tar.xz|*.txz)   tar xJf "$1" ;;
        *.tar)            tar xf "$1" ;;
        *.bz2)            bunzip2 "$1" ;;
        *.rar)            unrar e "$1" ;;
        *.gz)             gunzip "$1" ;;
        *.zip)            unzip "$1" ;;
        *.Z)              uncompress "$1" ;;
        *.7z)             7z x "$1" ;;
        *.deb)            ar x "$1" ;;
        *.tar.lz)         tar xf "$1" ;;
        *.tar.lzma)       tar xf "$1" ;;
        *)                echo "'$1' cannot be extracted via extract()" ;;
    esac
}

# Create archive
archive() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: archive <archive_name> <file/directory>..."
        echo "Supported formats: tar.gz, tar.bz2, tar.xz, zip"
        return 1
    fi
    
    local archive_name="$1"
    shift
    
    case "$archive_name" in
        *.tar.gz|*.tgz)   tar czf "$archive_name" "$@" ;;
        *.tar.bz2|*.tbz2) tar cjf "$archive_name" "$@" ;;
        *.tar.xz|*.txz)   tar cJf "$archive_name" "$@" ;;
        *.zip)            zip -r "$archive_name" "$@" ;;
        *)                echo "Unsupported format. Use: .tar.gz, .tar.bz2, .tar.xz, or .zip" ;;
    esac
}

# ============================================================================
# Search and Find
# ============================================================================

# Find files by name with fzf preview
ff() {
    local selected
    if command -v fd &> /dev/null; then
        selected=$(fd --type f --hidden --follow --exclude .git | fzf --preview 'bat --color=always {}' --preview-window 'right:60%')
    else
        selected=$(find . -type f | fzf --preview 'cat {}' --preview-window 'right:60%')
    fi
    [[ -n $selected ]] && echo "$selected"
}

# Find directories with fzf
fd() {
    local selected
    if command -v fd &> /dev/null; then
        selected=$(fd --type d --hidden --follow --exclude .git | fzf --preview 'ls -la {}')
    else
        selected=$(find . -type d | fzf --preview 'ls -la {}')
    fi
    [[ -n $selected ]] && cd "$selected"
}

# Interactive grep with fzf
fgrep() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: fgrep <pattern>"
        return 1
    fi
    
    local selected
    if command -v rg &> /dev/null; then
        selected=$(rg --line-number --color=always "$1" | fzf --ansi --delimiter ':' --preview 'bat --color=always {1} --highlight-line {2}' --preview-window 'right:60%')
    else
        selected=$(grep -rn --color=always "$1" . | fzf --ansi --delimiter ':' --preview 'cat {1}' --preview-window 'right:60%')
    fi
    
    if [[ -n $selected ]]; then
        local file=$(echo "$selected" | cut -d: -f1)
        local line=$(echo "$selected" | cut -d: -f2)
        ${EDITOR:-vim} +"$line" "$file"
    fi
}

# ============================================================================
# Process Management
# ============================================================================

# Interactive process killer
fkill() {
    local pid
    if [[ "$UID" != "0" ]]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m --header='[kill:process]' | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m --header='[kill:process]' | awk '{print $2}')
    fi
    
    if [[ -n $pid ]]; then
        echo "Killing process(es): $pid"
        echo $pid | xargs kill -${1:-9}
    fi
}

# Show process tree for a specific process
ptree() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: ptree <process_name>"
        return 1
    fi
    
    local pids=$(pgrep "$1")
    if [[ -n $pids ]]; then
        for pid in $pids; do
            echo "Process tree for $1 (PID: $pid):"
            if command -v pstree &> /dev/null; then
                pstree -p "$pid"
            else
                ps --forest -o pid,ppid,user,comm -g "$pid"
            fi
        done
    else
        echo "No process found with name: $1"
    fi
}

# Monitor process CPU and memory usage
pmon() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: pmon <process_name>"
        return 1
    fi
    
    watch "ps aux | grep '$1' | grep -v grep"
}

# ============================================================================
# Development Tools
# ============================================================================

# Git clone and cd into directory
gclone() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: gclone <git_url> [directory]"
        return 1
    fi
    
    local repo_url="$1"
    local dir_name="$2"
    
    if [[ -z $dir_name ]]; then
        dir_name=$(basename "$repo_url" .git)
    fi
    
    git clone "$repo_url" "$dir_name" && cd "$dir_name"
}

# Create new git repository
ginit() {
    local repo_name="${1:-$(basename $(pwd))}"
    
    git init
    echo "# $repo_name" > README.md
    echo ".DS_Store\n*.log\n*.tmp\nnode_modules/\n.env" > .gitignore
    git add .
    git commit -m "Initial commit"
    echo "Repository '$repo_name' initialized with README and .gitignore"
}

# Show git branch in tree format
gbranch() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
}

# Interactive git add with fzf
gadd() {
    local selected
    selected=$(git status --porcelain | fzf -m --ansi --preview 'git diff --color=always {2}' | cut -c4-)
    
    if [[ -n $selected ]]; then
        echo "$selected" | xargs git add
        echo "Added files:"
        echo "$selected"
    fi
}

# ============================================================================
# Docker Functions
# ============================================================================

# Docker container management with fzf
dexec() {
    local container
    container=$(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | fzf --header-lines=1 | awk '{print $1}')
    
    if [[ -n $container ]]; then
        echo "Entering container: $container"
        docker exec -it "$container" ${1:-bash}
    fi
}

# Docker log viewer with fzf
dlog() {
    local container
    container=$(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | fzf --header-lines=1 | awk '{print $1}')
    
    if [[ -n $container ]]; then
        docker logs -f "$container"
    fi
}

# Clean docker system
dclean() {
    echo "Cleaning docker system..."
    docker system prune -f
    docker volume prune -f
    docker network prune -f
    echo "Docker cleanup complete!"
}

# ============================================================================
# Network Functions
# ============================================================================

# Port scan
portscan() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: portscan <host> [port_range]"
        echo "Example: portscan 192.168.1.1 1-1000"
        return 1
    fi
    
    local host="$1"
    local ports="${2:-1-1000}"
    
    if command -v nmap &> /dev/null; then
        nmap -p "$ports" "$host"
    else
        echo "nmap not available, using basic port check"
        for port in {22,23,25,53,80,110,443,993,995}; do
            timeout 1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null && echo "Port $port is open"
        done
    fi
}

# Check if port is open
port_check() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: port_check <host> <port>"
        return 1
    fi
    
    local host="$1"
    local port="$2"
    
    if timeout 3 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
        echo "Port $port on $host is open"
        return 0
    else
        echo "Port $port on $host is closed or filtered"
        return 1
    fi
}

# Get external IP and location
myiploc() {
    local ip=$(curl -s ifconfig.me)
    echo "External IP: $ip"
    if command -v curl &> /dev/null; then
        curl -s "http://ip-api.com/json/$ip" | jq -r '"Location: \(.city), \(.regionName), \(.country)"'
    fi
}

# Network speed test
speedtest() {
    if command -v speedtest-cli &> /dev/null; then
        speedtest-cli
    else
        echo "Installing speedtest-cli..."
        pip3 install speedtest-cli
        speedtest-cli
    fi
}

# ============================================================================
# System Administration
# ============================================================================

# Service management with fzf
service_manage() {
    if ! command -v systemctl &> /dev/null; then
        echo "systemctl not available"
        return 1
    fi
    
    local action="${1:-status}"
    local service
    
    service=$(systemctl list-units --type=service --all | fzf --header="Select service for $action:" | awk '{print $1}')
    
    if [[ -n $service ]]; then
        case $action in
            start|stop|restart|enable|disable|status)
                sudo systemctl "$action" "$service"
                ;;
            *)
                echo "Unknown action: $action"
                echo "Available actions: start, stop, restart, enable, disable, status"
                ;;
        esac
    fi
}

# Monitor log files
logwatch() {
    if [[ $# -eq 0 ]]; then
        # Interactive log file selection
        local logfile
        logfile=$(find /var/log -type f -name "*.log" 2>/dev/null | fzf --preview 'tail -20 {}')
        [[ -n $logfile ]] && tail -f "$logfile"
    else
        tail -f "$1"
    fi
}

# System resource monitoring
sysmon() {
    local interval="${1:-2}"
    
    watch -n "$interval" "
    echo '=== CPU Usage ==='
    grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)*100/(\$2+\$3+\$4+\$5)} END {print usage \"%\"}'
    echo
    echo '=== Memory Usage ==='
    free -h
    echo
    echo '=== Disk Usage ==='
    df -h / | tail -1
    echo
    echo '=== Load Average ==='
    uptime
    "
}

# ============================================================================
# Text Processing
# ============================================================================

# Column formatter
columnize() {
    if [[ $# -eq 0 ]]; then
        column -t
    else
        column -t -s "$1"
    fi
}

# Line numbering
number_lines() {
    if [[ $# -eq 0 ]]; then
        nl
    else
        nl "$1"
    fi
}

# Remove duplicate lines
dedup() {
    if [[ $# -eq 0 ]]; then
        sort | uniq
    else
        sort "$1" | uniq
    fi
}

# Word frequency counter
word_freq() {
    if [[ $# -eq 0 ]]; then
        tr ' ' '\n' | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr
    else
        tr ' ' '\n' < "$1" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr
    fi
}

# CSV processing
csv_preview() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: csv_preview <file.csv> [rows]"
        return 1
    fi
    
    local file="$1"
    local rows="${2:-10}"
    
    if command -v csvkit &> /dev/null; then
        csvlook "$file" | head -$((rows + 3))
    else
        column -t -s, "$file" | head -"$rows"
    fi
}

# ============================================================================
# Package Management Functions
# ============================================================================

# Interactive package search and install
pkg_search() {
    local package
    
    if command -v pacman &> /dev/null; then
        package=$(pacman -Ss "$1" | grep -E '^[^[:space:]]' | fzf --preview 'pacman -Si {1}' | awk '{print $1}')
        [[ -n $package ]] && sudo pacman -S "$package"
    elif command -v apt &> /dev/null; then
        package=$(apt search "$1" 2>/dev/null | grep -E '^[^[:space:]]' | fzf --preview 'apt show {1}' | awk -F'/' '{print $1}')
        [[ -n $package ]] && sudo apt install "$package"
    elif command -v brew &> /dev/null; then
        package=$(brew search "$1" | fzf --preview 'brew info {}')
        [[ -n $package ]] && brew install "$package"
    fi
}

# Show package information
pkg_info() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: pkg_info <package_name>"
        return 1
    fi
    
    if command -v pacman &> /dev/null; then
        pacman -Si "$1" 2>/dev/null || pacman -Qi "$1"
    elif command -v apt &> /dev/null; then
        apt show "$1" 2>/dev/null
    elif command -v brew &> /dev/null; then
        brew info "$1"
    fi
}

# List installed packages
pkg_list() {
    if command -v pacman &> /dev/null; then
        pacman -Q | fzf --preview 'pacman -Qi {1}'
    elif command -v apt &> /dev/null; then
        apt list --installed | fzf --preview 'apt show {1}'
    elif command -v brew &> /dev/null; then
        brew list | fzf --preview 'brew info {}'
    fi
}

# ============================================================================
# Utility Functions
# ============================================================================

# Weather function with location
weather() {
    local location="${1:-}"
    if [[ -n $location ]]; then
        curl -s "wttr.in/$location"
    else
        curl -s "wttr.in"
    fi
}

# QR code generator
qr() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: qr <text>"
        return 1
    fi
    
    if command -v qrencode &> /dev/null; then
        qrencode -t UTF8 "$1"
    else
        curl -s "qr-server.com/api/v1/create-qr-code/?size=200x200&data=$1"
    fi
}

# Password generator
genpass() {
    local length="${1:-16}"
    local charset="${2:-a-zA-Z0-9}"
    
    if command -v openssl &> /dev/null; then
        openssl rand -base64 32 | tr -d "=+/" | cut -c1-"$length"
    else
        tr -dc "$charset" < /dev/urandom | head -c "$length" && echo
    fi
}

# URL shortener
shorten_url() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: shorten_url <url>"
        return 1
    fi
    
    curl -s "http://tinyurl.com/api-create.php?url=$1"
}

# Encode/decode functions
base64encode() {
    if [[ $# -eq 0 ]]; then
        base64
    else
        echo -n "$1" | base64
    fi
}

base64decode() {
    if [[ $# -eq 0 ]]; then
        base64 -d
    else
        echo -n "$1" | base64 -d
    fi
}

# Hash functions
md5hash() {
    if [[ $# -eq 0 ]]; then
        md5sum
    else
        echo -n "$1" | md5sum | cut -d' ' -f1
    fi
}

sha256hash() {
    if [[ $# -eq 0 ]]; then
        sha256sum
    else
        echo -n "$1" | sha256sum | cut -d' ' -f1
    fi
}

# ============================================================================
# Tmux Functions
# ============================================================================

# Tmux session manager
tm() {
    if [[ $# -eq 1 ]]; then
        tmux has-session -t "$1" 2>/dev/null && tmux attach-session -t "$1" || tmux new-session -s "$1"
    else
        local session
        session=$(tmux list-sessions -F "#S" 2>/dev/null | fzf --prompt="Select session: " --height=40% --reverse)
        [[ -n $session ]] && tmux attach-session -t "$session"
    fi
}

# Create project session
tmux_project() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: tmux_project <project_name> [project_path]"
        return 1
    fi
    
    local project_name="$1"
    local project_path="${2:-$HOME/Projects/$project_name}"
    
    if [[ ! -d $project_path ]]; then
        echo "Project path doesn't exist: $project_path"
        return 1
    fi
    
    tmux new-session -d -s "$project_name" -c "$project_path"
    tmux split-window -h -c "$project_path"
    tmux split-window -v -c "$project_path"
    tmux select-pane -t 0
    tmux attach-session -t "$project_name"
}

# ============================================================================
# File Sync and Backup
# ============================================================================

# Rsync wrapper with progress
rsync_copy() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: rsync_copy <source> <destination>"
        return 1
    fi
    
    rsync -av --progress --stats "$1" "$2"
}

# Backup directory with timestamp
backup_dir() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: backup_dir <directory>"
        return 1
    fi
    
    local source="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_name="${source%/}_backup_${timestamp}.tar.gz"
    
    tar -czf "$backup_name" -C "$(dirname "$source")" "$(basename "$source")"
    echo "Backup created: $backup_name"
}

# ============================================================================
# Help Function
# ============================================================================

# Show available custom functions
show_functions() {
    echo "Available custom functions:"
    echo
    echo "File Operations:"
    echo "  mkcd <dir>          - Create directory and cd into it"
    echo "  backup <file>       - Backup file with timestamp"
    echo "  extract <archive>   - Extract any archive format"
    echo "  archive <name> <files> - Create archive"
    echo
    echo "Search & Find:"
    echo "  ff                  - Find files with fzf preview"
    echo "  fd                  - Find directories with fzf"
    echo "  fgrep <pattern>     - Interactive grep with fzf"
    echo
    echo "Process Management:"
    echo "  fkill               - Interactive process killer"
    echo "  ptree <process>     - Show process tree"
    echo "  pmon <process>      - Monitor process resources"
    echo
    echo "Development:"
    echo "  gclone <url>        - Git clone and cd"
    echo "  ginit [name]        - Initialize git repository"
    echo "  gbranch             - Show git branch tree"
    echo "  gadd                - Interactive git add"
    echo
    echo "Docker:"
    echo "  dexec               - Interactive docker exec"
    echo "  dlog                - Interactive docker logs"
    echo "  dclean              - Clean docker system"
    echo
    echo "Network:"
    echo "  portscan <host>     - Scan ports on host"
    echo "  port_check <host> <port> - Check if port is open"
    echo "  myiploc             - Show IP and location"
    echo "  speedtest           - Network speed test"
    echo
    echo "System Admin:"
    echo "  service_manage      - Interactive service management"
    echo "  logwatch [file]     - Monitor log files"
    echo "  sysmon [interval]   - System resource monitor"
    echo
    echo "Utilities:"
    echo "  weather [location]  - Get weather information"
    echo "  qr <text>          - Generate QR code"
    echo "  genpass [length]   - Generate password"
    echo "  tm [session]       - Tmux session manager"
}