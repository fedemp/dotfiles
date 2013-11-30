#!/bin/sh
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

# Multi-user support:
state_prefix=${XDG_CACHE_HOME:-"$HOME/.cache"}
mkdir -p "${state_prefix}"

if [ ! -d "${state_prefix}" ]; then
    echo "bspwm-session: cache directory ‘${state_prefix}‘ is missing."
    echo
    exit 1
elif [ ! -w "${state_prefix}" ]; then
    echo "bspwm-session: cache directory ‘${state_prefix}‘ is not writable."
    echo
    exit 1
fi

state_path=$(mktemp -d "${state_prefix}/bspwm-session.XXXXXX")

if [ $? -ne 0 ]; then
    echo "bspwm-session: failed to create state directory ‘${state_path}‘."
    echo
    exit 1
fi

export BSPWM_SOCKET=${state_path}/bspwm-socket

# Trap: make sure everything started in ~/.config/bspwm/autostart is
# signalled when this script exits or dies. Also clean up $state_path.
on_exit () {
for child in $(jobs -p); do
    jobs -p | grep -q $child && kill $child
done
# Extra paranoia
[[ -d "${state_path}" && -w "${state_path}" ]] && rm -rf -- "${state_path}"
}

trap on_exit EXIT SIGHUP SIGINT SIGTERM

# Environment and autostart:
bspwm_autostart="${XDG_CONFIG_HOME:-"$HOME/.config"}/bspwm/autostart"

[ -r "/etc/profile" ] && . "/etc/profile"
[ -r "${HOME}/.profile" ] && . "${HOME}/.profile"
[ -r "${bspwm_autostart}" ] && . "${bspwm_autostart}"

sxhkdrc_path=${XDG_CONFIG_HOME:-"$HOME/.config"}/bspwm/sxhkdrc
[ -r "${sxhkdrc_path}" ] && sxhkd -c "${sxhkdrc_path}" &

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"
bspwm
