export PATH=$PATH:$HOME/bin/:$HOME/.gem/ruby/2.2.0/bin:$HOME/npm/bin
export EDITOR=vim
export GREP_COLOR='0;32'
export PAGER="less"
export LESS="-R -i -g -M -R -x4 -X -f -F -z-1"
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec ssh-agent startx
