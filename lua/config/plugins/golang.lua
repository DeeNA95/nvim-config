-- Go-specific plugins and configuration
return {
  -- Go development plugin with comprehensive features
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        -- Disable default keymaps as we set our own
        disable_defaults = false,

        -- Go imports on save
        goimport = "gopls", -- Use gopls for imports
        gofmt = "golines",  -- Use golines for max_line_len to work

        -- Code formatting
        max_line_len = 120, -- This now works with golines
        tag_transform = false,
        test_dir = "",
        comment_placeholder = "   ",

        -- LSP settings
        lsp_cfg = false, -- We configure LSP separately
        lsp_gofumpt = true,
        lsp_on_attach = false, -- We have our own on_attach

        -- DAP (Debug Adapter Protocol) settings
        dap_debug = true,
        dap_debug_keymap = true,
        dap_debug_gui = true,
        dap_debug_vt = true,

        -- Test settings
        test_runner = "go", -- Use go test
        run_in_floaterm = false,

        -- Trouble integration
        trouble = true,

        -- Icons
        icons = {
          breakpoint = "🟥",
          currentpos = "🟢",
        },

        -- Verbose output
        verbose = false,
      })
      -- Auto format handled by conform.nvim (see plugins/formatting.lua)
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- Syntax highlighting handled by treesitter (go parser)
  -- DAP debugging handled by plugins/dap.lua

  -- Go testing framework
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
    },
    ft = "go",
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s" }
          }),
        },
        discovery = {
          enabled = false,
        },
      })

      -- Test keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end, vim.tbl_extend("force", opts, { desc = "Test Nearest" }))
      vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, vim.tbl_extend("force", opts, { desc = "Test File" }))
      vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, vim.tbl_extend("force", opts, { desc = "Test Summary" }))
      vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, vim.tbl_extend("force", opts, { desc = "Test Output" }))
    end,
  },
}
