{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidget.command = "fd --type f --hidden --follow --exclude .git";
    changeDirWidget.command = "fd --type d --hidden --follow --exclude .git";
    # no custom colours → fzf inherits the terminal's Catppuccin palette
  };

  programs.bat = {
    enable = true;
    # "ansi" follows the terminal palette, so bat tracks light/dark automatically.
    config.theme = "ansi";
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = false; # custom eza aliases live in shared/zsh/init.zsh
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = false; # credential helpers configured in git.nix
    settings.git_protocol = "https";
  };

  # sesh — smart tmux session manager (static session list; live sessions are
  # auto-discovered). No native HM module, so ship the config file directly.
  xdg.configFile."sesh/sesh.toml".source = ../../shared/sesh/sesh.toml;
}
