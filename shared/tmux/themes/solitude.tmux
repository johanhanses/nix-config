# Solitude (Omarchy): greys on near-black, one-accent status bar.
# Light grey is the only tone: solid session pill, current window on a grey
# tint, other windows plain text, one neutral date/time pill. Rust is a signal
# only: the session pill turns rust while the prefix is held, and a zoomed
# window shows a rust marker (the variable is still called ORANGE).
# Selection/copy-mode use the terminal's own selection colour.
# Needs a full-width Nerd Font (CaskaydiaMono Nerd Font) — the "NF Mono" variant squeezes caps.
# Glyphs are Nerd Font codepoints: derive variants with sed, never retype.

%hidden BG="#101315"
%hidden FG="#cacccc"
%hidden SURFACE="#343d41"
%hidden MUTED="#798186"
%hidden ACCENT="#a8adb0"
%hidden TINT="#25292b"
%hidden ORANGE="#de6145"
%hidden SEL="#343d41"
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
