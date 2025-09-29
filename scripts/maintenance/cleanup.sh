#!/usr/bin/env bash
# Cleanup script for dotfiles

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

cleanup_temp_files() {
    local temp_dir="${TMPDIR:-/tmp}"
    log_info "Cleaning up temporary files..."
    
    # Clean dotfiles-related temp files
    find "$temp_dir" -name "dotfiles-*" -type f -mtime +7 -delete 2>/dev/null || true
    
    # Clean oh-my-zsh installer temp files
    find "$temp_dir" -name "oh-my-zsh-*" -type f -mtime +7 -delete 2>/dev/null || true
    
    # Clean homebrew temp files (macOS)
    if [[ -d "/tmp/homebrew-*" ]]; then
        find /tmp -name "homebrew-*" -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null || true
    fi
    
    log_success "Temporary files cleaned"
}

cleanup_logs() {
    log_info "Cleaning up old log files..."
    
    # Clean dotfiles logs if they exist
    if [[ -d "$DOTFILES_DIR/logs" ]]; then
        find "$DOTFILES_DIR/logs" -name "*.log" -mtime +30 -delete 2>/dev/null || true
    fi
    
    # Clean system logs (if accessible)
    if [[ -w /var/log ]]; then
        find /var/log -name "*.log.old" -mtime +30 -delete 2>/dev/null || true
    fi
    
    log_success "Log files cleaned"
}

cleanup_caches() {
    log_info "Cleaning up caches..."
    
    # Clean package manager caches
    if command -v brew &> /dev/null; then
        log_info "Cleaning Homebrew cache..."
        brew cleanup --prune=7 2>/dev/null || true
    fi
    
    if command -v apt &> /dev/null; then
        log_info "Cleaning apt cache..."
        sudo apt-get autoremove -y 2>/dev/null || true
        sudo apt-get autoclean 2>/dev/null || true
    fi
    
    if command -v yum &> /dev/null; then
        log_info "Cleaning yum cache..."
        sudo yum clean all 2>/dev/null || true
    fi
    
    if command -v dnf &> /dev/null; then
        log_info "Cleaning dnf cache..."
        sudo dnf clean all 2>/dev/null || true
    fi
    
    # Clean user caches
    if [[ -d "$HOME/.cache" ]]; then
        find "$HOME/.cache" -type f -atime +30 -delete 2>/dev/null || true
    fi
    
    log_success "Caches cleaned"
}

cleanup_broken_symlinks() {
    log_info "Cleaning up broken symbolic links..."
    
    # Check common directories for broken symlinks
    local dirs=("$HOME" "$HOME/.config" "$HOME/.local")
    
    for dir in "${dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            find "$dir" -type l -exec test ! -e {} \; -delete 2>/dev/null || true
        fi
    done
    
    log_success "Broken symbolic links cleaned"
}

cleanup_old_backups() {
    log_info "Cleaning up old backup files..."
    
    # Clean dotfiles backups older than 60 days
    if [[ -d "$DOTFILES_DIR/backups" ]]; then
        find "$DOTFILES_DIR/backups" -name "*.backup" -mtime +60 -delete 2>/dev/null || true
    fi
    
    # Clean home directory backups
    find "$HOME" -name "*.bak" -o -name "*.backup" -o -name "*.old" | while read -r backup_file; do
        if [[ -f "$backup_file" ]] && [[ $(find "$backup_file" -mtime +30 2>/dev/null) ]]; then
            rm -f "$backup_file" 2>/dev/null || true
        fi
    done
    
    log_success "Old backup files cleaned"
}

show_disk_usage() {
    log_info "Disk usage summary:"
    echo
    
    if command -v df &> /dev/null; then
        df -h / 2>/dev/null || true
    fi
    
    echo
    log_info "Home directory size:"
    if command -v du &> /dev/null; then
        du -sh "$HOME" 2>/dev/null || true
    fi
}

main() {
    log_info "Starting cleanup process..."
    echo
    
    cleanup_temp_files
    cleanup_logs
    cleanup_caches
    cleanup_broken_symlinks
    cleanup_old_backups
    
    echo
    show_disk_usage
    echo
    
    log_success "Cleanup completed successfully!"
}

# Run main function
main "$@"