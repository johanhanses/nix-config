{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    historyLimit = 10000;
    terminal = "tmux-256color";
    sensibleOnTop = true; # tmux-sensible
    plugins = [ pkgs.tmuxPlugins.yank ];

    extraConfig = ''
      setw -g pane-base-index 1
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
      set -g renumber-windows on
      set -sa terminal-features ',xterm-256color:RGB'
      set -g set-titles on
      setw -g monitor-activity off
      set -g bell-action none
      set -g visual-bell off
      set -g visual-activity off
      set -g focus-events on
      setw -g aggressive-resize on
      set -g detach-on-destroy off

      # reload config + re-sync light/dark theme
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; run-shell -b 'theme-sync' \; display-message 'tmux.conf reloaded + theme synced'

      bind C-p previous-window
      bind C-n next-window

      # pane navigation
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # vim-aware pane navigation
      is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\\/)g?(view|n?vim?)(diff)?$"'
      bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
      bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
      bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
      bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

      bind -r n next-window
      bind -r p previous-window
      bind -r '<' swap-window -d -t -1
      bind -r '>' swap-window -d -t +1

      # sesh — fuzzy session switcher (overrides default 't' clock-mode)
      unbind t
      bind t display-popup -E -w 60% -h 60% 'sesh connect "$(sesh list -tcd | sort | fzf --reverse --no-sort --border --border-label " sesh " --prompt "  ")"'

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # macOS clipboard integration
      set-option -g set-clipboard on
      set-option -s copy-command "pbcopy"
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key P run "pbpaste | tmux load-buffer - && tmux paste-buffer"

      # toggle status bar
      bind-key b set-option status

      # --- theme: ANSI colours follow the terminal's Catppuccin Latte/Mocha
      #     palette, so the status bar switches light/dark with the terminal. ---
      set -g status-style "bg=default,fg=colour7"
      set -g status-left "#[fg=colour4,bold] #S #[default]"
      set -g status-left-length 30
      set -g status-right "#[fg=colour8]#{?client_prefix,#[fg=colour1]PREFIX ,}%H:%M "
      set -g window-status-format "#[fg=colour8] #I:#W "
      set -g window-status-current-format "#[fg=colour4,bold] #I:#W "
      set -g pane-border-style "fg=colour8"
      set -g pane-active-border-style "fg=colour4"
      set -g message-style "bg=default,fg=colour4"
      set -g mode-style "bg=colour4,fg=colour0"
    '';
  };
}
