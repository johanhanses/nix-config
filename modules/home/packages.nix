{ pkgs, ... }:
{
  # CLI tooling (everything that used to be Homebrew `brew`), now from Nix.
  # Interactive tools with their own home-manager module (fzf, bat, eza, zoxide,
  # gh, btop, git, tmux, neovim, sesh) are configured in Phase 4 instead of here.
  home.packages = with pkgs; [
    # modern basics
    ripgrep
    fd
    jq
    yq-go

    # git tooling
    lazygit

    # tmux session manager (used by the sesh popup + wts alias)
    sesh

    # kubernetes
    kubectl
    kubernetes-helm
    k3d
    kubectx
    kubeconform

    # cloud / work auth
    awscli2
    azure-cli
    saml2aws

    # agent/scripting runtime (macOS system python3 is EOL 3.9)
    python3

    # neovim toolchain — runtimes, language servers, formatters, linters
    nodejs_22
    pnpm
    typescript
    typescript-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    lua-language-server
    biome
    prettier
    stylua
    shellcheck
    tree-sitter

    # misc
    terminal-notifier
  ];
}
