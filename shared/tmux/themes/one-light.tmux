# One Light — Atom One Light, blue accent — powerline status bar (rounded caps + icons).
# Needs a full-width Nerd Font (Maple Mono NF) — the Mono/NFM variant squeezes caps.

%hidden BG="#fafafa"
%hidden FG="#383a42"
%hidden SURFACE="#e5e5e6"
%hidden MUTED="#a0a1a7"
%hidden ACCENT="#4078f2"
%hidden GREEN="#50a14f"
%hidden YELLOW="#c18401"
%hidden RED="#e45649"
%hidden MAGENTA="#a626a4"
%hidden CYAN="#0184bc"

set -g status on
set -g status-position bottom
set -g status-interval 5
set -g status-justify left
set -g status-left-length 200
set -g status-right-length 200
set -g status-style "bg=${BG},fg=${FG}"

# Inverted pills for light mode: neutral SURFACE fills, color lives in the text
# (solid colored pills read too loud against the pale background).
set -g status-left "#[fg=${SURFACE},bg=${BG}]#[fg=${ACCENT},bg=${SURFACE},bold]  #S #[fg=${SURFACE},bg=${BG},nobold] "

set -g window-status-separator ""
set -g window-status-format         "#[fg=${SURFACE},bg=${BG}]#[fg=${MUTED},bg=${SURFACE}] #I #[fg=${FG},bg=${SURFACE}]#W #[fg=${SURFACE},bg=${BG}] "
set -g window-status-current-format "#[fg=${SURFACE},bg=${BG}]#[fg=${YELLOW},bg=${SURFACE},bold] #I #[fg=${YELLOW},bg=${SURFACE}]#W #[fg=${SURFACE},bg=${BG},nobold] "

set -g status-right "#[fg=${SURFACE},bg=${BG}]#[fg=${CYAN},bg=${SURFACE},bold]  %H:%M #[fg=${SURFACE},bg=${BG}] #[fg=${SURFACE},bg=${BG}]#[fg=${MAGENTA},bg=${SURFACE},bold]  %d %b #[fg=${SURFACE},bg=${BG},nobold]"

set -g pane-border-style        "fg=${SURFACE}"
set -g pane-active-border-style "fg=${ACCENT}"
set -g message-style         "bg=${SURFACE},fg=${YELLOW},bold"
set -g message-command-style "bg=${SURFACE},fg=${CYAN},bold"
set -g mode-style "bg=${YELLOW},fg=${BG}"
