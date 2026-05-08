# Save history to XDG compliant location
export HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/histfile

eval "$(mise activate zsh)"

# Emacs keybindings even if EDITOR is vi
bindkey -e

# Exported here cause they depend on mise
export EDITOR='nvim --clean'
# export FZF_DEFAULT_COMMAND='fd --type f'
# export FZF_DEFAULT_OPTS='--color=16'
export SKIM_DEFAULT_OPTIONS="--color=16"
export SKIM_DEFAULT_COMMAND='fd --type f'
export SKIM_CTRL_T_COMMAND='fd --type f'
export NNN_FCOLORS='c1e20402006006f701d6ab05'
export NNN_PLUG='p:-!less -iR "$nnn"*;g:-!git diff -- "$nnn"*'
export NNN_USE_EDITOR=1

# Load color definitions
autoload -Uz colors
colors

# Custom colors for ls
if command -v dircolors &> /dev/null; then
	eval $(dircolors ${XDG_CONFIG_HOME}/dircolors/dircolors)
else
	export LS_COLORS="di=1;34:ln=1;35:so=31:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
	export LSCOLORS=ExFxbxDxCxegedabagacad
fi

# Options
setopt ALWAYS_TO_END			# Move cursor to the end of a completed word.
setopt AUTO_CD					# If the command is directory and cannot be executed, perform cd to this directory
setopt AUTO_LIST				# Automatically list choices on ambiguous completion.
setopt AUTO_MENU				# Show completion menu on a successive tab press.
setopt AUTO_PARAM_SLASH			# If completed parameter is a directory, add a trailing slash.
setopt AUTO_PUSHD				# Make cd push the old directory onto the directory stack
setopt AUTO_RESUME				# Resumes the most recent job when the shell receives a SIGCONT signal.
setopt BANG_HIST				# Treats the ! character specially during expansion.
setopt BEEP						# Causes the shell to beep if an error occurs.
setopt COMPLETE_IN_WORD			# Complete from both ends of a word.
setopt EXTENDED_GLOB			# Needed for file modification glob modifiers with compinit
setopt HIST_BEEP				# Beeps when accessing nonexistent history
setopt HIST_EXPIRE_DUPS_FIRST	# Expires duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS		# Doesn't display a line previously found.
setopt HIST_IGNORE_ALL_DUPS		# Deletes old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_DUPS			# Doesn't record an entry that was just recorded again.
setopt HIST_IGNORE_SPACE		# Doesn't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS		# Doesn't write duplicate entries in the history file.
setopt HIST_VERIFY				# Doesn't execute immediately upon history expansion.
setopt INC_APPEND_HISTORY		# Adds history immediately after typing a command.
setopt INTERACTIVE_COMMENTS		# Allows comments to be written in interactive shells.
setopt LONG_LIST_JOBS			# Lists jobs in a long format by default.
setopt NO_CLOBBER               # Error on a redirections which would overwrite an existing file
setopt NO_FLOW_CONTROL 			# Disable flow control
setopt NO_MULTIOS 				# Disable multios
setopt NOMATCH					# If a pattern for filename generation has no matches, print an error
setopt NOTIFY					# Reports the status of background jobs immediately, not just before printing a prompt.
setopt PUSHD_IGNORE_DUPS		# Removes older duplicates in the directory stack
setopt RM_STAR_WAIT            	# Wait for 10 seconds confirmation when running rm with *
setopt RM_STAR_WAIT            	# Wait for 10 seconds confirmation when running rm with *
setopt SHARE_HISTORY			# Shares history between all sessions.
unsetopt FLOW_CONTROL			# Disable start/stop characters in shell editor.

# Completion
if [[ ":$FPATH:" != *":$ZDOTDIR/fpath:"* ]]; then export FPATH="$ZDOTDIR/fpath:$FPATH"; fi
# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' complete-options true 
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _match _correct _approximate _prefix
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu yes select
zstyle ':completion:*' insert-tab pending
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-cache on
zstyle ':completion:*' completion-automatically true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
zstyle ':completion:*:*:cd:*' local-directories path-directories directory-stack tag-order
zstyle :compinstall filename '$ZDOTDIR/comp'

# Optional: nicer completion menu navigation
bindkey '^I' expand-or-complete-prefix

autoload -Uz compinit
compinit
# End of lines added by compinstall


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

command -v eza >/dev/null && alias ls='eza --group-directories-first --icons=auto'
command -v eza >/dev/null && alias l='eza -l --group-directories-first'
command -pv nnn >/dev/null && alias nnn='LESS="-n -R -i -g -M -x4 -z-1" nnn'
command -v nnn >/dev/null || alias nnn='tree -C | less'
command -v tig >/dev/null && alias gs='tig status'
command -v vim >/dev/null && alias vim='vim' # Destroy previous alias to vi.
command -v nvim >/dev/null && alias vim='nvim'
command -v cower >/dev/null && alias cower='cower --color=always' # archlinux
command -v fdfind >/dev/null && alias fd='fdfind' # ubuntu

# Check if the OS is Linux
if [[ "$(uname)" == "Linux" ]]; then
    # Check if running inside a container
    # 1. Look for .dockerenv file
    # 2. Check if 'container' env var is set (common in Podman/systemd-nspawn)
    # 3. Check for 'docker' or 'containerd' in /proc/1/cgroup
    if [[ -f /.dockerenv ]] || [[ -n "$container" ]] || grep -qiE 'docker|containerd|lxc' /proc/1/cgroup 2>/dev/null; then
        # Define your container-only aliases here
        alias podman='flatpak-spawn --host podman'
        alias ll='ls -lah --color=auto'
        
    fi
fi

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

PROMPT='%F{green}%(?..%F{red})❯%f '
RPROMPT='%B%F{blue}%(5~|%-1~/…/%3~|%4~)%b%(1j. %F{red}⏻.)%F{yellow}%(?..%B (%?%)%b)'

# Specific for jj
source <(COMPLETE=zsh jj)
# skim keybindings
source <(sk --shell-bindings --shell zsh)
