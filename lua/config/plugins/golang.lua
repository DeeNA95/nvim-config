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
      
      -- Auto command to setup go.nvim on Go files
      local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require('go.format').goimport()
        end,
        group = format_sync_grp,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- Better Go syntax highlighting and text objects
  {
    "fatih/vim-go",
    ft = "go",
    config = function()
      -- Disable vim-go LSP features since we use gopls
      vim.g.go_gopls_enabled = 0
      vim.g.go_code_completion_enabled = 0
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_doc_keywordprg_enabled = 0
      
      -- Keep useful features
      vim.g.go_highlight_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_highlight_generate_tags = 1
      
      -- Test settings
      vim.g.go_test_show_name = 1
      vim.g.go_test_timeout = "10s"
      
      -- Format settings
      vim.g.go_fmt_autosave = 0  -- We handle this with LSP
      vim.g.go_imports_autosave = 0  -- We handle this with LSP
    end,
  },

  -- Go debugging support
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
    },
    ft = "go",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
      })
      
      -- Setup virtual text
      require("nvim-dap-virtual-text").setup()
      
      -- Setup Go DAP
      require("dap-go").setup()
      
      -- DAP keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle Breakpoint" }))
      vim.keymap.set("n", "<leader>dc", dap.continue, vim.tbl_extend("force", opts, { desc = "Continue" }))
      vim.keymap.set("n", "<leader>di", dap.step_into, vim.tbl_extend("force", opts, { desc = "Step Into" }))
      vim.keymap.set("n", "<leader>do", dap.step_over, vim.tbl_extend("force", opts, { desc = "Step Over" }))
      vim.keymap.set("n", "<leader>dO", dap.step_out, vim.tbl_extend("force", opts, { desc = "Step Out" }))
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, vim.tbl_extend("force", opts, { desc = "Toggle REPL" }))
      vim.keymap.set("n", "<leader>dl", dap.run_last, vim.tbl_extend("force", opts, { desc = "Run Last" }))
      vim.keymap.set("n", "<leader>du", dapui.toggle, vim.tbl_extend("force", opts, { desc = "Toggle DAP UI" }))
      vim.keymap.set("n", "<leader>dt", function() dap.terminate() end, vim.tbl_extend("force", opts, { desc = "Terminate" }))
      
      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

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
