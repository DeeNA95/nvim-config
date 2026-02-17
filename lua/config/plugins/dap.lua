return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("nvim-dap-virtual-text").setup({
        commented = true, -- Show virtual text as comments
      })

      dapui.setup()

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Python configuration
      require("dap-python").setup("/usr/bin/python3") -- Path to python
      require("dap-python").test_runner = "pytest"

      -- Go configuration (via nvim-dap-go + delve)
      require("dap-go").setup()

      -- C/C++/CUDA configuration (via codelldb)
      -- Install with :MasonInstall codelldb
      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local codelldb_path = mason_path .. "/bin/codelldb"

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      -- Shared launch config for C, C++, and CUDA
      local codelldb_config = {
        {
          name = "Launch executable",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Attach to process",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.c = codelldb_config
      dap.configurations.cpp = codelldb_config
      dap.configurations.cuda = codelldb_config

      -- Bash configuration (via bash-debug-adapter)
      dap.adapters.bashdb = {
        type = "executable",
        command = mason_path .. "/bin/bash-debug-adapter",
        name = "bashdb",
      }

      dap.configurations.sh = {
        {
          name = "Launch Bash script",
          type = "bashdb",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pathBashdb = mason_path .. "/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
          pathBashdbLib = mason_path .. "/packages/bash-debug-adapter/extension/bashdb_dir",
          pathBash = "bash",
          pathCat = "cat",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          env = {},
          args = {},
        },
      }

      -- Keybindings
      vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Set Breakpoint Condition" })
      vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Debug: Open REPL" })
      vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Debug: Toggle UI" })
    end,
  },
}
