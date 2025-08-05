# Load shared config (modular dotfiles)
[[ -f ~/.aliases   ]] && source ~/.aliases
[[ -f ~/.exports   ]] && source ~/.exports
[[ -f ~/.functions ]] && source ~/.functions

# History config
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt append_history
setopt hist_ignore_dups
setopt share_history       # share history between all terminals
setopt hist_reduce_blanks  # remove extra whitespace before saving

# QOL improvements
setopt autocd              # change dir by typing just folder name
setopt globdots            # include dotfiles when globbing(*)
setopt interactivecomments # allow comments in interactive shells

# Local overrides for sensitive, temp or env specific settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
