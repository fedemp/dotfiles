# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export EDITOR=nvim
export BROWSER=firefox
export PAGER=less
export LESS="-n -R -i -g -M -x4 -X -F -z-1"
export FZF_DEFAULT_COMMAND='fdfind'
export TZ=/etc/localtime

fpath=($HOME/.functions $fpath)
