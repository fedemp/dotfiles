# The following lines were added by compinstall

# zstyle ':completion:*' auto-description 'specify %d'
# zstyle ':completion:*' completer _expand _complete _approximate
# zstyle ':completion:*' completions 1
# zstyle ':completion:*' file-sort name
# zstyle ':completion:*' format 'completing %d'
# zstyle ':completion:*' glob 1
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' ignore-parents parent pwd ..
# zstyle ':completion:*' insert-unambiguous true
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
# zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z} r:|[._-]=* r:|=*' '' 'l:|=* r:|=*'
# zstyle ':completion:*' max-errors 2 not-numeric
# zstyle ':completion:*' menu select=1
# zstyle ':completion:*' original true
# zstyle ':completion:*' prompt 'correcting with %e errors'
# zstyle ':completion:*' substitute 1
# zstyle ':completion:*' verbose true
# zstyle :compinstall filename '/home/fede/.zshrc'

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
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install

# Customize to your needs...

source ~/.dotfiles/pure/prompt.zsh

export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/bin/

export PAGER=~/bin/vimpager
export EDITOR=vim
alias less=$PAGER
alias most=$PAGER

alias ls="ls -h --color=auto"
alias df='df -h'
alias k9='kill -9'
# alias grep='grep --color'
eval `dircolors ~/.dircolors`

alias gs='git status'
alias gi='vim .gitignore'

# Less Colors for Man Pages
# http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;33;246m'   # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

export GREP_COLOR='0;32'

# https://github.com/skwp/dotfiles/blob/master/zsh/key-bindings.zsh
bindkey '^[[A' up-line-or-search                    # start typing + [Up-Arrow] - fuzzy find history forward
bindkey '^[[B' down-line-or-search                  # start typing + [Down-Arrow] - fuzzy find history backward
bindkey '^[[H' beginning-of-line                    # [Home] - Go to beginning of line
bindkey '^[[1~' beginning-of-line                   # [Home] - Go to beginning of line
bindkey '^[OH' beginning-of-line                    # [Home] - Go to beginning of line
bindkey '^[[F'  end-of-line                         # [End] - Go to end of line
bindkey '^[[4~' end-of-line                         # [End] - Go to end of line
bindkey '^[OF' end-of-line                          # [End] - Go to end of line
bindkey '^[[1;5C' forward-word                      # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                     # [Ctrl-LeftArrow] - move backward one word
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

autoload zmv
alias zmv="noglob zmv -W"

# https://github.com/skwp/dotfiles/blob/master/zsh/zsh-aliases.zsh
alias -g G='| ack-grep' # now you can do: ls foo G something
function fn() { ls **/*$1* }

bindkey "^R" history-incremental-search-backward

bindkey '^[[Z' reverse-menu-complete
