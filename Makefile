# Set default dotfiles dir
DOTFILES_DIR := $(CURDIR)
STOW_TARGET := $(HOME)
BACKUP_DIR := $(HOME)/.dotfiles_backup_$(shell date +%Y%m%d_%H%M%S)

# List of stow package dirs
PACKAGES := zsh vim git shell bash ai

.PHONY: all install backup-originals stow unstow restow brew clean help status

# Default target
all: help

install:
	@$(MAKE) backup-originals
	@echo "Starting dotfiles install..."

	@# Install Homebrew if not installed
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Installing Homebrew..."; \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		eval "$$(/opt/homebrew/bin/brew shellenv)"; \
	fi

	@# Install packages from Brewfile
	@echo "Installing packages from Brewfile..."
	@brew bundle --file="$(DOTFILES_DIR)/Brewfile"

	@# Stow dotfiles
	@$(MAKE) stow

backup-originals:
	@echo "Backing up original, non-symlinked dotfiles to: $(BACKUP_DIR)"
	@mkdir -p $(BACKUP_DIR)
	@for file in .zshrc .vimrc .gitconfig .aliases .exports .functions; do \
		target="$(HOME)/$$file"; \
		if [ -e "$$target" ] && [ ! -L "$$target" ]; then \
			mv "$$target" "$(BACKUP_DIR)/"; \
		fi; \
	done

stow:
	@echo "Stowing packages: $(PACKAGES)"
	@cd $(DOTFILES_DIR) && stow --target=$(STOW_TARGET) $(PACKAGES)

unstow:
	@echo "Unstowing packages: $(PACKAGES)"
	@cd $(DOTFILES_DIR) && stow --target=$(STOW_TARGET) -D $(PACKAGES)

restow:
	@$(MAKE) unstow
	@$(MAKE) stow

brew:
	@echo "Installing packages from Brewfile"
	@brew bundle --file=$(DOTFILES_DIR)/Brewfile

clean:
	@echo "Removing backup files"
	@rm -rf ~/.dotfiles_backup_*

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
	@echo "  install           Backup originals, install Homebrew & packages, stow dotfiles"
	@echo "  backup-originals  Move only real (non-symlinked) dotfiles to a backup dir"
	@echo "  stow              Stow dotfiles to home dir"
	@echo "  unstow            Unstow dir symlinks"
	@echo "  restow            Unstow and stow dotfiles"
	@echo "  brew              Install packages from Brewfile"
	@echo "  clean             Remove backup files"
	@echo "  status            Show current dotfile symlinks"
	@echo "  help              Show this help message"
	@echo ""
