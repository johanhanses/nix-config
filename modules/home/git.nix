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
      # base16 follows the terminal's ANSI palette → tracks the theme light/dark.
      syntax-theme = "base16";
    };
  };

  # Work/client git overlay (included above) — content tracked in the private
  # dotfiles-private repo, linked out-of-store so it never enters the nix store.
  xdg.configFile."git/local.gitconfig".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Repos/github.com/johanhanses/dotfiles-private/config/git/local.gitconfig";
}
