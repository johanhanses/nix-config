#!/bin/sh
# Current kubectl context, read straight from the kubeconfig (no kubectl
# call). Turns red for anything that looks like prod. EKS ARNs are cut to
# the cluster name.
. "$HOME/.config/sketchybar/colors.sh"
cfg=${KUBECONFIG:-$HOME/.kube/config}
cfg=${cfg%%:*} # first file of a KUBECONFIG list holds current-context
ctx=$(sed -n 's/^current-context: *//p' "$cfg" 2>/dev/null | tr -d '"')

if [ -z "$ctx" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

label=${ctx##*/}
[ ${#label} -gt 22 ] && label="$(printf '%s' "$label" | cut -c1-21)…"

case $ctx in
  *prod* | *prd*)
    sketchybar --set "$NAME" drawing=on label="$label" \
      background.drawing=on background.color=$RED icon.color=$ON_ACCENT label.color=$ON_ACCENT ;;
  *)
    sketchybar --set "$NAME" drawing=on label="$label" \
      background.drawing=off icon.color=$ACCENT label.color=$FG ;;
esac
