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

    casks = [
      "1password"
      "tailscale-app"
      "badgeify"
      "claude"
      "wispr-flow"
      "mattermost"
      "microsoft-teams"
      "docker-desktop"
    ];

    # Mac App Store apps (needs App Store sign-in, which is done).
    masApps = {
      "Moom Classic" = 419330170; # Moom 3.x — the classic version (not the v4 cask)
    };
    # RunCat / TabBack still deferred until their IDs are confirmed on-device.
  };
}
