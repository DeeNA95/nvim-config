-- In lua/config/plugins/ui.lua
return {
  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    priority = 1000,
    config = function()
      require("nvim-web-devicons").setup({
        strict = true,
        override_by_extension = {
          ["lua"] = {
            icon = "",
            color = "#51a0cf",
            name = "Lua",
          },
        },
        override_by_filename = {
          ["README.md"] = {
            icon = "",
            color = "#42a5f5",
            name = "README",
          },
        },
      })
    end,
  },

  -- Better UI for selections, popups, and more
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        default_prompt = "➤ ",
        title_pos = "left",
        border = "rounded",
      },
      select = {
        enabled = true,
        backend = { "telescope", "fzf", "builtin" },
        border = "rounded",
        winblend = 10,
      },
    },
  },

  -- Custom window separators and background
  {
    'nvim-zh/colorful-winsep.nvim',
    config = function()
      require('colorful-winsep').setup({
        thickness = 2,
        separator_color = '#303030',
        no_exec_files = {},
        highlight = {
          bg = '#000000',
          fg = '#303030',
        },
      })
      -- Set up dark theme colors (Respecting transparency)
      vim.cmd([[
        " highlight Normal guibg=#000000 guifg=#d0d0d0
        " highlight NormalFloat guibg=#000000
        highlight LineNr guifg=#404040
        highlight CursorLineNr guifg=#606060
        " highlight SignColumn guibg=#000000
        highlight VertSplit guifg=#303030
        highlight StatusLine guibg=#202020
        highlight StatusLineNC guibg=#181818
        highlight Pmenu guibg=#202020
        highlight PmenuSel guibg=#303030
        highlight FloatBorder guifg=#303030
        highlight NonText guifg=#303030
        highlight SpecialKey guifg=#303030
        highlight Folded guibg=#181818 guifg=#505050
        highlight Visual guibg=#303030
        highlight Search guibg=#404040
        highlight IncSearch guibg=#505050
        highlight Comment guifg=#505050
      ]])
    end,
    event = { 'VimEnter', 'WinNew' },
  },

  -- Pretty notifications with dark theme
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        background_colour = "#000000",
        stages = "fade_in_slide_out",
        timeout = 3000,
        max_width = 80,
        icons = {
          ERROR = "✘",
          WARN = "⚠",
          INFO = "ℹ",
          DEBUG = "⬤",
          TRACE = "✎",
        },
        highlights = {
          NotifyERRORBorder = { guifg = "#303030" },
          NotifyWARNBorder = { guifg = "#303030" },
          NotifyINFOBorder = { guifg = "#303030" },
          NotifyDEBUGBorder = { guifg = "#303030" },
          NotifyTRACEBorder = { guifg = "#303030" },
          NotifyERRORBody = { guibg = "#000000", guifg = "#d0d0d0" },
          NotifyWARNBody = { guibg = "#000000", guifg = "#d0d0d0" },
          NotifyINFOBody = { guibg = "#000000", guifg = "#d0d0d0" },
          NotifyDEBUGBody = { guibg = "#000000", guifg = "#d0d0d0" },
          NotifyTRACEBody = { guibg = "#000000", guifg = "#d0d0d0" },
        }
      })
      vim.notify = notify
    end,
  },

  -- Fancy start screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", function()
          require('telescope.builtin').find_files()
        end),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recently used files", function()
          require('telescope.builtin').oldfiles()
        end),
        dashboard.button("t", "  Find text", function()
          require('telescope.builtin').live_grep()
        end),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }
      dashboard.section.footer.opts = dashboard.section.footer.opts or {}
      dashboard.section.footer.opts.hl = "AlphaDashboardFooter"

      -- Create a highlight group with larger font (if your terminal/GUI supports it)
      -- Note: Terminal Neovim cannot change font size, but we can add padding/styling
      vim.api.nvim_set_hl(0, "AlphaDashboardFooter", { bold = true, italic = true })

      -- Add padding to make it more prominent
      dashboard.section.footer.opts.position = "center"

      dashboard.section.footer.val = "WORK HARD, STUDY WELL, EAT & SLEEP PLENTY. \nTHAT'S THE TURTLE HERMIT WAY"
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"

      dashboard.opts.opts.noautocmd = true
      return dashboard
    end,
    config = function(_, dashboard)
      require("alpha").setup(dashboard.opts)
    end,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "BufReadPost",
    config = function()
      require("neoscroll").setup({
        easing_function = "quadratic",
        hide_cursor = true,
      })
    end,
  },
	-- In lua/config/plugins/ui.lua (add to the return table)
  -- Buffer tabs with numbering and close buttons
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "buffers",
        numbers = "ordinal",
        close_command = "bdelete! %d",
        indicator = {
          icon = "▎",
          style = "icon",
        },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        separator_style = "thin",
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        color_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          if not diag then return '' end
          local icons = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " ",
          }
          local ret = {}
          for name, count in pairs(diag) do
            if count and count > 0 and icons[name] then
              table.insert(ret, icons[name] .. count)
            end
          end
          return table.concat(ret, " ")
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          }
        },
      },
    },
  },
-- In lua/config/plugins/ui.lua (add to the return table)
  -- Indentation guides in gray
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
        highlight = "NonText",
      },
      scope = {
        enabled = true,
        show_start = false,
        highlight = { "NonText" },
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
-- In lua/config/plugins/ui.lua (add to the return table)
  -- Enhanced diagnostics and code actions UI
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },
    },
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = { "<cr>", "<tab>" },
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        close_folds = { "zM", "zm" },
        open_folds = { "zR", "zr" },
        toggle_fold = { "zA", "za" },
        previous = "k",
        next = "j",
      },
      win = {
        border = "rounded",
      },
    },
  },

  -- UI for code actions and other inputs
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
      cmdline = {
        view = "cmdline",
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
    },
  },
-- In lua/config/plugins/ui.lua (add to the return table)
  -- Floating terminal with dark theme
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<leader>gs", "<cmd>TermExec cmd='watch -n 1 nvidia-smi' direction=float<cr>", desc = "GPU Status" },
    },
    opts = {
      size = 20,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "NonText",
          background = "Normal",
        },
      },
    },
  },
-- In lua/config/plugins/ui.lua (add to the return table)
  -- Rainbow delimiters for easier bracket matching
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Code context at the top of the buffer
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
    opts = {
      mode = "cursor",
      max_lines = 3,
    },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },

  -- Dim inactive portions of code
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    opts = {
      dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
        term_bg = "#000000",
        inactive = false,
      },
      context = 10,
      treesitter = true,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {},
    },
  },

  -- Auto-closing for brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },

  -- Image support for viewing plots (requires luarocks and magick)
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      backend = "kitty", -- WezTerm supports Kitty image protocol
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki", "quarto" },
        },
      },
      max_width = 100,
      max_height = 12,
      max_width_window_percentage = 50,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

}

