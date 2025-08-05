#!/usr/bin/env bash

# Stop if anything goes wrong
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
PACKAGES=(zsh git vim shell)

echo "Starting dotfiles setup..."

# Install Homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
  echo "  Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install packages from Brewfile
echo "  Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# Backup existing dotfiles
echo "  Backing up existing dotfiles..."
mkdir -p "$BACKUP_DIR"
for file in .zshrc .vimrc .gitconfig .aliases .exports .functions; do
  target="$HOME/$file"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "$BACKUP_DIR/"
  fi
done

# Stow dotfiles
echo "  Linking dotfiles using Stow..."
cd "$DOTFILES_DIR"
stow --target="$HOME" "${PACKAGES[@]}"

# Fin
echo "Setup complete! Run: exec \"\$SHELL\" to reload your environment."
