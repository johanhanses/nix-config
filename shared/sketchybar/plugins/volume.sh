#!/bin/sh
[ "$SENDER" = volume_change ] || exit 0
vol=$INFO
case $vol in
  0) icon= ;;
  [0-9] | [1-3][0-9]) icon= ;;
  *) icon= ;;
esac
sketchybar --set "$NAME" icon="$icon" label="$vol%"
