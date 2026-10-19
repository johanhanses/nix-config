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

# teams/unread skips DMs/group messages, so join every channel (incl. D/G)
# with its membership: unread = total - read; channels set to
# "mentions only" (mark_unread=mention) don't count as unread.
API="$MATTERMOST_URL/api/v4/users/me"
channels=$(curl -sf -m 5 -H "Authorization: Bearer $TOKEN" "$API/channels?per_page=200") || exit 0 # offline: keep last state
members=$(curl -sf -m 5 -H "Authorization: Bearer $TOKEN" "$API/channel_members?per_page=200") || exit 0
counts=$(jq -rn --argjson ch "$channels" --argjson cm "$members" '
  ($ch | map({(.id): .total_msg_count}) | add) as $total
  | [$cm[] | select($total[.channel_id])] as $m
  | [($m | map(.mention_count) | add // 0),
     ($m | map(select(.notify_props.mark_unread != "mention" and $total[.channel_id] > .msg_count)) | length)]
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
