#!/bin/sh
# Weather from Open-Meteo (free, no API key). Fixed point at Falun —
# Borlänge is ~20 km away, same weather; a fixed location avoids a
# Location Services prompt. Codes: https://open-meteo.com/en/docs (WMO).
. "$HOME/.config/sketchybar/colors.sh"
LAT=60.607
LON=15.626
cur=$(curl -sf -m 8 "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,weather_code,is_day" |
  jq -r '.current | "\(.temperature_2m | round) \(.weather_code) \(.is_day)"') || exit 0 # offline: keep last
set -- $cur
temp=$1 code=$2 day=$3

case $code in
  0 | 1) if [ "$day" = 1 ]; then icon=󰖙; else icon=󰖔; fi ;;
  2) if [ "$day" = 1 ]; then icon=󰖕; else icon=󰼱; fi ;;
  3) icon=󰖐 ;;
  45 | 48) icon=󰖑 ;;
  65 | 67 | 82) icon=󰖖 ;;
  5[1-7] | 6[1-7] | 8[0-2]) icon=󰖗 ;;
  7[1-7] | 85 | 86) icon=󰖘 ;;
  9[5-9]) icon=󰙾 ;;
  *) icon=󰖐 ;;
esac

sketchybar --set "$NAME" icon="$icon" icon.color=$ACCENT label="${temp}°"
