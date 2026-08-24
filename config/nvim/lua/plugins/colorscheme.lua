-- Tokyo Night (folke/tokyonight.nvim). `style` is the dark flavour and
-- `light_style` the light one; the plugin picks between them from
-- `vim.o.background`, so the light/dark swap is just a background flip.
-- Storm rather than the default Night — see gen-terminal.swift for why.
-- Canonical hex values in shared/terminal/gen-terminal.swift.
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("tokyonight").setup({
        style = "storm",
        light_style = "day",
        styles = { comments = { italic = true }, keywords = { italic = true } },
        transparent = false,
      })
      local is_dark = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):match("Dark")
      vim.o.background = is_dark and "dark" or "light"
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("tokyonight")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("tokyonight")
      end,
    },
  },
}
