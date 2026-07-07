{ ... }:
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

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      navigate = true;
      side-by-side = false;
      decorations = true;
      # base16 follows the terminal's ANSI palette → tracks Catppuccin light/dark.
      syntax-theme = "base16";
    };
  };
}
