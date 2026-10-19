#!/bin/sh
. "$HOME/.config/sketchybar/colors.sh"
batt=$(pmset -g batt)
pct=$(printf '%s' "$batt" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
[ -z "$pct" ] && { sketchybar --set "$NAME" drawing=off; exit 0; } # no battery

color=$FG
case $pct in
  100 | 9[0-9]) icon= ;;
  [6-8][0-9]) icon= ;;
  [3-5][0-9]) icon= ;;
  [1-2][0-9]) icon=; color=$YELLOW ;;
  *) icon=; color=$RED ;;
esac
printf '%s' "$batt" | grep -q 'AC Power' && { icon=; color=$GREEN; }

sketchybar --set "$NAME" icon="$icon" icon.color=$color label="$pct%"
