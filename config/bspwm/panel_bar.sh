#! /bin/sh
#
# Example panel for lemonbar

. $XDG_CONFIG_HOME/bspwm/panel_colors.sh

num_mon=$(bspc query -M | wc -l)

while read -r line ; do
  case $line in
    S*) # clock output
      sys="%{F$COLOR_SYS_FG}%{B$COLOR_SYS_BG} ${line#?} %{B-}%{F-}"
      ;;
    T*) # xtitle output
      title="%{F$COLOR_TITLE_FG}%{B$COLOR_TITLE_BG}%{A:windowmenu -m:} ${line#?} %{A}%{B-}%{F-}"
      ;;
    W*) # bspwm's state
      wm=""
      IFS=':'
      set -- ${line#?}
      while [ $# -gt 0 ] ; do
        item=$1
        name=${item#?}
        case $item in
          [mM]*)
            [ $num_mon -lt 2 ] && shift && continue
            title="%{F$COLOR_TITLE_FG}%{B$COLOR_TITLE_BG} $(xtitle) %{B-}%{F-}"
            case $item in
              m*) # monitor
                FG=$COLOR_MONITOR_FG
                BG=$COLOR_MONITOR_BG
                ;;
              M*) # focused monitor
                FG=$COLOR_FOCUSED_MONITOR_FG
                BG=$COLOR_FOCUSED_MONITOR_BG
                ;;
            esac
            wm="${wm}%{F${FG}}%{B${BG}}%{A:bspc monitor -f ${name}:} ${name} %{A}%{B-}%{F-}"
            ;;
          [fFoOuU]*)
            title="%{F$COLOR_TITLE_FG}%{B$COLOR_TITLE_BG} $(xtitle) %{B-}%{F-}"
            case $item in
              f*) # free desktop
                FG=$COLOR_FREE_FG
                BG=$COLOR_FREE_BG
                ;;
              F*) # focused free desktop
                FG=$COLOR_FOCUSED_FREE_FG
                BG=$COLOR_FOCUSED_FREE_BG
                ;;
              o*) # occupied desktop
                FG=$COLOR_OCCUPIED_FG
                BG=$COLOR_OCCUPIED_BG
                ;;
              O*) # focused occupied desktop
                FG=$COLOR_FOCUSED_OCCUPIED_FG
                BG=$COLOR_FOCUSED_OCCUPIED_BG
                ;;
              u*) # urgent desktop
                FG=$COLOR_URGENT_FG
                BG=$COLOR_URGENT_BG
                ;;
              U*) # focused urgent desktop
                FG=$COLOR_FOCUSED_URGENT_FG
                BG=$COLOR_FOCUSED_URGENT_BG
                ;;
            esac
            wm="${wm}%{F${FG}}%{B${BG}}%{A:bspc desktop -f ${name}:} ${name} %{A}%{B-}%{F-}"
            ;;
          L*) # layout
            wm="${wm}%{F$COLOR_STATE_FG}%{B$COLOR_STATE_BG}%{A:bspc desktop -l next:} ${name} %{A}%{B-}%{F-}"
            ;;
          T*) # state
            wm="${wm}%{F$COLOR_STATE_FG}%{B$COLOR_STATE_BG}%{A:bspc node -t ~floating:} ${name} %{A}%{B-}%{F-}"
            ;;
          G*) # flags
            wm="${wm}%{F$COLOR_STATE_FG}%{B$COLOR_STATE_BG} ${name:--} %{B-}%{F-}"
            ;;
        esac
        shift
      done
      ;;
  esac
  printf "%s\n" "%{l}${wm}%{c}${title}%{r}${sys}"
done
