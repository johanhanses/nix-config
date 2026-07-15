{ config, ... }:
{
  # Declarative Homebrew — CLI tools come from Nix; Homebrew is only for GUI
  # casks (and, later, Mac App Store apps) that can't be packaged reliably in Nix.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap"; # remove anything not listed here
    };

    # taps are pinned via nix-homebrew (mutableTaps = false).
    taps = builtins.attrNames config.nix-homebrew.taps;

    # Exception to the CLI-from-Nix rule: macOS ties notification permission to
    # the app bundle path, and the nix store path changes every update, so the
    # nix build never keeps its grant (notifications get dropped silently).
    brews = [
      "terminal-notifier"
    ];

    casks = [
      "1password"
      "tailscale-app"
      "badgeify"
      "claude"
      "wispr-flow"
      "mattermost"
      "microsoft-teams"
      "docker-desktop"
      "obsidian"
      "google-chrome"
      "firefox"
    ];

    # Mac App Store apps (App Store signed in; IDs confirmed on-device via `mas list`).
    # Moom Classic (419330170) is NOT here — not owned on this Apple ID; it's
    # installed from the Many Tricks direct download instead (see SETUP.md).
    masApps = {
      "RunCat" = 1429033973;
      "TabBack for Safari" = 1660506599;
      "uBlock Origin Lite" = 6745342698;
    };
  };
}
