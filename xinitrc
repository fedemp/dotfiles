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

if (xrandr | grep "HDMI1 connected"); then
	xrandr --output LVDS1 --off
	xrandr --output HDMI1 --auto
fi

# setroot --restore
# exec startxfce4
xsetroot -solid "#334046"
exec bspwm
