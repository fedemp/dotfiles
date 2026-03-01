alias mkdir='mkdir -pv'
alias cp='cp -irv'
alias mv='mv -iv'
alias su='su -'
alias ls='ls --color=auto' # Just in case is not set.
alias ln="ln -i"
alias mv="mv -i"
alias rm="rm -I"
alias df="df -h"
alias clear=' clear'
alias pwd=' pwd'
alias exit=' exit'
alias fg=' fg'

command -v eza >/dev/null && alias ls='eza --group-directories-first'
command -v nvim >/dev/null && alias vim='nvim'
command -pv nnn >/dev/null && alias nnn='LESS="-n -R -i -g -M -x4 -z-1" nnn'


