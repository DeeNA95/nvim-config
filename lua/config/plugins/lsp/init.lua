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
              "neocmake",  -- CMake
              "dockerls",  -- Dockerfile
              "docker_compose_language_service",  -- Docker Compose
              "bashls",   -- Shell/Bash
              "lua_ls",   -- Lua
              "yamlls",   -- YAML
              "jsonls",   -- JSON
              "taplo",    -- TOML
            },
            automatic_installation = true,
          })
        end
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
          require("mason-tool-installer").setup({
            ensure_installed = {
              -- Formatters
              "black",
              "isort",
              "clang-format",
              "goimports",
              "golines",
              "cmakelang",      -- cmake-format + cmake-lint
              "shfmt",          -- Shell
              "stylua",         -- Lua
              "yamlfmt",        -- YAML
              "prettier",       -- JSON, Markdown, YAML fallback

              -- Linters
              "flake8",
              "golangci-lint",
              "checkmake",
              "hadolint",
              "markdownlint",
              "shellcheck",     -- Shell/Bash

              -- Debuggers
              "codelldb",       -- C/C++/CUDA
              "delve",          -- Go
              "debugpy",        -- Python
              "bash-debug-adapter", -- Bash
            },
            auto_update = false,
            run_on_start = true,
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
      "b0o/schemastore.nvim",  -- JSON/YAML schemas
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

      -- CMake setup
      vim.lsp.config('neocmake', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('neocmake')

      -- Dockerfile setup
      vim.lsp.config('dockerls', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('dockerls')

      -- Docker Compose setup
      vim.lsp.config('docker_compose_language_service', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('docker_compose_language_service')

      -- Bash/Shell setup
      vim.lsp.config('bashls', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('bashls')

      -- Lua setup (Neovim-aware)
      vim.lsp.config('lua_ls', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable('lua_ls')

      -- YAML setup
      vim.lsp.config('yamlls', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
            },
            validate = true,
            completion = true,
          },
        },
      })
      vim.lsp.enable('yamlls')

      -- JSON setup
      vim.lsp.config('jsonls', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore") and require("schemastore").json.schemas() or {},
            validate = { enable = true },
          },
        },
      })
      vim.lsp.enable('jsonls')

      -- TOML setup
      vim.lsp.config('taplo', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('taplo')
    end,
  },
}
