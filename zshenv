PATH=$PATH:$HOME/bin/:$HOME/.gem/ruby/2.3.0/bin:$HOME/npm/bin

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export EDITOR=nvim
export BROWSER=firefox
export GREP_COLOR='0;32'
export PAGER=less
export LESS="-R -i -g -M -x4 -X -F -z-1"
export FZF_DEFAULT_COMMAND='ag -g ""'
fpath=($HOME/.functions $fpath)
