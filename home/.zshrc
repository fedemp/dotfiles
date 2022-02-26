# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# autoload -Uz compinit && compinit -C -d "${ZDOTDIR:-${HOME}}/${zcompdump_file:-.zcompdump}"
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' menu select=0
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/fpanico/.zshrc'

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' format '%F{yellow}-- %d --%f'

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL # Disable start/stop characters in shell editor.

# enable caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-${HOME}}/.zcompcache"

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# load and initialize the completion system
# End of lines added by compinstall
#
# Lines configured by zsh-newuser-install
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.histfile
setopt autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
autoload -Uz compinit
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi
unset _comp_files

alias cp='cp -irv'
alias df='df -h'
alias gs='git status'
alias su='su -'
alias ...='cd ../../'
alias -g G='| grep' # now you can do: ls foo G something
alias weather='curl http://wttr.in | less'
alias ls='ls --color=auto' # Just in case is not set.
alias vim=vi
command -v exa >/dev/null && alias ls='exa -l --group-directories-first'
command -v exa >/dev/null && alias l='exa -l --group-directories-first'
command -pv nnn >/dev/null && alias nnn='LESS="-n -R -i -g -M -x4 -z-1" nnn'
command -v nnn >/dev/null || alias nnn='tree -C | less'
command -v tig >/dev/null && alias gs='tig status'
command -v tuir >/dev/null && alias tuir='LESS="-n -R -i -g -M -x4 -z-1" tuir --enable-media'
command -vp vim >/dev/null && alias vim='vim'
command -v nvim >/dev/null && alias vim='nvim'

# Use smart URL pasting and escaping.
autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

# Better selection of words
autoload -U select-word-style
select-word-style bash

# Treat single word simple commands without redirection as candidates for resumption of an existing job.
setopt AUTO_RESUME

# Allow comments starting with `#` even in interactive shells.
setopt INTERACTIVE_COMMENTS

# List jobs in the long format by default.
setopt LONG_LIST_JOBS

# Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt NOTIFY

setopt SHARE_HISTORY

export NNN_USE_EDITOR=1

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search # Up
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[OB" down-line-or-beginning-search # Down
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey '^[[Z' reverse-menu-complete

setopt BEEP                     # Beep on error in line editor.

#
# Variables
#

# Treat these characters as part of a word.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Use human-friendly identifiers.
zmodload zsh/terminfo
typeset -gA key_info

setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt HIST_BEEP # Beep when accessing non-existent history.

autoload rg
  
# Archlinux
command -v cower >/dev/null && alias cower='cower --color=always'
# Ubuntu
command -v fdfind >/dev/null && alias fd='fdfind'
command -v yarnpkg >/dev/null && alias yarn=yarnpkg

source ~/.powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ ! -f /usr/share/skim/shell/key-bindings.zsh ]] || source /usr/share/skim/shell/key-bindings.zsh
