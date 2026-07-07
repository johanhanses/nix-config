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

    # Mac App Store apps deferred: Moom Classic (419330170) isn't owned on this
    # Apple ID (the old Moom was a Many Tricks direct license, not an App Store
    # purchase), so it's installed from the Many Tricks direct download instead.
    # RunCat / TabBack also deferred until their IDs are confirmed on-device.
    # masApps = { };
  };
}
