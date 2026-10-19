#!/bin/sh
# One Dark / One Light for the bar, mirroring shared/terminal/gen-terminal.swift
# (format 0xAARRGGBB). The mode comes from the state file theme-sync writes, so
# the bar never queries System Events itself (no extra Automation prompt).
MODE=$(cat "$HOME/.local/state/theme-mode" 2>/dev/null)

if [ "$MODE" = light ]; then
  export BAR_COLOR=0xf0fafafa    # bg, slightly translucent over the blur
  export BAR_BORDER=0xffe5e5e6
  export ITEM_BG=0xffe5e5e6      # selection
  export FG=0xff383a42
  export FG_DIM=0xffa0a1a7
  export ACCENT=0xff4078f2
  export ON_ACCENT=0xfffafafa
  export RED=0xffe45649
  export GREEN=0xff50a14f
  export YELLOW=0xffc18401
else
  export BAR_COLOR=0xf0282c34
  export BAR_BORDER=0xff3e4451
  export ITEM_BG=0xff3e4451
  export FG=0xffabb2bf
  export FG_DIM=0xff5c6370
  export ACCENT=0xff61afef
  export ON_ACCENT=0xff282c34
  export RED=0xffe06c75
  export GREEN=0xff98c379
  export YELLOW=0xffe5c07b
fi
