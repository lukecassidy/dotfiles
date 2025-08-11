# Dotfiles
The tools I need to get my environment up and running.

It takes care of:
- Keeping your dotfiles in sync across machines with [GNU Stow](https://www.gnu.org/software/stow/)
- Installing packages and apps with Homebrew
- Getting Oh My Zsh up and running
- Backing up any existing dotfiles before making changes
- Applying macOS tweaks so my setup always feels just right

## Setup
```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
make install
```

## Makefile Commands
| Command               | Description                                                                  |
| --------------------- | ---------------------------------------------------------------------------- |
| `make install`        | Backup dotfiles, install brew packages, stow dotfiles and apply mac defaults |
| `make backup-create`  | Backup existing (non-symlinked) dotfiles                                     |
| `make backup-restore` | Restore dotfiles from a backup                                               |
| `make backup-clean`   | Remove all dotfile backup directories                                        |
| `make stow`           | Apply stow symlinks                                                          |
| `make unstow`         | Remove stow symlinks                                                         |
| `make brew-update`    | Update Homebrew packages                                                     |
| `make brew-dump`      | Regenerate repo Brewfile from current machine installs                       |
| `make macos-setup`    | Apply macOS defaults                                                         |
