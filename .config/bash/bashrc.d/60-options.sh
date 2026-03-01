# Error on a redirections which would overwrite an existing file
set -o noclobber

# Expand !! after pressing Space
bind Space:magic-space

# Number of directories shown in prompt
export PROMPT_DIRTRIM=3

# Allow comments in shell
shopt -s interactive_comments

# No need for cd to change directories
shopt -s autocd

# Dont spawn new instances
auto_resume=exact

export HISTCONTROL=ignoreboth:erasedups

# Display completion matches in colors based on LS_COLORS
set colored-stats on

# (Optional) Highlight the common part of the names being completed
set colored-completion-prefix on
