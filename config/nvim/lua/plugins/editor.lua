return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    init = function()
      -- Open the explorer sidebar on startup with the cursor in the file tree.
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          Snacks.explorer()
        end,
      })
    end,
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader><space>", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
    },
    opts = {
      explorer = { replace_netrw = true },
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules", ".next", "dist" },
          },
          grep = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules", ".next", "dist" },
          },
          explorer = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules", ".next", "dist" },
            -- No search box: drop the input window from the sidebar layout and
            -- put the cursor straight into the file tree.
            focus = "list",
            layout = { preset = "sidebar", preview = false, hidden = { "input" } },
          },
        },
      },
    },
  },
}
