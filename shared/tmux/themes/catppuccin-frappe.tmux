# Catppuccin Frappe — powerline status bar (rounded caps + icons).
# Needs a full-width Nerd Font (GeistMonoNF) — the Mono/NFM variant squeezes caps.

%hidden BG="#303446"
%hidden FG="#c6d0f5"
%hidden SURFACE="#414559"
%hidden MUTED="#838ba7"
%hidden BLUE="#8caaee"
%hidden GREEN="#a6d189"
%hidden YELLOW="#e5c890"
%hidden RED="#e78284"
%hidden MAGENTA="#ca9ee6"
%hidden CYAN="#81c8be"

set -g status on
set -g status-position bottom
set -g status-interval 5
set -g status-justify left
set -g status-left-length 200
set -g status-right-length 200
set -g status-style "bg=${BG},fg=${FG}"

set -g status-left "#[fg=${BLUE},bg=${BG}]#[fg=${BG},bg=${BLUE},bold]  #S #[fg=${BLUE},bg=${BG},nobold] "

set -g window-status-separator ""
set -g window-status-format         "#[fg=${SURFACE},bg=${BG}]#[fg=${MUTED},bg=${SURFACE}] #I #[fg=${FG},bg=${SURFACE}]#W #[fg=${SURFACE},bg=${BG}] "
set -g window-status-current-format "#[fg=${YELLOW},bg=${BG}]#[fg=${BG},bg=${YELLOW},bold] #I #[fg=${BG},bg=${YELLOW}]#W #[fg=${YELLOW},bg=${BG},nobold] "

set -g status-right "#[fg=${CYAN},bg=${BG}]#[fg=${BG},bg=${CYAN},bold]  %H:%M #[fg=${CYAN},bg=${BG}] #[fg=${MAGENTA},bg=${BG}]#[fg=${BG},bg=${MAGENTA},bold]  %d %b #[fg=${MAGENTA},bg=${BG},nobold]"

set -g pane-border-style        "fg=${SURFACE}"
set -g pane-active-border-style "fg=${BLUE}"
set -g message-style         "bg=${SURFACE},fg=${YELLOW},bold"
set -g message-command-style "bg=${SURFACE},fg=${CYAN},bold"
set -g mode-style "bg=${YELLOW},fg=${BG}"
