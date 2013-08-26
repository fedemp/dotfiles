# The following lines were added by compinstall

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)
zstyle ':completion:*' users off
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.dotfiles/cache/

autoload -Uz compinit
compinit

source ~/.npmcompletion

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install

# Customize to your needs...
source ~/.dotfiles/pure/pure.zsh

export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/bin/

# export PAGER=~/bin/vimpager
export EDITOR=vim

alias ls="ls -h --color=auto"
alias df='df -h'
alias k9='kill -9'
alias ack='ack-grep'
eval `dircolors ~/.dircolors`

alias gs='git status'
alias gi='vim .gitignore'

# Less Colors for Man Pages
# http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
# export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
# export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
# export LESS_TERMCAP_me=$'\E[0m'           # end mode
# export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
# export LESS_TERMCAP_so=$'\E[38;33;246m'   # begin standout-mode - info box
# export LESS_TERMCAP_ue=$'\E[0m'           # end underline
# export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

export GREP_COLOR='0;32'

export PAGER="less"
export LESS="-R"
# nicer highlighting
if [ -f "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]; then
    # ubuntu 12.10: sudo apt-get install source-highlight
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
elif [ -f "/usr/bin/src-hilite-lesspipe.sh" ]; then
    # fedora 18: sudo yum install source-highlight
    export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
fi

# https://github.com/skwp/dotfiles/blob/master/zsh/key-bindings.zsh
bindkey '^[[A' up-line-or-search                    # start typing + [Up-Arrow] - fuzzy find history forward
bindkey '^[[B' down-line-or-search                  # start typing + [Down-Arrow] - fuzzy find history backward
bindkey '^[[H' beginning-of-line                    # [Home] - Go to beginning of line
bindkey '^[[1~' beginning-of-line                   # [Home] - Go to beginning of line
bindkey '^[[4~' end-of-line                         # [End] - Go to end of line
bindkey '^[OF' end-of-line                          # [End] - Go to end of line
bindkey '^[Oc' forward-word                      # [Ctrl-RightArrow] - move forward one word
bindkey '^[Od' backward-word                     # [Ctrl-LeftArrow] - move backward one word

autoload zmv
alias zmv="noglob zmv -W"

# https://github.com/skwp/dotfiles/blob/master/zsh/zsh-aliases.zsh
alias -g G='| ack-grep' # now you can do: ls foo G something
function fn() { ls **/*$1* }

bindkey "^R" history-incremental-search-backward
bindkey "^[[1;5A" history-incremental-search-backward
bindkey "^[[1;5B" history-incremental-search-forward
bindkey "^[[a" history-incremental-search-backward
bindkey "^[[b" history-incremental-search-forward

bindkey '^[[Z' reverse-menu-complete

if [ $commands[fasd] ]; then # check if fasd is installed
  fasd_cache="$HOME/.fasd-init-cache"
  if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
    fasd --init auto >| "$fasd_cache"
  fi
  source "$fasd_cache"
  unset fasd_cache
  alias v='f -e vim'
  alias o='a -e open'
fi

stty erase \^\? # Fixes backspace for vim
export TERM=screen-256color
