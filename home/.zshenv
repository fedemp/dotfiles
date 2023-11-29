# Disable global zsh configuration
unsetopt GLOBAL_RCS

# Determine own path
local homezshenv=$HOME/.zshenv
export ZDOTDIR=$homezshenv:A:h

export EDITOR=nvim
export PAGER=less
export LESS="-n -R -i -g -M -x4 -X -F -z-1"
export FZF_DEFAULT_COMMAND='fd --type f'
export TZ=/etc/localtime
fpath=($HOME/.functions $fpath)
export NNN_FCOLORS='c1e20402006006f701d6ab05'
export NNN_PLUG='p:-!less -iR "$nnn"*;g:-!git diff -- "$nnn"*'

fpath=($ZDOTDIR/fpath $fpath)

setopt EXTENDED_GLOB

# Initialize path.
# If dirs are missing, they won't be added due to null globbing.
path=(
	$HOME/.local/bin
	$HOME/.npm-global/bin
	$path
)

# Enable man pages
MANPATH=$XDG_DATA_HOME/man:$MANPATH
