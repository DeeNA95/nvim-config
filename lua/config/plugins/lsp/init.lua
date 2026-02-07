-- Core LSP configuration module
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup({
            ui = {
              border = "rounded",
              icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
              }
            }
          })
        end
      },
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("mason-lspconfig").setup({
            ensure_installed = {
              "pyright",  -- Python
              "clangd",   -- C/C++
              "gopls",    -- Go
            },
            automatic_installation = true,
          })
        end
      },
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = {
          window = {
            blend = 0,
          },
        },
      },
      "ray-x/lsp_signature.nvim",
      "nvimtools/none-ls.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = {
          prefix = '■',
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Setup LSP signature help
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "rounded",
        },
        floating_window = true,
        hint_enable = false,
        hint_prefix = "🔍 ",
      })

      -- Start LSP servers
      local on_attach = require("config.plugins.lsp.handlers").on_attach
      local capabilities = require("config.plugins.lsp.handlers").capabilities()

      -- Python setup
      vim.lsp.config('pyright', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
            },
          },
        },
      })
      vim.lsp.enable('pyright')

      -- C/C++ setup
      vim.lsp.config('clangd', {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--suggest-missing-includes",
          "--clang-tidy",
          "--header-insertion=iwyu",
        },
      })
      vim.lsp.enable('clangd')

      -- Go setup
      vim.lsp.config('gopls', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            matcher = "fuzzy",
            experimentalWorkspaceModule = true,
          },
        },
      })
      vim.lsp.enable('gopls')

      -- Configure none-ls for formatters and linters
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- Python
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          require("none-ls.diagnostics.flake8"),

          -- C/C++
          null_ls.builtins.formatting.clang_format,

          -- Go
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.golines.with({
            extra_args = { "--max-len=120" },
          }),
          null_ls.builtins.code_actions.gomodifytags,
          null_ls.builtins.code_actions.impl,
          null_ls.builtins.diagnostics.golangci_lint,
        },
        -- Enable format on save
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
              end,
            })
          end
        end,
      })
    end,
  },
}
