{ lib, ... }:
{
  imports = [
    ./packages.nix
    ./zsh.nix
    ./git.nix
    ./tmux.nix
    ./cli.nix
    ./btop.nix
    ./neovim.nix
    ./theme.nix
  ];

  home.username = "johanhanses";
  home.homeDirectory = "/Users/johanhanses";

  # Do not change after first switch.
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # Screenshot destination (matches system.defaults.screencapture.location).
  home.activation.screenshotsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/Pictures/Screenshots"
  '';
}
