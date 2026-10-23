-- GitHub CB (projekt0n/github-nvim-theme): GitHub's colorblind variants
-- (github_dark_colorblind / github_light_colorblind), re-grounded to match the
-- terminal — Dark Dimmed #22272e and grey #d7dade instead of GitHub's
-- #0d1117 / #ffffff. Canonical hex values in shared/terminal/gen-terminal.swift.
--
-- Swapping the canvas alone isn't enough: the plugin computes its tinted
-- backgrounds (cursor line, selection, diff, diagnostics) by blending against
-- the ORIGINAL canvas, so they're recomputed here with the plugin's own
-- formulas against the new ground.
-- fg matches the terminal's foreground; `bad` replaces the red that upstream's
-- light colorblind palette still uses for errors and removed lines.
local GROUND = {
  github_dark_colorblind = { bg = "#22272e", inset = "#1c2128", fg = "#adbac7" },
  github_light_colorblind = { bg = "#d7dade", inset = "#cacfd3", fg = "#24292f", bad = "#974b00" },
}

local function respec(theme)
  local C = require("github-theme.lib.color")
  local pal = require("github-theme.palette").load(theme)
  local g = GROUND[theme]
  local BG = C(g.bg)
  local function tint(c, a)
    return BG:blend(C(c), a):to_css()
  end
  local dark = not pal.meta.light
  local diag = {
    error = g.bad or pal.danger.fg,
    warn = pal.attention.fg,
    info = pal.accent.fg,
    hint = pal.fg.muted,
  }
  return {
    bg0 = g.inset,
    bg1 = g.bg,
    fg1 = g.fg,
    diag = diag,
    git = { removed = g.bad or pal.danger.fg },
    bg2 = tint(pal.neutral.emphasis, 0.1),
    -- dark upstream uses a flat gray[9] (#161b22), darker than the dimmed ground
    bg3 = dark and tint(pal.neutral.emphasis, 0.18) or tint(pal.scale.blue[9], 0.1),
    sel0 = tint(pal.accent.fg, dark and 0.45 or 0.22),
    sel1 = tint(pal.accent.muted, 0.9),
    sel2 = dark and tint(pal.scale.yellow[3], 0.6) or tint(pal.attention.emphasis, 0.3),
    diag_bg = {
      error = tint(diag.error, 0.15),
      warn = tint(diag.warn, 0.15),
      info = tint(diag.info, 0.15),
      hint = tint(diag.hint, 0.15),
    },
    diff = {
      add = dark and tint(pal.scale.green[6], 0.15) or tint(pal.scale.green[7], 0.3),
      delete = dark and tint(pal.scale.red[6], 0.15) or tint(pal.scale.red[7], 0.3),
      change = dark and tint(pal.scale.yellow[6], 0.15) or tint(pal.scale.yellow[7], 0.3),
    },
  }
end

local DARK, LIGHT = "github_dark_colorblind", "github_light_colorblind"

return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 1000,
    lazy = false,
    config = function()
      require("github-theme").setup({
        options = {
          styles = { comments = "italic" },
        },
        palettes = {
          [DARK] = { canvas = { default = GROUND[DARK].bg, inset = GROUND[DARK].inset } },
          [LIGHT] = { canvas = { default = GROUND[LIGHT].bg, inset = GROUND[LIGHT].inset } },
        },
        specs = {
          [DARK] = respec(DARK),
          [LIGHT] = respec(LIGHT),
        },
      })
      local is_dark = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):match("Dark")
      vim.o.background = is_dark and "dark" or "light"
      vim.cmd.colorscheme(is_dark and DARK or LIGHT)
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme(DARK)
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme(LIGHT)
      end,
    },
  },
}
