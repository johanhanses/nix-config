#!/bin/sh
# Dock-badge notifier: badge.sh <bundle-id>. Shows the app's dock badge (unread
# count, or Mattermost's "•" for unreads without mentions); hidden when the app
# isn't running or has no badge. `lsappinfo -only StatusLabel` returns NULL on
# this macOS, so grep the long form instead.
. "$HOME/.config/sketchybar/colors.sh"
label=$(lsappinfo info -app "$1" -long 2>/dev/null |
  sed -n 's/.*"StatusLabel"={ "label"="\([^"]*\)" }.*/\1/p')

if [ -z "$label" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on label="$label" icon.color=$ACCENT
fi
