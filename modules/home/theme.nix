{ config, ... }:
let
  scripts = "${config.home.homeDirectory}/Repos/github.com/johanhanses/nix-config/shared/scripts";
in
{
  # Auto light/dark: a background agent runs theme-sync the moment macOS
  # appearance toggles (Terminal.app profile + btop theme + tmux reload).
  launchd.agents.theme-watch = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "exec ${scripts}/theme-watch"
      ];
      EnvironmentVariables = {
        PATH = "/usr/bin:/bin:/usr/sbin:/sbin:/run/current-system/sw/bin";
        THEME_SYNC = "${scripts}/theme-sync";
      };
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";
      StandardOutPath = "${config.home.homeDirectory}/.local/state/theme-watch.log";
      StandardErrorPath = "${config.home.homeDirectory}/.local/state/theme-watch.log";
    };
  };
}
