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
            canvas = { default = "#faf9f5", overlay = "#faf9f5", inset = "#f0eee6", subtle = "#f0eee6" },
            fg = { default = "#3d3d3a", muted = "#57564f", subtle = "#87867f", onEmphasis = "#faf9f5" },
            accent = { fg = "#a8542f", emphasis = "#c96442", muted = "#ecdfd2", subtle = "#f5ece1" },
            border = { default = "#d5d1c3", muted = "#e8e5da" },
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
              keyword = "#a8542f",
              conditional = "#a8542f",
              statement = "#a8542f",
              preproc = "#a8542f",
              func = "#4c6d96",
              string = "#5a7a37",
              regex = "#5a7a37",
              const = "#9c7420",
              number = "#9c7420",
              builtin0 = "#9c7420",
              builtin1 = "#9c5468",
              type = "#9c5468",
              field = "#4c6d96",
              comment = "#87867f",
              operator = "#57564f",
              bracket = "#57564f",
              dep = "#b0432f",
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
