#!/bin/bash
# disable path name expansion or * will be expanded in the line
# cmd=( $line )
set -f

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
	echo "Invalid monitor $monitor"
	exit 1
fi
# geometry has the format: WxH+X+Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=16
font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
bgcolor=$(herbstclient get frame_border_normal_color)
selbg=$(herbstclient get window_border_active_color)
selfg='#101010'

####
# Try to find textwidth binary.
if [ -e "$(which textwidth 2> /dev/null)" ] ; then
	textwidth="textwidth";
elif [ -e "$(which dzen2-textwidth 2> /dev/null)" ] ; then
	textwidth="dzen2-textwidth";
else
	echo "This script requires the textwidth tool of the dzen2 project."
	exit 1
fi
####
# true if we are using the svn version of dzen2
dzen2_version=$(dzen2 -v 2>&1 | head -n 1 | cut -d , -f 1|cut -d - -f 2)
if [ -z "$dzen2_version" ] ; then
	dzen2_svn="true"
else
	dzen2_svn=""
fi

memo() {
	local percent=$(free -m | awk '/cache:/ { printf("%d",$3/($3+$4)*100)}')
	if (($percent<30)); then
		mem_col="^fg(darkgreen)"
	elif (($percent<70)); then
		mem_col="^fg(#efefef)"
	else
		mem_col="^fg(darkred)"
	fi
	local bin=$(echo "obase=2; $percent"| bc| while read line; do for ((i=${#line};i<7;i++)); do echo -n 0; done; echo -n $mem_col$line;done)

	echo -n "^fg(#909090)$bin"
}
bat() {
	local status=$(acpi | awk '{print $3}' | sed 's/,//')

	case $status in
		Discharging) pow_col="^fg(#efefef)"; pwr_sign="-" ;;
		Charging) pow_col="^fg(darkred)"; pwr_sign="+";;
		Full) pow_col="^fg(#909090)"; pwr_sign=":";;
	esac

	local percent=$(acpi | awk '{print $4}' | sed 's/[,%]//g')
	local bin=$(echo "obase=2; $percent"| bc|  while read line; do for ((i=${#line};i<7;i++)); do echo -n '0'; done; echo $pow_col$line;done)
	echo -n "^fg(#909090)$pwr_sign$bin"
}

function uniq_linebuffered() {
awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

herbstclient pad $monitor $panel_height
{
	# events:
	while true ; do
		batshow="$(bat)"
		echo "bat $batshow"
		date +'date ^fg()%a ^fg(#909090)v%V ^fg()%H:%M^fg(#909090), %Y-%m-^fg()%d'
		mem="$(memo)"
		echo "memo $mem"
		sleep 60 || break
	done > >(uniq_linebuffered)  &
	childpid=$!
	$HOME/.scripts/binaryhlwmcpu.sh &
	$HOME/.scripts/binaryhlwmweather.sh &
	herbstclient --idle
	kill $childpid
} 2> /dev/null | {
TAGS=( $(herbstclient tag_status $monitor) )
visible=true
date=""
batshow=""
cpu=""
weather=""
mem=""
windowtitle=""
while true ; do
	bordercolor="#26221C"
	separator="^bg()^fg($selbg)|"
	# draw tags
	for i in "${TAGS[@]}" ; do
		case ${i:0:1} in
			'#')
				echo -n "^bg($selbg)^fg($selfg)"
				;;
			'+')
				echo -n "^bg(#9CA668)^fg(#141414)"
				;;
			':')
				echo -n "^bg()^fg(#ffffff)"
				;;
			'!')
				echo -n "^bg(#FF0675)^fg(#141414)"
				;;
			*)
				echo -n "^bg()^fg(#ababab)"
				;;
		esac
		if [ ! -z "$dzen2_svn" ] ; then
			echo -n "^ca(1,herbstclient focus_monitor $monitor && "'herbstclient use "'${i:1}'") '"${i:1} ^ca()"
		else
			echo -n " ${i:1} "
		fi
	done
	# echo -n "$separator $weather $separator"
	echo -n "$separator"
	echo -n "^bg()^fg() ${windowtitle//^/^^}"
	# right="$separator^bg() $cpu $separator $mem ^fg()$separator $batshow $separator $date $separator"
	right="$separator^bg() $date $separator"
	right_text_only=$(echo -n "$right"|sed 's.\^[^(]*([^)]*)..g')
	# get width of right aligned text.. and add some space..
	width=$($textwidth "$font" "$right_text_only    ")
	echo -n "^pa($(($panel_width - $width)))$right"
	echo
	# wait for next event
	read line || break
	cmd=( $line )
	# find out event origin
	case "${cmd[0]}" in
		tag*)
			TAGS=( $(herbstclient tag_status $monitor) )
			;;
		date)
			date="${cmd[@]:1}"
			;;
		bat*)
			batshow="${cmd[@]:1}"
			;;
		cpu*)
			cpu="${cmd[@]:1}"
			;;
		mem*)
			mem="${cmd[@]:1}"
			;;
		weath*)
			weather="${cmd[@]:1}"
			;;
		quit_panel)
			exit
			;;
		togglehidepanel)
			currentmonidx=$(herbstclient list_monitors |grep ' \[FOCUS\]$'|cut -d: -f1)
			if [ -n "${cmd[1]}" ] && [ "${cmd[1]}" -ne "$monitor" ] ; then
				continue
			fi
			if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
				continue
			fi
			echo "^togglehide()"
			if $visible ; then
				visible=false
				herbstclient pad $monitor 0
			else
				visible=true
				herbstclient pad $monitor $panel_height
			fi
			;;
		reload)
			exit
			;;
		focus_changed|window_title_changed)
			windowtitle="${cmd[@]:2}"
			;;
	esac
done
} 2> /dev/null | \
	dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $panel_height -ta l \
	-bg "$bgcolor" -fg '#efefef'
