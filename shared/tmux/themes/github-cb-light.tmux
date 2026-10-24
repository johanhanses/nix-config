# GitHub CB Light — GitHub Light Colorblind on a dimmed grey ground — one-accent status bar (option B).
# Blue is the only hue: solid session pill, current window on a blue tint,
# other windows plain text, one neutral date/time pill. Orange is a signal
# only: the session pill turns orange while the prefix is held, and a zoomed
# window shows an orange marker. Selection/copy-mode use the terminal's own
# selection colour.
# Needs a full-width Nerd Font (JetBrainsMono Nerd Font) — the "NF Mono" variant squeezes caps.
# Glyphs are Nerd Font codepoints: derive variants with sed, never retype.

%hidden BG="#d7dade"
%hidden FG="#24292f"
%hidden SURFACE="#c4c9ce"
%hidden MUTED="#6e7781"
%hidden ACCENT="#085cbf"
%hidden TINT="#b5c4d6"
%hidden ORANGE="#974b00"
%hidden SEL="#a9bed7"
%hidden LEAD="#{?client_prefix,${ORANGE},${ACCENT}}"

set -g status on
set -g status-position bottom
set -g status-interval 5
set -g status-justify left
set -g status-left-length 200
set -g status-right-length 200
set -g status-style "bg=${BG},fg=${FG}"

set -g status-left "#[fg=${LEAD},bg=${BG}]#[fg=${BG},bg=${LEAD},bold] #S#[fg=${LEAD},bg=${BG},nobold]  "

set -g window-status-separator " "
set -g window-status-format         "#[fg=${MUTED},bg=${BG},bold] #I #[nobold]#W#{?window_zoomed_flag,#[fg=${ORANGE}] ,} "
set -g window-status-current-format "#[fg=${TINT},bg=${BG}]#[fg=${ACCENT},bg=${TINT},bold]#I #[fg=${FG}]#W#{?window_zoomed_flag,#[fg=${ORANGE}] ,}#[fg=${TINT},bg=${BG},nobold]"

set -g status-right "#[fg=${SURFACE},bg=${BG}]#[fg=${FG},bg=${SURFACE}]%a %d %b #[fg=${MUTED}]· #[fg=${FG},bold]%H:%M#[fg=${SURFACE},bg=${BG},nobold]"

set -g pane-border-style        "fg=${SURFACE}"
set -g pane-active-border-style "fg=${ACCENT}"
set -g message-style         "bg=${SURFACE},fg=${FG}"
set -g message-command-style "bg=${SURFACE},fg=${ACCENT}"
set -g mode-style "bg=${SEL},fg=${FG}"
