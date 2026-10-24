{ config, ... }:
{
  programs.git = {
    enable = true;

    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "tags"
      "vendor-tags"
      ".lvimrc"
      ".rgignore"
      ".vscode/"
      ".idea/"
      ".fleet/"
      "**/.claude/settings.local.json"
    ];

    # Work / client-specific git config (extra credential helpers, client TLS
    # certs, etc.) is tracked in the private dotfiles-private repo and linked
    # out-of-store to ~/.config/git/local.gitconfig (see xdg.configFile below).
    includes = [
      { path = "${config.home.homeDirectory}/.config/git/local.gitconfig"; }
      # delta light/dark feature, written by theme-sync (missing file = ignored)
      { path = "${config.home.homeDirectory}/.local/state/delta-theme.gitconfig"; }
    ];

    settings = {
      user = {
        name = "Johan Hanses";
        email = "johanhanses@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      # Default helper for other hosts using ~/.git-credentials.
      credential.helper = "store";

      # GitHub via gh's credential helper.
      "credential \"https://github.com\"".helper = [ "" "!gh auth git-credential" ];
      "credential \"https://gist.github.com\"".helper = [ "" "!gh auth git-credential" ];
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      navigate = true;
      side-by-side = false;
      decorations = true;
      # base16 follows the terminal's ANSI palette → tracks the theme light/dark.
      syntax-theme = "base16";
      # defaults are fixed 256-colour red/green; ANSI names follow the palette
      # (red/green render orange/blue in GitHub CB)
      line-numbers-minus-style = "red";
      line-numbers-plus-style = "green";

      # The +/- line backgrounds are NOT ANSI-driven (delta's defaults are
      # red/green), so the colorblind ones live here: removals orange, additions
      # blue, as GitHub's colorblind diffs (15% / 40% tints over each ground).
      # theme-sync picks one via ~/.local/state/delta-theme.gitconfig.
      cb-dark = {
        dark = true;
        minus-style = ''syntax "#3e322d"'';
        minus-emph-style = ''syntax "#6c432c"'';
        plus-style = ''syntax "#25364d"'';
        plus-emph-style = ''syntax "#2b4f81"'';
      };
      cb-light = {
        light = true;
        minus-style = ''syntax "#d2c7bd"'';
        minus-emph-style = ''syntax "#caad90"'';
        plus-style = ''syntax "#b8c9dd"'';
        plus-emph-style = ''syntax "#8fb2dd"'';
      };
    };
  };

  # Work/client git overlay (included above) — content tracked in the private
  # dotfiles-private repo, linked out-of-store so it never enters the nix store.
  xdg.configFile."git/local.gitconfig".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Repos/github.com/johanhanses/dotfiles-private/config/git/local.gitconfig";
}
