-- Claude-warm colorscheme: github-nvim-theme (Primer structure, proven syntax
-- readability) with the palette overridden to the Claude desktop look — warm
-- charcoal dark / ivory light, coral accent, olive/gold/slate/sage hues, no purple.
-- Palette must stay in sync with shared/terminal + shared/tmux/themes.
return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 1000,
    lazy = false,
    config = function()
      require("github-theme").setup({
        options = {
          styles = {
            comments = "italic",
          },
        },
        palettes = {
          github_dark_dimmed = {
            canvas = { default = "#262624", overlay = "#30302e", inset = "#1f1e1d", subtle = "#30302e" },
            fg = { default = "#e8e6dc", muted = "#c9c5b9", subtle = "#918e83", onEmphasis = "#faf9f5" },
            accent = { fg = "#d97757", emphasis = "#c96442", muted = "#4a453e", subtle = "#33302c" },
            border = { default = "#403e3a", muted = "#3a3937" },
          },
          github_light = {
            canvas = { default = "#e6e0d1", overlay = "#e6e0d1", inset = "#ddd6c5", subtle = "#ddd6c5" },
            fg = { default = "#262624", muted = "#4a4942", subtle = "#7a786e", onEmphasis = "#faf9f5" },
            accent = { fg = "#9c4c28", emphasis = "#c96442", muted = "#dcccb6", subtle = "#e0d5c0" },
            border = { default = "#c7c1ae", muted = "#d8d0bc" },
          },
        },
        specs = {
          github_dark_dimmed = {
            syntax = {
              keyword = "#c96442", -- coral
              conditional = "#c96442",
              statement = "#c96442",
              preproc = "#c96442",
              func = "#85a3c4", -- slate
              string = "#90a870", -- olive
              regex = "#90a870",
              const = "#d0a45c", -- gold
              number = "#d0a45c",
              builtin0 = "#d0a45c",
              builtin1 = "#c68a94", -- rose (types/builtins)
              type = "#c68a94",
              field = "#85a3c4",
              comment = "#918e83",
              operator = "#c9c5b9",
              bracket = "#c9c5b9",
              dep = "#e0705f",
            },
          },
          github_light = {
            syntax = {
              keyword = "#9c4c28",
              conditional = "#9c4c28",
              statement = "#9c4c28",
              preproc = "#9c4c28",
              func = "#426187",
              string = "#4f6d2f",
              regex = "#4f6d2f",
              const = "#8a661a",
              number = "#8a661a",
              builtin0 = "#8a661a",
              builtin1 = "#8c4a5c",
              type = "#8c4a5c",
              field = "#426187",
              comment = "#7a786e",
              operator = "#4a4942",
              bracket = "#4a4942",
              dep = "#9e3a27",
            },
          },
        },
      })
      local is_dark = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):match("Dark")
      vim.o.background = is_dark and "dark" or "light"
      vim.cmd.colorscheme(is_dark and "github_dark_dimmed" or "github_light")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("github_dark_dimmed")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("github_light")
      end,
    },
  },
}
