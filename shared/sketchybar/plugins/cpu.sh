#!/bin/sh
ncpu=$(sysctl -n hw.ncpu)
pct=$(ps -A -o %cpu= | awk -v n="$ncpu" '{s += $1} END {printf "%.0f", s / n}')
sketchybar --set "$NAME" label="$pct%"
