{ pkgs, lib, ... }:
{
  # Determinate Nix manages the Nix installation and daemon, so nix-darwin
  # must NOT manage nix itself. (Top cause of Determinate + nix-darwin breakage.)
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Unfree is opt-in per package, never a blanket allowUnfree — keep the
  # exception list explicit. 1password-cli: `op` reads work credentials
  # (DT hub-Vault root token) out of 1Password for agent sessions.
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password-cli"
    ];

  # The primary user for user-scoped system settings + homebrew (Phase 2).
  system.primaryUser = "johanhanses";
  users.users.johanhanses.home = "/Users/johanhanses";

  # zsh is the login shell; full config lives in home-manager (Phase 4).
  programs.zsh.enable = true;

  # Fonts (nerd fonts for the terminal + nvim icons).
  # maple-mono.NF installs as family "Maple Mono NF" — upstream's own
  # Nerd Font build, full-width glyphs.
  fonts.packages = with pkgs; [
    maple-mono.NF
    nerd-fonts.symbols-only
  ];
}
