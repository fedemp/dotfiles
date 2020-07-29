fpath=($HOME/.functions $fpath)
typeset -U path
path=($HOME/.npm-packages/bin $HOME/.local/bin/ $path[@])
eval `dircolors ~/.dir_colors`
export GPG_TTY=$(tty)
