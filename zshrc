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

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch notify
setopt autopushd pushdsilent
bindkey -v
# End of lines configured by zsh-newuser-install

# Customize to your needs...


alias df='df -h'
alias ag='ag --color'
alias ls='ls --color=auto'

# nicer highlighting
if [ -f "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]; then
    # ubuntu 12.10: sudo apt-get install source-highlight
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
elif [ -f "/usr/bin/src-hilite-lesspipe.sh" ]; then
    # fedora 18: sudo yum install source-highlight
    export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
fi

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# https://github.com/skwp/dotfiles/blob/master/zsh/key-bindings.zsh
bindkey '^[[A' up-line-or-beginning-search                    # start typing + [Up-Arrow] - fuzzy find history forward
bindkey '^[[B' down-line-or-beginning-search                  # start typing + [Down-Arrow] - fuzzy find history backward
bindkey '^[[7~' beginning-of-line                    # [Home] - Go to beginning of line
bindkey '^[[8~' end-of-line                         # [End] - Go to end of line
bindkey '^[Oc' forward-word                      # [Ctrl-RightArrow] - move forward one word
bindkey '^[Od' backward-word                     # [Ctrl-LeftArrow] - move backward one word

autoload zmv

# https://github.com/skwp/dotfiles/blob/master/zsh/zsh-aliases.zsh
alias -g G='| ag' # now you can do: ls foo G something

bindkey "^R" history-incremental-search-backward

bindkey '^[[Z' reverse-menu-complete

if [ $commands[fasd] ]; then # check if fasd is installed
  fasd_cache="$HOME/.fasd-init-cache"
  if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
    fasd --init auto >| "$fasd_cache"
  fi
  source "$fasd_cache"
  unset fasd_cache
fi

stty erase \^\? # Fixes backspace for vim

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

unsetopt MULTIBYTE

autoload -U promptinit && promptinit
prompt pure

autoload k9 l gs fn
