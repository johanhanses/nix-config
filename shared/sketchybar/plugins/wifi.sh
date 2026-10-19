#!/bin/sh
# Icon only: recent macOS redacts the SSID without Location permission.
. "$HOME/.config/sketchybar/colors.sh"
if ipconfig getifaddr en0 >/dev/null 2>&1; then
  sketchybar --set "$NAME" icon= icon.color=$FG
else
  sketchybar --set "$NAME" icon=󰖪 icon.color=$FG_DIM
fi
