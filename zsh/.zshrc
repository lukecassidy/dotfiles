#  Oh My Zsh & Theme
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git aws kubectl web-search)
source $ZSH/oh-my-zsh.sh

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

# Zsh QOL improvements
setopt autocd              # change dir by typing just folder name
setopt globdots            # include dotfiles when globbing(*)
setopt interactivecomments # allow comments in interactive shells

# Set Homebrew prefix based on architecture
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  else
    HOMEBREW_PREFIX="/usr/local"
  fi
fi

# Syntax highlighting and autosuggestions (manual source required for Homebrew installs)
[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Local overrides for sensitive, temp or env specific settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
    # eg: export AWS_CONFIG_FILE="path/to/aws/config"