fpath=($HOME/.functions $fpath)
typeset -U path
path=($HOME/.local/bin/ $path[@])
eval `dircolors ~/.dir_colors`
export GPG_TTY=$(tty)

export PATH="$HOME/.cargo/bin:$PATH"
