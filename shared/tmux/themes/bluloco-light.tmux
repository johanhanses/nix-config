# Bluloco Light — near-white ground, vivid blue accent — powerline status bar (rounded caps + icons).
# Needs a full-width Nerd Font (Maple Mono NF) — the Mono/NFM variant squeezes caps.

%hidden BG="#f9f9f9"
%hidden FG="#373a41"
%hidden SURFACE="#e6e6e7"
%hidden MUTED="#9a9ca5"
%hidden ACCENT="#275fe4"
%hidden GREEN="#23974a"
%hidden YELLOW="#c5a332"
%hidden RED="#d52753"
%hidden MAGENTA="#ce33c0"
%hidden CYAN="#27618d"

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
