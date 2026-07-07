{ ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # lazy.nvim plugins don't need the ruby/python/node remote providers.
    withRuby = false;
    withPython3 = false;
    withNodeJs = false;
  };

  # Ship the existing lazy.nvim config as-is; lazy.nvim manages plugins at
  # runtime (pinned by the committed lazy-lock.json). Colorscheme is Catppuccin
  # (see config/nvim/lua/plugins/colorscheme.lua) with auto-dark-mode.nvim.
  xdg.configFile."nvim".source = ../../config/nvim;
}
