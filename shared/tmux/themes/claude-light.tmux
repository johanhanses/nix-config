# Claude Light — warm ivory, coral accent — powerline status bar (rounded caps + icons).
# Needs a full-width Nerd Font (GeistMonoNF) — the Mono/NFM variant squeezes caps.

%hidden BG="#faf9f5"
%hidden FG="#3d3d3a"
%hidden SURFACE="#e8e5da"
%hidden MUTED="#87867f"
%hidden ACCENT="#c96442"
%hidden GREEN="#5a7a37"
%hidden YELLOW="#9c7420"
%hidden RED="#b0432f"
%hidden MAGENTA="#9c5468"
%hidden CYAN="#457a68"

set -g status on
set -g status-position bottom
set -g status-interval 5
set -g status-justify left
set -g status-left-length 200
set -g status-right-length 200
set -g status-style "bg=${BG},fg=${FG}"

set -g status-left "#[fg=${ACCENT},bg=${BG}]#[fg=${BG},bg=${ACCENT},bold]  #S #[fg=${ACCENT},bg=${BG},nobold] "

set -g window-status-separator ""
set -g window-status-format         "#[fg=${SURFACE},bg=${BG}]#[fg=${MUTED},bg=${SURFACE}] #I #[fg=${FG},bg=${SURFACE}]#W #[fg=${SURFACE},bg=${BG}] "
set -g window-status-current-format "#[fg=${YELLOW},bg=${BG}]#[fg=${BG},bg=${YELLOW},bold] #I #[fg=${BG},bg=${YELLOW}]#W #[fg=${YELLOW},bg=${BG},nobold] "

set -g status-right "#[fg=${CYAN},bg=${BG}]#[fg=${BG},bg=${CYAN},bold]  %H:%M #[fg=${CYAN},bg=${BG}] #[fg=${MAGENTA},bg=${BG}]#[fg=${BG},bg=${MAGENTA},bold]  %d %b #[fg=${MAGENTA},bg=${BG},nobold]"

set -g pane-border-style        "fg=${SURFACE}"
set -g pane-active-border-style "fg=${ACCENT}"
set -g message-style         "bg=${SURFACE},fg=${YELLOW},bold"
set -g message-command-style "bg=${SURFACE},fg=${CYAN},bold"
set -g mode-style "bg=${YELLOW},fg=${BG}"
