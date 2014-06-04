#!/bin/dash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"
xset +fp /usr/share/fonts/local
xset fp rehash
setxkbmap -layout us -variant altgr-intl nodeadkeys
xmodmap $HOME/.Xmodmap
hidcur &
numlockx
xsetroot -solid "#435056"
exec bspwm
# exec jwm
