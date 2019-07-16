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

if (xrandr | grep "HDMI1 connected"); then
	xrandr --output LVDS1 --off
	xrandr --output HDMI1 --auto
fi

# Keyboard layout
setxkbmap -layout us -variant altgr-intl nodeadkeys

# Enable restart X
setxkbmap -option terminate:ctrl_alt_bksp

# Map CapsLock to Esc
setxkbmap -option 'caps:ctrl_modifier'
xcape -e 'Caps_Lock=Escape'

# Hide mouse cursor
xbanish &

redshift &

setroot --blank-color "#73918e"

exec bspwm
