-- Core LSP configuration module
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            border = "rounded",
            icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
          },
        },
      },
      "williamboman/mason-lspconfig.nvim",
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          ensure_installed = {
            "black", "isort", "clang-format", "goimports", "golines", "cmakelang", "shfmt", "stylua", "yamlfmt", "prettier",
            "flake8", "golangci-lint", "checkmake", "hadolint", "markdownlint", "shellcheck",
            "codelldb", "delve", "debugpy", "bash-debug-adapter",
          },
          auto_update = false,
          run_on_start = true,
        },
      },
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = { window = { blend = 0 } },
      },
      "ray-x/lsp_signature.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = { prefix = "■" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "always" },
      })

      -- Setup LSP signature help
      require("lsp_signature").setup({
        bind = true,
        handler_opts = { border = "rounded" },
        floating_window = true,
        hint_enable = false,
        hint_prefix = "🔍 ",
      })

      local handlers = require("config.plugins.lsp.handlers")
      local default_on_attach = handlers.on_attach
      local default_capabilities = handlers.capabilities()

      -- Define all LSP servers and their specific configurations
      local servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "standard",
              },
            },
          },
        },
        clangd = {
          -- Custom on_attach to disable formatting in favor of clang-format
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            default_on_attach(client, bufnr)
          end,
          cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu",
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true, shadow = true },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
              matcher = "fuzzy",
              experimentalWorkspaceModule = true,
            },
          },
        },
        lua_ls = {
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
        },
        yamlls = {
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
        },
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        -- Servers with no specific config
        neocmake = {},
        dockerls = {},
        docker_compose_language_service = {},
        bashls = {},
        taplo = {},
      }

      -- Setup mason-lspconfig with automatic handler mapping
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          -- Default handler maps the configuration from `servers` above using `lspconfig`
          function(server_name)
            local server_opts = servers[server_name] or {}
            -- Inject default configuration on top of any custom settings
            server_opts.on_attach = server_opts.on_attach or default_on_attach
            server_opts.capabilities = vim.tbl_deep_extend("force", default_capabilities, server_opts.capabilities or {})

            require("lspconfig")[server_name].setup(server_opts)
          end,
        },
      })
    end,
  },
}
