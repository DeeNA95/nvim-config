-- In your lua/config/plugins/appearance.lua
return {
  -- Tokyo Night theme - elegant dark theme with multiple variants
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- Choose: night, storm, day, moon
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },

  -- Other beautiful themes to try (uncomment to use)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true, -- Keep this lazy-loaded
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
  },
}

