if [ -f /etc/zprofile ]; then
  . /etc/zprofile
fi

# XDG basedir spec compliance
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export EDITOR=vise
export PAGER=less
export LESS="-n -R -i -g -M -x4 -X -F -z-1"
export TZ=/etc/localtime

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--color=16'
export NNN_FCOLORS='c1e20402006006f701d6ab05'
export NNN_PLUG='p:-!less -iR "$nnn"*;g:-!git diff -- "$nnn"*'
export NNN_USE_EDITOR=1
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# Enable man pages
MANPATH=$XDG_DATA_HOME/man:$MANPATH
