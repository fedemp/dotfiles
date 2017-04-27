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

# Keyboard layout
setxkbmap -layout us -variant altgr-intl nodeadkeys

# Enable restart X
setxkbmap -option terminate:ctrl_alt_bksp

# Map CapsLock to Esc
setxkbmap -option 'caps:ctrl_modifier'
xcape -e 'Caps_Lock=Escape'

# Hide mouse cursor
unclutter -b

# Redshift
redshift -l -34.6033333333:-58.3816666667 & disown

# Wallpaper stuff
getwallpaper(){
	_RESOLUTION=`xrandr | grep ' connected' | cut -d ' ' -f 3 | cut -d '+' -f 1`
	_XRES=`echo ${_RESOLUTION} | cut -d 'x' -f 1`
	_YRES=`echo ${_RESOLUTION} | cut -d 'x' -f 2`
	curl https://unsplash.it/${_XRES}/${_YRES} -o $_WALLPAPERFILENAME
	setroot $_WALLPAPERFILENAME
}

deletecache(){
	for f in $_WALLPAPERDIR/*.jpg; do
		[ $f != ${_WALLPAPERFILENAME}] && rm $f
	done
}

_WALLPAPERDATE=`date +%F`
_WALLPAPERDIR=${XDG_CACHE_HOME}/_wallpaper
_WALLPAPERFILENAME=${_WALLPAPERDIR}/wallpaper_${_WALLPAPERDATE}.jpg

# mkdir -p $_WALLPAPERDIR
# if [ -f $_WALLPAPERFILENAME ]
# then
#  	setroot $_WALLPAPERFILENAME
# else
#  	getwallpaper &
# 	deletecache &
# fi
xsetroot -bitmap Desktop/tripoint.xbm -fg "#262626" -bg "#444444"
exec bspwm
