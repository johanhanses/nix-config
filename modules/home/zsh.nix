{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      path = "${config.home.homeDirectory}/.histfile";
      size = 25000;
      save = 25000;
      share = true;
      ignoreSpace = true;
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      XDG_CONFIG_HOME = "$HOME/.config";
      REPOS = "$HOME/Repos";
      GITUSER = "johanhanses";
      GHREPOS = "$HOME/Repos/github.com/johanhanses";
      DOTFILES = "$HOME/Repos/github.com/johanhanses/nix-config";
      SCRIPTS = "$HOME/Repos/github.com/johanhanses/nix-config/shared/scripts";
      SECOND_BRAIN = "$HOME/Repos/github.com/johanhanses/zettelkasten";
      # Work-specific env (WORK_DIR, client dirs, WT_REPOS) + aliases live in
      # the untracked ~/.config/zsh/local.zsh, sourced from shared/zsh/init.zsh.
      AWS_PROFILE = "saml";
      KUBECONFIG = "$HOME/.kube/config";
    };

    # Prompt, worktree functions, and aliases live in a real shell file
    # (keeps ${...} expansions out of Nix string escaping). readFile inlines it.
    initContent = ''
      setopt append_history inc_append_history
      bindkey -e
      unset zle_bracketed_paste
    '' + builtins.readFile ../../shared/zsh/init.zsh;
  };

  # ~/.local/bin and the repo scripts dir on PATH (theme-sync, lastshot, ide, …).
  home.sessionPath = [
    "$HOME/.local/bin"
    "${config.home.homeDirectory}/Repos/github.com/johanhanses/nix-config/shared/scripts"
  ];
}
