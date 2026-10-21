#!/bin/sh
# Next (or current) timed calendar event within 24h, via EventKit.
# Calendar access is granted to SketchyBar itself (TCC attributes the
# osascript child to it); macOS may ask again after a sketchybar update.
. "$HOME/.config/sketchybar/colors.sh"
out=$(osascript -l JavaScript "$(dirname "$0")/../helpers/next_event.js" 2>/dev/null)

case $out in
  "" | none | noaccess)
    sketchybar --set "$NAME" drawing=off
    exit 0 ;;
esac

start=$(printf '%s' "$out" | cut -f1)
end=$(printf '%s' "$out" | cut -f2)
title=$(printf '%s' "$out" | cut -f3-)
[ ${#title} -gt 24 ] && title="$(printf '%s' "$title" | cut -c1-23)…"
now=$(date +%s)
mins=$(((start - now + 59) / 60))

if [ "$start" -le "$now" ]; then
  when="now · until $(date -r "$end" +%H:%M)"; color=$RED
elif [ "$mins" -le 5 ]; then
  when="in ${mins}m"; color=$RED
elif [ "$mins" -le 15 ]; then
  when="in ${mins}m"; color=$YELLOW
elif [ "$mins" -lt 60 ]; then
  when="in ${mins}m"; color=$ACCENT
elif [ "$(date -r "$start" +%F)" = "$(date +%F)" ]; then
  when=$(date -r "$start" +%H:%M); color=$ACCENT
else
  when="tmrw $(date -r "$start" +%H:%M)"; color=$FG_DIM
fi

sketchybar --set "$NAME" drawing=on icon.color=$color label="$title · $when"
