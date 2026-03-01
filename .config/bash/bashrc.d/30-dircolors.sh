# Custom colors for ls
if command -v dircolors &> /dev/null; then
	eval $(dircolors ${XDG_CONFIG_HOME}/dircolors/dircolors)
else
	export LS_COLORS="di=1;34:ln=1;35:so=31:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
	export LSCOLORS=ExFxbxDxCxegedabagacad
fi
