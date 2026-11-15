-- Solitude: ficcdaf/ashen.nvim is the colorscheme Omarchy pairs with its
-- Solitude theme (greys with red and orange accents). Ashen's own ground is
-- #121212; it is overridden with Solitude's #101315 so nvim sits flush with the
-- terminal (canonical palette: shared/ghostty/themes/solitude).
-- One theme regardless of macOS appearance, so there is no auto-dark-mode.
return {
  {
    "ficcdaf/ashen.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      colors = { background = "#101315" },
      style_presets = { italic_comments = true },
    },
    config = function(_, opts)
      require("ashen").setup(opts)
      vim.o.background = "dark"
      vim.cmd.colorscheme("ashen")
    end,
  },
}
