return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        background = { light = "latte", dark = "frappe" },
        styles = {
          comments = { "italic" },
        },
      })
      local is_dark = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):match("Dark")
      vim.o.background = is_dark and "dark" or "light"
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("catppuccin")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("catppuccin")
      end,
    },
  },
}
