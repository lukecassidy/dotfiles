# Configuration
BACKUP_DIR := $(HOME)/.dotfiles_backup_$(shell date +%Y%m%d_%H%M%S)
DOTFILES_DIR := $(CURDIR)
DOTFILES := .zshrc .vimrc .gitconfig .aliases .exports .functions .aicontext .bashrc
PACKAGES := zsh vim git shell bash ai
BREWFILE := $(DOTFILES_DIR)/Brewfile
STOW_TARGET := $(HOME)

# Default target
all: help

install:
	@$(MAKE) backup-originals
	@echo "## Starting dotfiles install"

	@if ! command -v brew >/dev/null 2>&1; then \
		echo "# Installing Homebrew"; \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		eval "$$(/opt/homebrew/bin/brew shellenv)"; \
	fi

	@echo "## Installing packages from Brewfile"
	@brew bundle --file=$(BREWFILE)

	@$(MAKE) stow

backup-originals:
	@echo "## Backing up non-symlinked dotfiles to: $(BACKUP_DIR)"
	@mkdir -p $(BACKUP_DIR)
	@for file in $(DOTFILES); do \
		target="$(HOME)/$$file"; \
		if [ -e "$$target" ] && [ ! -L "$$target" ]; then \
			mv "$$target" "$(BACKUP_DIR)/"; \
		fi; \
	done

stow:
	@echo "## Stowing packages: $(PACKAGES)"
	@cd $(DOTFILES_DIR) && stow --target=$(STOW_TARGET) $(PACKAGES)

unstow:
	@echo "## Unstowing packages: $(PACKAGES)"
	@cd $(DOTFILES_DIR) && stow --target=$(STOW_TARGET) -D $(PACKAGES)

restow:
	@$(MAKE) unstow
	@$(MAKE) stow

clean:
	@echo "## Removing all backup directories"
	@rm -rf $(HOME)/.dotfiles_backup_*

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
	@echo "  backup-originals  Move real (non-symlinked) dotfiles to backup directory"
	@echo "  stow              Stow dotfiles to home directory"
	@echo "  unstow            Unstow directory symlinks"
	@echo "  restow            Unstow and then stow dotfiles"
	@echo "  clean             Remove all dotfile backup directories"
	@echo "  status            Show current dotfile symlinks"
	@echo "  help              Show this help message"
	@echo ""

.PHONY: all install backup-originals stow unstow restow clean help status
