{ ... }:
{
  imports = [
    ./packages.nix
    ./zsh.nix
    ./git.nix
    ./tmux.nix
    ./cli.nix
    ./btop.nix
    ./neovim.nix
  ];

  home.username = "johanhanses";
  home.homeDirectory = "/Users/johanhanses";

  # Do not change after first switch.
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
