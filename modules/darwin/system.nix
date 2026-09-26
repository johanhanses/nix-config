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
  # Terminal face: Monaspace Neon NF — upstream's own Nerd Font build, shipped
  # inside pkgs.monaspace. That package carries ~635 files (five families, plus
  # Frozen/Var/Wide cuts), so only the normal-width Neon NF faces are copied out.
  # maple-mono.NF (family "Maple Mono NF") stays installed as the previous
  # terminal font, for quick switching back.
  fonts.packages = with pkgs; [
    (runCommand "monaspace-neon-nf" { } ''
      mkdir -p $out/share/fonts/opentype
      for f in ${monaspace}/share/fonts/opentype/MonaspaceNeonNF-*.otf; do
        case $f in *Wide*) ;; *) cp $f $out/share/fonts/opentype/ ;; esac
      done
    '')
    maple-mono.NF
    nerd-fonts.symbols-only
  ];
}
