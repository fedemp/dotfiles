# Disable global zsh configuration
unsetopt GLOBAL_RCS

# Determine own path
local homezshenv=$HOME/.zshenv
export ZDOTDIR=$homezshenv:A:h
