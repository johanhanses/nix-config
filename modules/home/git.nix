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
      # base16 follows the terminal's ANSI palette (Solitude's greys).
      syntax-theme = "base16";
      dark = true;
      # Solitude has no red/green: removals are its one rust red, additions a
      # light grey. Solitude's ANSI "red" is a dim grey, so the line numbers use
      # hex rather than ANSI names.
      line-numbers-minus-style = ''"#de6145"'';
      line-numbers-plus-style = ''"#9fa5a9"'';

      # The +/- line backgrounds are NOT ANSI-driven (delta's defaults are
      # red/green): rust and grey tints over the #101315 ground (15% / 40%).
      minus-style = ''syntax "#2f1f1c"'';
      minus-emph-style = ''syntax "#623228"'';
      plus-style = ''syntax "#25292b"'';
      plus-emph-style = ''syntax "#494e50"'';
    };
  };

  # Work/client git overlay (included above) — content tracked in the private
  # dotfiles-private repo, linked out-of-store so it never enters the nix store.
  xdg.configFile."git/local.gitconfig".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Repos/github.com/johanhanses/dotfiles-private/config/git/local.gitconfig";
}
