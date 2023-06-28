export EDITOR=nvim
export BROWSER=firefox
export PAGER=less
export LESS="-n -R -i -g -M -x4 -X -F -z-1"
export FZF_DEFAULT_COMMAND='fd'
export TZ=/etc/localtime
fpath=($HOME/.functions $fpath)
export NNN_FCOLORS='c1e20402006006f701d6ab05'
export NNN_PLUG='p:-!less -iR "$nnn"*;g:-!git diff -- "$nnn"*'

if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]
then
    PATH="$HOME/.local/bin:$PATH"
fi
if ! [[ "$PATH" =~ "$HOME/.npm-global/bin:" ]]
then
    PATH="$HOME/.npm-global/bin:$PATH"
fi
export PATH
