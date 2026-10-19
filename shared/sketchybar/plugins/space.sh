#!/bin/sh
. "$HOME/.config/sketchybar/colors.sh"
if [ "$SELECTED" = true ]; then
  sketchybar --set "$NAME" background.drawing=on icon.color=$ON_ACCENT
else
  sketchybar --set "$NAME" background.drawing=off icon.color=$FG_DIM
fi
