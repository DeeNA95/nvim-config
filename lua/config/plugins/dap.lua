return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
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
