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

xset +fp /usr/share/fonts/local
xset fp rehash
setxkbmap -layout us -variant altgr-intl nodeadkeys
numlockx

# enable restart X
setxkbmap -option terminate:ctrl_alt_bksp

# disable CapsLock & map to Escape
xmodmap .Xmodmap

if (xrandr | grep "VGA1 connected"); then
	xrandr --output VGA1 --auto
	xrandr --output LVDS1 --off
fi

xsetroot -solid '#222e45'

exec bspwm
