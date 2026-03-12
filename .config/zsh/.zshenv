# Determine own path
local homezshenv=$HOME/.zshenv
export ZDOTDIR=$homezshenv:A:h

# XDG basedir spec compliance
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# Enable man pages
export MANPATH=$XDG_DATA_HOME/man:$MANPATH

export PAGER=less
export MANROFFOPT='-c'
export LESS='--use-color -g -R -M -x4 -X -F -Dd+r$Du+b'
export TZ=/etc/localtime

# Save history to XDG compliant location
HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/histfile

if [[ ":$FPATH:" != *":$ZDOTDIR/fpath:"* ]]; then export FPATH="$ZDOTDIR/fpath:$FPATH"; fi

typeset -U path PATH
path=(~/.local/bin $path)
export PATH
