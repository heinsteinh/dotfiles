#! /bin/sh



if xdo id -a "$PANEL_WM_NAME" > /dev/null ; then
	printf "%s\n" "The panel is already running." >&2
	exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

bspc config top_padding $PANEL_HEIGHT
bspc subscribe report > "$PANEL_FIFO" &
xtitle -sf 'T%s\n' > "$PANEL_FIFO" &
clock -sf 'S%a %H:%M' > "$PANEL_FIFO" &

. $XDG_CONFIG_HOME/bspwm/panel_colors.sh

#$XDG_CONFIG_HOME/bspwm/panel_bar.sh < "$PANEL_FIFO" | lemonbar -a 32 -n "$PANEL_WM_NAME" -g x$PANEL_HEIGHT -f "$PANEL_FONT" -F "$COLOR_DEFAULT_FG" -B "$COLOR_DEFAULT_BG" -r 2 -R "$COLOR_DEFAULT_FG" -g -2-2 | sh &
$XDG_CONFIG_HOME/bspwm/panel_bar.sh < "$PANEL_FIFO" | lemonbar -a 32 -n "$PANEL_WM_NAME" -g "x$PANEL_HEIGHT" -f "$PANEL_FONT" -F "$COLOR_DEFAULT_FG" -B "$COLOR_DEFAULT_BG" | sh &

wid=$(xdo id -a "$PANEL_WM_NAME")
tries_left=20
while [ -z "$wid" -a "$tries_left" -gt 0 ] ; do
	sleep 0.05
	wid=$(xdo id -a "$PANEL_WM_NAME")
	tries_left=$((tries_left - 1))
done
[ -n "$wid" ] && xdo above -t "$(xdo id -N Bspwm -n root | sort | head -n 1)" "$wid"

wait
