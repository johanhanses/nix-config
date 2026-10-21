#!/bin/sh
# Open PRs requesting my review (gh's own keychain auth). Hidden at zero.
. "$HOME/.config/sketchybar/colors.sh"
n=$(gh api -X GET search/issues -f q='is:pr is:open review-requested:@me archived:false' --jq .total_count 2>/dev/null) ||
  exit 0 # offline / rate-limited: keep last
if [ "${n:-0}" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on label="$n" icon.color=$ACCENT
else
  sketchybar --set "$NAME" drawing=off
fi
