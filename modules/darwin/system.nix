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
  # Terminal face: JetBrains Mono Nerd Font (family "JetBrainsMono Nerd Font",
  # the full-width NF cut — not "NF Mono", which squeezes powerline caps).
  # Monaspace Neon NF (upstream's own Nerd Font build, inside pkgs.monaspace —
  # ~635 files, so only the normal-width Neon NF faces are copied out) and
  # maple-mono.NF stay installed as earlier terminal fonts, for quick switching.
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
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
