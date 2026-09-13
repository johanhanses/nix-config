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
    plugins = [
      pkgs.tmuxPlugins.yank

      # resurrect + continuum: survive reboots. continuum MUST stay last —
      # it appends the save/restore hooks and expects resurrect loaded first.
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = ''
          # Restore each pane's visible scrollback, not just the layout. This is
          # the part that makes a restored session identifiable: window names
          # here are all `#{b:pane_current_path}`, so six Claude windows in one
          # repo look identical until you can see what each was doing.
          set -g @resurrect-capture-pane-contents 'on'

          # Claude Code is deliberately NOT in @resurrect-processes. It *would*
          # match (resurrect matches the full `ps` command line, so "~claude"
          # hits `claude --dangerously-skip-permissions` — the short
          # pane_current_command is just the version string, e.g. "2.1.266"),
          # but relaunching it starts a BRAND NEW conversation rather than
          # reopening the old one. `--continue` is no better when several
          # sessions share one cwd: it resumes the most recent for that dir, so
          # every restored window would land on the same conversation. There is
          # no pid -> session-id link to record either (Claude keeps no open
          # handle on its transcript and exports no session-id env var).
          # So: restore the layout, dirs and scrollback, then pick per window
          # with `claude --resume` (bare = interactive picker). Transcripts
          # themselves always persist in ~/.claude/projects/<slug>/<id>.jsonl.
          set -g @resurrect-processes 'false'
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];

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

      # --- theme: One Dark/Light status bar (segmented powerline).
      #     Variant chosen by macOS appearance at startup; re-sourced on toggle
      #     by theme-sync. ---
      if-shell '[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]' \
        "source-file ~/.config/tmux/themes/one-dark.tmux" \
        "source-file ~/.config/tmux/themes/one-light.tmux"
    '';
  };

  # Ship the tmux status-bar themes (sourced above + by theme-sync).
  xdg.configFile = {
    "tmux/themes/one-dark.tmux".source = ../../shared/tmux/themes/one-dark.tmux;
    "tmux/themes/one-light.tmux".source = ../../shared/tmux/themes/one-light.tmux;
  };
}
