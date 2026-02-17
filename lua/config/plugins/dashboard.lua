-- Dashboard with alpha-nvim
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Master Roshi's Turtle Hermit School header
    dashboard.section.header.val = {
      "                                        ",
      "    ╔═══════════════════════════════╗    ",
      "    ║     🐢  TURTLE HERMIT SCHOOL  ║    ",
      "    ║        ── 亀仙流 ──           ║    ",
      "    ╠═══════════════════════════════╣    ",
      "    ║                               ║    ",
      "    ║  \"Work Hard, Study Well, and  ║    ",
      "    ║   Eat and Sleep Plenty!\"      ║    ",
      "    ║                               ║    ",
      "    ║         — Master Roshi        ║    ",
      "    ╚═══════════════════════════════╝    ",
      "                                        ",
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find file",       "<cmd>Telescope find_files<cr>"),
      dashboard.button("r", "  Recent files",    "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("g", "  Find text",       "<cmd>Telescope live_grep<cr>"),
      dashboard.button("s", "  Restore session", '<cmd>lua require("persistence").load()<cr>'),
      dashboard.button("n", "  New file",        "<cmd>ene <BAR> startinsert<cr>"),
      dashboard.button("c", "  Config",          "<cmd>e $MYVIMRC<cr>"),
      dashboard.button("l", "󰒲  Lazy",            "<cmd>Lazy<cr>"),
      dashboard.button("m", "  Mason",           "<cmd>Mason<cr>"),
      dashboard.button("q", "  Quit",            "<cmd>qa<cr>"),
    }

    -- Footer: show loaded plugin count
    dashboard.section.footer.val = function()
      local stats = require("lazy").stats()
      return "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. string.format("%.1f", stats.startuptime) .. "ms"
    end

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- Highlight groups
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#f7768e", bold = true })
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#565f89", italic = true })
      end,
    })

    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.foldenable = false
      end,
    })
  end,
}
