return {
  "nvim-telescope/telescope.nvim", -- Main plugin
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required dependency for Telescope
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Necessary for fzf-native
  },
  cmd = "Telescope",
  keys = { -- Enhanced keymaps
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<leader>fF", function() require("telescope.builtin").find_files({ no_ignore = true, hidden = true }) end, desc = "Find all files" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
    { "<leader>fG", function() require("telescope.builtin").live_grep({ additional_args = { "--hidden" } }) end, desc = "Live Grep (hidden)" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "List Buffers" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent Files" },
    { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Find Word" },
    { "<leader>fc", function() require("telescope.builtin").commands() end, desc = "Commands" },
    { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
    { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document Symbols" },
    { "<leader>fS", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "Workspace Symbols" },
    { "<leader>/", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Search in buffer" },
    },
  config = function()
    -- Load Telescope configuration and extensions
    require("telescope").setup({
      defaults = {
        -- Default configuration for Telescope
        prompt_prefix = " ",
        selection_caret = " ",
        layout_config = {
          horizontal = {
            preview_width = 0.6,
          },
        },
        search_dirs = { "~/projects", "~/notes" }, -- Adjust as needed
      },
      pickers = {
        -- Custom configuration for builtin pickers
        find_files = {
          theme = "dropdown",
        },
      },
      extensions = {
        -- Extensions configuration
        fzf = {
          fuzzy = true, -- Enable fuzzy searching
          override_generic_sorter = true, -- Overrides the generic sorter
          override_file_sorter = true, -- Overrides the file sorter
          case_mode = "smart_case",
        },
      },
    })

    -- Load the fzf-native extension, if available
    require("telescope").load_extension("fzf")
  end,
}

