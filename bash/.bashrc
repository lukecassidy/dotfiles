# ~/.bashrc

source ~/.aliases
source ~/.exports
source ~/.functions

# Local overrides for sensitive, temp or environment specific settings
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
