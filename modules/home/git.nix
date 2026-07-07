{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Johan Hanses";
    userEmail = "johanhanses@gmail.com";

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        navigate = true;
        side-by-side = false;
        decorations = true;
        # base16 uses the terminal's ANSI palette, so it follows the
        # Catppuccin Latte/Mocha light/dark switch automatically.
        syntax-theme = "base16";
      };
    };

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

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      # Default helper for hosts using ~/.git-credentials (e.g. gitlab.delaval.cloud).
      credential.helper = "store";

      # GitHub via gh's credential helper.
      "credential \"https://github.com\"".helper = [ "" "!gh auth git-credential" ];
      "credential \"https://gist.github.com\"".helper = [ "" "!gh auth git-credential" ];

      # LKAB on-prem GitHub Enterprise: client cert + macOS keychain.
      "credential \"https://github.lkab.com\"".helper = [ "" "osxkeychain" ];
      "http \"https://github.lkab.com/\"" = {
        sslVerify = true;
        sslCert = "/Users/johanhanses/Repos/github.com/Digital-Tvilling/.lkab/on-prem/cert/certificate.pem";
        sslKey = "/Users/johanhanses/Repos/github.com/Digital-Tvilling/.lkab/on-prem/cert/private_key.pem";
      };
    };
  };
}
