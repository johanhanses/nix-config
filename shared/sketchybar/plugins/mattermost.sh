#!/bin/sh
# Mattermost notifier via the REST API (Desktop's dock badge stays empty for
# unreads without mentions). Same URL config + keychain token as theme-sync.
# Shows the mention count (DMs count as mentions), "•" for plain unreads,
# hidden when all read.
. "$HOME/.config/sketchybar/colors.sh"
MM_CFG="$HOME/Repos/github.com/johanhanses/dotfiles-private/mattermost/config"
[ -f "$MM_CFG" ] && . "$MM_CFG"
TOKEN=$(security find-generic-password -s mattermost-token -w 2>/dev/null)
[ -n "${MATTERMOST_URL:-}" ] && [ -n "$TOKEN" ] || { sketchybar --set "$NAME" drawing=off; exit 0; }

# Count the way the app does with Collapsed Reply Threads: channels by their
# *root* posts (the plain msg/mention counters include thread replies, which
# reading the channel never clears — that left the widget stuck for hours),
# plus unread threads/thread mentions from teams/unread. Channels come from
# channels + channel_members because teams/unread skips DMs/group messages;
# channels set to "mentions only" (mark_unread=mention) don't count as unread.
API="$MATTERMOST_URL/api/v4/users/me"
get() { curl -sf -m 5 -H "Authorization: Bearer $TOKEN" "$API/$1"; }
channels=$(get "channels?per_page=200") || exit 0 # offline: keep last state
members=$(get "channel_members?per_page=200") || exit 0
teams=$(get "teams/unread") || exit 0
counts=$(jq -rn --argjson ch "$channels" --argjson cm "$members" --argjson tu "$teams" '
  ($ch | map({(.id): .total_msg_count_root}) | add) as $total
  | [$cm[] | select($total[.channel_id])] as $m
  | [($m | map(.mention_count_root) | add // 0) + ($tu | map(.thread_mention_count) | add // 0),
     ($m | map(select(.notify_props.mark_unread != "mention" and $total[.channel_id] > .msg_count_root)) | length)
       + ($tu | map(.thread_count) | add // 0)]
  | @tsv') || exit 0
mentions=${counts%%	*}
unread=${counts##*	}

if [ "$mentions" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on label="$mentions" icon.color=$RED
elif [ "$unread" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on label="•" icon.color=$ACCENT
else
  sketchybar --set "$NAME" drawing=off
fi
