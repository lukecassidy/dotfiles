# Dotfiles
The tools I need to get my environment up and running.

It takes care of:
- Keeping your dotfiles in sync across machines with [GNU Stow](https://www.gnu.org/software/stow/)
- Installing packages and apps with Homebrew
- Getting Oh My Zsh up and running
- Backing up any existing dotfiles before making changes
- Applying macOS tweaks for that consistent feel

---

## Setup
```bash
git clone git@github.com:lukecassidy/dotfiles.git
cd dotfiles
make install
```

![Image](https://github.com/user-attachments/assets/5b4dd702-771d-4079-8398-f69aa006a5b8)

--- 

## Makefile Commands
| Command               | Description                                                                  |
| --------------------- | ---------------------------------------------------------------------------- |
| `make install`        | Backup dotfiles, install brew packages, stow dotfiles and apply mac defaults |
| `make stow`           | Apply stow symlinks                                                          |
| `make unstow`         | Remove stow symlinks                                                         |
| `make backup-create`  | Backup existing (non-symlinked) dotfiles                                     |
| `make backup-restore` | Restore dotfiles from a backup                                               |
| `make backup-clean`   | Remove all dotfile backup directories                                        |
| `make brew-dump`      | Regenerate repo Brewfile from current machine installs                       |
| `make brew-upgrade`   | Upgrading all installed brew packages                                        |
| `make macos-setup`    | Apply macOS defaults                                                         |
| `make status`         | Show current dotfile symlinks                                                |
| `make help`           | Show Makefile help message                                                   |
