# Disable global zsh configuration
unsetopt GLOBAL_RCS

# Determine own path
local homezshenv=$HOME/.zshenv
export ZDOTDIR=$homezshenv:A:h

# XDG basedir spec compliance
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=${TMPDIR:-/tmp/runtime-$USER}

export EDITOR=nvim
export PAGER=less
export LESS="-n -R -i -g -M -x4 -X -F -z-1"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--color=16'
export TZ=/etc/localtime
fpath=($HOME/.functions $fpath)
export NNN_FCOLORS='c1e20402006006f701d6ab05'
export NNN_PLUG='p:-!less -iR "$nnn"*;g:-!git diff -- "$nnn"*'
export NNN_USE_EDITOR=1
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

fpath=($ZDOTDIR/fpath $fpath)

setopt EXTENDED_GLOB

# Initialize path.
# If dirs are missing, they won't be added due to null globbing.
path=(
	$HOME/.local/bin
	$XDG_DATA_HOME/npm/bin
	$path
)

# Enable man pages
MANPATH=$XDG_DATA_HOME/man:$MANPATH
