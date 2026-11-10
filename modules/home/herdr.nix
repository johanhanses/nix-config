{ config, pkgs, ... }:
{
  # herdr — multiplexer for AI coding agents (CLI only; runs inside Ghostty).
  home.packages = [ pkgs.herdr ];

  # Config lives in the repo (shared/herdr/config.toml), linked out-of-store
  # rather than copied into the nix store: Herdr writes to this file itself
  # (onboarding flag, settings changed in its UI), so it has to stay writable.
  # Those writes land in the repo and show up in `git diff` — commit or revert
  # them. Edits apply live with `herdr server reload-config`, no rebuild needed.
  #
  # force: a switch replaces a plain file here with the link (e.g. should Herdr
  # ever save by replacing the file instead of writing through it). Caveat:
  # home-manager silently skips a plain file whose content is *identical* to
  # the repo copy, so if `ls -l` shows no link, delete the file and switch again.
  xdg.configFile."herdr/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repos/github.com/johanhanses/nix-config/shared/herdr/config.toml";
    force = true;
  };
}
