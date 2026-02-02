-- Autocommands for language-specific settings
local function setup_autocmds()
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup
  
  -- Python specific settings
  local python_group = augroup("PythonSettings", { clear = true })
  autocmd("FileType", {
    group = python_group,
    pattern = "python",
    callback = function()
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.expandtab = true
      vim.opt_local.colorcolumn = "88"  -- Black's default line length
    end,
  })
  
  -- C++ specific settings
  local cpp_group = augroup("CppSettings", { clear = true })
  autocmd("FileType", {
    group = cpp_group,
    pattern = {"cpp", "c"},
    callback = function()
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
      vim.opt_local.expandtab = true
      vim.opt_local.colorcolumn = "80"
    end,
  })
  
  -- R specific settings
  local r_group = augroup("RSettings", { clear = true })
  autocmd("FileType", {
    group = r_group,
    pattern = "r",
    callback = function()
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
      vim.opt_local.expandtab = true
    end,
  })
  
  -- Go specific settings
  local go_group = augroup("GoSettings", { clear = true })
  autocmd("FileType", {
    group = go_group,
    pattern = "go",
    callback = function()
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.expandtab = false  -- Go uses tabs
      vim.opt_local.colorcolumn = "120"
      
      -- Go-specific key mappings
      local opts = { noremap = true, silent = true, buffer = true }
      vim.keymap.set('n', '<leader>gr', ':GoRun<CR>', vim.tbl_extend('force', opts, { desc = 'Go Run' }))
      vim.keymap.set('n', '<leader>gt', ':GoTest<CR>', vim.tbl_extend('force', opts, { desc = 'Go Test' }))
      vim.keymap.set('n', '<leader>gb', ':GoBuild<CR>', vim.tbl_extend('force', opts, { desc = 'Go Build' }))
      vim.keymap.set('n', '<leader>gc', ':GoCoverage<CR>', vim.tbl_extend('force', opts, { desc = 'Go Coverage' }))
      vim.keymap.set('n', '<leader>gi', ':GoImports<CR>', vim.tbl_extend('force', opts, { desc = 'Go Imports' }))
    end,
  })
  
  -- Auto-format and organize imports on save for Go files
  autocmd("BufWritePre", {
    group = go_group,
    pattern = "*.go",
    callback = function()
      -- Organize imports
      local params = vim.lsp.util.make_range_params()
      params.context = { only = { "source.organizeImports" } }
      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
          end
        end
      end
      
      -- Format the file
      vim.lsp.buf.format({ timeout_ms = 3000 })
    end,
  })
end

return { setup = setup_autocmds }

