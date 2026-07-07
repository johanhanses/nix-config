{ ... }:
{
  # Determinate Nix manages the Nix installation and daemon, so nix-darwin
  # must NOT manage nix itself. (Top cause of Determinate + nix-darwin breakage.)
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # The primary user for user-scoped system settings + homebrew (Phase 2).
  system.primaryUser = "johanhanses";
  users.users.johanhanses.home = "/Users/johanhanses";

  # zsh is the login shell; full config lives in home-manager (Phase 4).
  programs.zsh.enable = true;
}
