# Makefile for managing dotfiles
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

DOTFILES_DIR := $(CURDIR)
STOW_TARGET  := $(HOME)
BACKUP_DIR   := $(HOME)/.dotfiles_backup_$(shell date +%Y%m%d_%H%M%S)
BREWFILE     := $(DOTFILES_DIR)/Brewfile
OMZ_DIR      := $(HOME)/.oh-my-zsh

PACKAGES := zsh vim git shell bash ai
DOTFILES := .zshrc .vimrc .gitconfig .aliases .exports .functions .aicontext .bashrc

# Make 'help' the default target when running with no arguments
.DEFAULT_GOAL := help
all: help

install:
	@$(MAKE) backup-create
	@echo ">> Starting dotfiles install"

	@if ! command -v brew >/dev/null 2>&1; then \
		echo ">> Installing Homebrew"; \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		eval "$$(/opt/homebrew/bin/brew shellenv)"; \
	fi

	@if ! command -v stow >/dev/null 2>&1; then \
		echo ">> Installing Stow"; \
		brew install stow; \
	fi

	@echo ">> Installing packages from Brewfile"
	@brew bundle --file=$(BREWFILE) --no-upgrade || true

    # Install omz via shallow clone to avoid side effects and keep it lightweight
	@if [ ! -d "$(OMZ_DIR)" ]; then \
		echo ">> Installing Oh My Zsh"; \
		git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$(OMZ_DIR)"; \
	fi

	@$(MAKE) stow

stow:
	@echo ">> Stowing packages: $(PACKAGES)"
	@cd $(DOTFILES_DIR) && stow --target=$(STOW_TARGET) $(PACKAGES)

unstow:
	@echo ">> Unstowing packages: $(PACKAGES)"
	@cd $(DOTFILES_DIR) && stow --target=$(STOW_TARGET) -D $(PACKAGES)

backup-create:
	@echo ">> Backing up non-symlinked dotfiles to: $(BACKUP_DIR)"
	@mkdir -p $(BACKUP_DIR)
	@for file in $(DOTFILES); do \
		target="$(HOME)/$$file"; \
		if [ -e "$$target" ] && [ ! -L "$$target" ]; then \
			mv "$$target" "$(BACKUP_DIR)/"; \
		fi; \
	done

backup-restore:
	@echo ">> Available backups:"
	@select dir in $$(ls -1dt $(HOME)/.dotfiles_backup_* 2>/dev/null); do \
		if [ -n "$$dir" ]; then \
			echo ">> Restoring from: $$dir"; \
			$(MAKE) unstow; \
			for f in $(DOTFILES); do \
				[ -e "$$dir/$$f" ] && cp "$$dir/$$f" "$(HOME)/$$f" && echo "Restored $$f"; \
			done; \
			break; \
		else \
			echo "Invalid selection."; \
		fi; \
	done

backup-clean:
	@echo ">> Removing all backup directories"
	@rm -rf $(HOME)/.dotfiles_backup_*

brew-update:
	@brew update && brew upgrade && brew cleanup -s

brew-dump:
	@brew bundle dump --file=$(BREWFILE) --force --no-vscode

status:
	@echo "Currently stowed files pointing to dotfiles:"
	@for f in $$(find $(HOME) -maxdepth 1 -type l); do \
		target=$$(readlink "$$f"); \
		case $$target in \
			*dotfiles*) echo "$$f -> $$target";; \
		esac; \
	done

help:
	@echo ""
	@echo "Available make commands:"
	@echo ""
	@echo "  install           Backup originals, install Homebrew and packages, stow dotfiles"
	@echo "  stow              Stow dotfiles to home directory"
	@echo "  unstow            Unstow directory symlinks"
	@echo "  backup-create     Move real (non-symlinked) dotfiles to backup directory"
	@echo "  backup-restore    Restore dotfiles from a backup directory"
	@echo "  backup-clean      Remove all dotfile backup directories"
	@echo "  status            Show current dotfile symlinks"
	@echo "  brew-update       Handy way to update Brew"
	@echo "  brew-dump         Dump the brewfile"
	@echo "  help              Show this help message"
	@echo ""

.PHONY: all install stow unstow backup-create backup-restore backup-clean brew-update brew-dump status help
