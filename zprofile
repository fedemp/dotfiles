export PANEL_FIFO=/tmp/panel-fifo
export PATH=$PATH:$HOME/bin/
export EDITOR=vim
export GREP_COLOR='0;32'
export PAGER="less"
export LESS="-R -i -g -M -R -x4 -X -f -F -z-1"
export PANEL_HEIGHT=18
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
