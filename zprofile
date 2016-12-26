export PATH=$PATH:$HOME/bin/:$HOME/.gem/ruby/2.2.0/bin:$HOME/npm/bin
export EDITOR=nvim
export BROWSER=firefox
export GREP_COLOR='0;32'
export PAGER="less"
export LESS="-R -i -g -M -x4 -X -F -z-1"
export FZF_DEFAULT_COMMAND='ag -g ""'
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
