# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.config/bash/bashrc.d ]; then
    for rc in ~/.config/bash/bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

PS1='$(if [ -e /run/.containerenv -o -e /.dockerenv ]; then echo \[\e[33\;1m\]⬣ \[\e[0m\]; fi)$(VALU=$? ; if [ $VALU != 0 ]; then echo \[\e[31\;1m\]→$VALU \[\e[0m\]; fi)$([ \j -gt 0 ] && echo \[\e[35\;1m\]↓\j \[\e[0m\])\[\e[34m\]\w\[\e[0m\] \$ '
