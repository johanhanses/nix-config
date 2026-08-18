-- Bluloco (uloco/bluloco.nvim) — the author's own Neovim port, built on lush.
-- style = "auto" tracks `vim.o.background` at runtime, so the light/dark swap
-- is just a background flip; no re-sourcing needed.
-- Canonical hex values in shared/terminal/gen-terminal.swift.
return {
  {
    "uloco/bluloco.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    priority = 1000,
    lazy = false,
    config = function()
      require("bluloco").setup({
        style = "auto",
        italics = true,
        transparent = false,
        guicursor = true,
      })
      local is_dark = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):match("Dark")
      vim.o.background = is_dark and "dark" or "light"
      vim.cmd.colorscheme("bluloco")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.o.background = "dark"
      end,
      set_light_mode = function()
        vim.o.background = "light"
      end,
    },
  },
}
