# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

mkdir -p $XDG_STATE_HOME/zsh/

# Lines configured by zsh-newuser-install
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=1000
SAVEHIST=1000
setopt beep nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '$XDG_STATE_HOME/zsh/history'

export ZSH_COMPDUMP=$XDG_CACHE_HOME/zsh/zcompdump-$HOST 
autoload -Uz compinit
compinit -d ${XDG_CACHE_HOME}/zsh/zcompdump-{$HOST}
# End of lines added by compinstall

# Load color definitions
autoload -Uz colors
colors

# Custom colors for ls
eval $(dircolors ${XDG_CONFIG_HOME}/dircolors/dircolors)

# Options
setopt ALWAYS_TO_END				# Move cursor to the end of a completed word.
setopt AUTO_CD					# If the command is directory and cannot be executed, perform cd to this directory
setopt AUTO_LIST				# Automatically list choices on ambiguous completion.
setopt AUTO_MENU				# Show completion menu on a successive tab press.
setopt AUTO_PARAM_SLASH				# If completed parameter is a directory, add a trailing slash.
setopt AUTO_PUSHD				# Make cd push the old directory onto the directory stack
setopt AUTO_RESUME				# Resumes the most recent job when the shell receives a SIGCONT signal.
setopt BANG_HIST				# Treats the ! character specially during expansion.
setopt BEEP					# Causes the shell to beep if an error occurs.
setopt COMPLETE_IN_WORD				# Complete from both ends of a word.
setopt EXTENDED_GLOB				# Needed for file modification glob modifiers with compinit
setopt HIST_BEEP				# Beeps when accessing nonexistent history
setopt HIST_EXPIRE_DUPS_FIRST			# Expires duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS			# Doesn't display a line previously found.
setopt HIST_IGNORE_ALL_DUPS			# Deletes old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_DUPS				# Doesn't record an entry that was just recorded again.
setopt HIST_IGNORE_SPACE			# Doesn't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS			# Doesn't write duplicate entries in the history file.
setopt HIST_VERIFY				# Doesn't execute immediately upon history expansion.
setopt INC_APPEND_HISTORY			# Adds history immediately after typing a command.
setopt INTERACTIVE_COMMENTS			# Allows comments to be written in interactive shells.
setopt LONG_LIST_JOBS				# Lists jobs in a long format by default.
setopt NOTIFY					# Reports the status of background jobs immediately, not just before printing a prompt.
setopt PUSHD_IGNORE_DUPS			# Removes older duplicates in the directory stack
setopt RM_STAR_WAIT              		# Wait for 10 seconds confirmation when running rm with *
setopt RM_STAR_WAIT              		# Wait for 10 seconds confirmation when running rm with *
setopt SHARE_HISTORY				# Shares history between all sessions.
unsetopt FLOW_CONTROL				# Disable start/stop characters in shell editor.
unsetopt RM_STAR_SILENT          		# Notify when rm is running with *
unsetopt RM_STAR_SILENT          		# Notify when rm is running with *

# Completion
source ${ZDOTDIR}/compinit

# Aliases
alias find='noglob find'
alias touch='nocorrect touch'
alias mkdir='nocorrect mkdir -pv'
alias fd='noglob fd'
alias sk='sk --color=16'
alias cp='nocorrect cp -irv'
alias mv='mv -iv'
alias gs='git status'
alias su='su -'
alias ...='cd ../../'
alias -g G='| grep' # now you can do: ls foo G something
alias weather='curl http://wttr.in | less'
alias ls='ls --color=auto' # Just in case is not set.
alias vim=vi
alias chown="chown --preserve-root"
alias ln="ln -i"
alias mv="mv -i"
alias rm="rm -I"
alias df="df -h"
alias clear=' clear'
alias pwd=' pwd'
alias exit=' exit'
alias fg=' fg'

command -v eza >/dev/null && alias ls='eza --group-directories-first'
command -v eza >/dev/null && alias l='eza -l --group-directories-first'
command -pv nnn >/dev/null && alias nnn='LESS="-n -R -i -g -M -x4 -z-1" nnn'
command -v nnn >/dev/null || alias nnn='tree -C | less'
command -v tig >/dev/null && alias gs='tig status'
command -v vim >/dev/null && alias vim='vim' # Destroy previous alias to vi.
command -v nvim >/dev/null && alias vim='nvim'
command -v cower >/dev/null && alias cower='cower --color=always' # archlinux
command -v fdfind >/dev/null && alias fd='fdfind' # ubuntu

# Use smart URL pasting and escaping.
autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

# Better selection of words
autoload -U select-word-style
select-word-style bash

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Treat these characters as part of a word.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# source <(fzf --zsh)
source <(jj util completion zsh)
for file in ${ZDOTDIR:--}/.zsh.d/*.zsh; do
    [ -e "$file" ] && source "$file"
done 

source ${XDG_DATA_HOME}/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.etc/home/.config/zsh/.p10k.zsh.
[[ ! -f ${ZDOTDIR:--}/.p10k.zsh ]] || source ${ZDOTDIR:--}/.p10k.zsh

if [[ ":$FPATH:" != *":/var/home/federico/.local/share/dotfiles/.config/zsh/completions:"* ]]; then export FPATH="/var/home/federico/.local/share/dotfiles/.config/zsh/completions:$FPATH"; fi

autoload -Uz compinit
compinit
