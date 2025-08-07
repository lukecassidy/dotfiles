# Set default dotfiles dir
DOTFILES_DIR := $(CURDIR)
STOW_TARGET := $(HOME)

# List of stow package dirs
PACKAGES := zsh vim git shell bash ai

.PHONY: all install stow unstow restow brew clean status help

# Default target
all: help

install:
	@echo "Running install.sh"
	@bash $(DOTFILES_DIR)/install.sh

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
	@echo "  install        Run install script to bootstrap dotfiles"
	@echo "  stow           Stow dotfiles to home dir"
	@echo "  unstow         Unstow dir symlinks"
	@echo "  restow         Unstow and stow dotfiles"
	@echo "  brew           Install packages from Brewfile"
	@echo "  clean          Remove backup files"
	@echo "  status         Show currently stowed files"
	@echo "  help           Show this help message"
	@echo ""
