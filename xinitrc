#!/usr/bin/env dash
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

xset +fp /usr/share/fonts/local
xset fp rehash
setxkbmap -layout us -variant altgr-intl nodeadkeys
# setxkbmap latam

# enable restart X
setxkbmap -option terminate:ctrl_alt_bksp

setxkbmap -option 'caps:ctrl_modifier'
xcape -e 'Caps_Lock=Escape'

xmodmap ~/.Xmodmap

syndaemon -d -i 1
unclutter -b

# setroot --restore
# exec startxfce4
xsetroot -solid "#334046"
xrdb -merge $HOME/.Xresources
urxvtd &
urxvtc &
exec bspwm
