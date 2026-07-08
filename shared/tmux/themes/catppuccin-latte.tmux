# Catppuccin Latte — powerline status bar (rounded caps + icons).
# Needs a full-width Nerd Font (GeistMonoNF-Regular) — the Mono/NFM variant
# squeezes the powerline caps.

%hidden BG="#eff1f5"
%hidden FG="#4c4f69"
%hidden SURFACE="#ccd0da"
%hidden MUTED="#8c8fa1"
%hidden BLUE="#1e66f5"
%hidden GREEN="#40a02b"
%hidden YELLOW="#df8e1d"
%hidden RED="#d20f39"
%hidden MAGENTA="#8839ef"
%hidden CYAN="#179299"

set -g status on
set -g status-position bottom
set -g status-interval 5
set -g status-justify left
set -g status-left-length 200
set -g status-right-length 200
set -g status-style "bg=${BG},fg=${FG}"

# LEFT — session (terminal icon), blue rounded segment
set -g status-left "#[fg=${BLUE},bg=${BG}]#[fg=${BG},bg=${BLUE},bold]  #S #[fg=${BLUE},bg=${BG},nobold] "

# WINDOWS
set -g window-status-separator ""
set -g window-status-format         "#[fg=${SURFACE},bg=${BG}]#[fg=${MUTED},bg=${SURFACE}] #I #[fg=${FG},bg=${SURFACE}]#W #[fg=${SURFACE},bg=${BG}] "
set -g window-status-current-format "#[fg=${YELLOW},bg=${BG}]#[fg=${BG},bg=${YELLOW},bold] #I #[fg=${BG},bg=${YELLOW}]#W #[fg=${YELLOW},bg=${BG},nobold] "

# RIGHT — clock (cyan) + date (magenta), rounded segments
set -g status-right "#[fg=${CYAN},bg=${BG}]#[fg=${BG},bg=${CYAN},bold]  %H:%M #[fg=${CYAN},bg=${BG}] #[fg=${MAGENTA},bg=${BG}]#[fg=${BG},bg=${MAGENTA},bold]  %d %b #[fg=${MAGENTA},bg=${BG},nobold]"

set -g pane-border-style        "fg=${SURFACE}"
set -g pane-active-border-style "fg=${BLUE}"
set -g message-style         "bg=${SURFACE},fg=${YELLOW},bold"
set -g message-command-style "bg=${SURFACE},fg=${CYAN},bold"
set -g mode-style "bg=${YELLOW},fg=${BG}"
