# Dotfiles Makefile

.PHONY: help install uninstall test clean backup doctor

# Default target
.DEFAULT_GOAL := help

# Variables
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(DOTFILES_DIR)/backups
CONFIG_DIR := $(HOME)/.config

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dotfiles and dependencies
	@echo "Installing dotfiles..."
	@./install.sh

install-minimal: ## Install minimal dotfiles configuration
	@echo "Installing minimal configuration..."
	@./install.sh --minimal

install-dev: ## Install development tools and configurations
	@echo "Installing development environment..."
	@./scripts/install/install-dev-tools.sh
	@./install.sh

fonts: ## Install fonts only
	@echo "Installing fonts..."
	@./scripts/install/install-fonts.sh

cli-tools: ## Install CLI tools only
	@echo "Installing CLI tools..."
	@./scripts/install/install-cli-tools.sh

symlinks: ## Create symbolic links only
	@echo "Creating symbolic links..."
	@./scripts/utils/create-symlinks.sh

backup: ## Backup existing configurations
	@echo "Backing up existing configurations..."
	@./scripts/maintenance/backup-dotfiles.sh

test: ## Run all tests
	@echo "Running tests..."
	@./tests/test-installation.sh
	@./tests/test-aliases.sh
	@./tests/test-functions.sh

test-cross-platform: ## Run cross-platform compatibility tests
	@echo "Running cross-platform tests..."
	@./tests/test-cross-platform.sh

doctor: ## Run diagnostic checks
	@echo "Running diagnostic checks..."
	@./tools/doctor.sh

health-check: ## Run system health check
	@echo "Running health check..."
	@./scripts/maintenance/health-check.sh

update: ## Update dotfiles and dependencies
	@echo "Updating dotfiles..."
	@./scripts/maintenance/update-all.sh

clean: ## Clean temporary files and caches
	@echo "Cleaning temporary files..."
	@./scripts/maintenance/cleanup.sh

uninstall: ## Uninstall dotfiles
	@echo "Uninstalling dotfiles..."
	@./tools/uninstall.sh

migrate: ## Migrate from old dotfiles
	@echo "Migrating from old dotfiles..."
	@./tools/migrate.sh

new-machine: ## Set up dotfiles on a new machine
	@echo "Setting up new machine..."
	@./tools/workflows/new-machine.sh

# OS-specific targets
setup-arch: ## Set up Arch Linux specific configurations
	@./scripts/setup/setup-arch.sh

setup-macos: ## Set up macOS specific configurations
	@./scripts/setup/setup-macos.sh

setup-ubuntu: ## Set up Ubuntu specific configurations
	@./scripts/setup/setup-ubuntu.sh

setup-debian: ## Set up Debian specific configurations
	@./scripts/setup/setup-debian.sh

setup-fedora: ## Set up Fedora specific configurations
	@./scripts/setup/setup-fedora.sh