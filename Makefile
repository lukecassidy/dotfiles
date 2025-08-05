# Set default dotfiles dir
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STOW_TARGET := $(HOME)

# List of stow package dirs
PACKAGES := zsh vim git shell bash

.PHONY: all stow unstow restow install clean brew help

# Default target
all: help

install:
	@echo "Running install.sh"
	@chmod +x $(DOTFILES_DIR)/install.sh
	@$(DOTFILES_DIR)/install.sh

stow:
	@echo "Stowing packages: $(PACKAGES)"
	@cd $(DOTFILES_DIR) && stow --target=$(STOW_TARGET) $(PACKAGES)

unstow:
	@echo "Unstowing packages: $(PACKAGES)"
	@cd $(DOTFILES_DIR) && stow --target=$(STOW_TARGET) -D $(PACKAGES)

restow: unstow stow

brew:
	@echo "Installing packages from Brewfile"
	@brew bundle --file=$(DOTFILES_DIR)/Brewfile

clean:
	@echo "Removing backup files"
	@rm -rf ~/.dotfiles_backup_*

help:
	@echo ""
	@echo "Available make commands:"
	@echo ""
	@echo "  install        Run install script to bootstrap dotfiles"
	@echo "  stow           Stow dotfiles to home dir"
	@echo "  unstow         Unstow dir symlinks"
	@echo "  restow         Unstow and stow dotfiles"
	@echo "  brew           Install packages from Brewfile"
	@echo "  clean          Remove backup files"
	@echo "  help           Show this help message"
	@echo ""
