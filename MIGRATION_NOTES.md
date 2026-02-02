# Migration Notes: null-ls to none-ls

## 🔧 Issue Fixed

**Problem**: `null-ls.nvim` is deprecated and incompatible with newer Neovim versions, causing errors:
```
Error executing vim.schedule lua callback: ...lua/null-ls/client.lua:35: attempt to index field '_request_name_to_capability' (a nil value)
```

## ✅ Solution Applied

### 1. **Replaced Plugin**
- **Removed**: `jose-elias-alvarez/null-ls.nvim` (deprecated)
- **Added**: `nvimtools/none-ls.nvim` (actively maintained fork)

### 2. **Configuration Updated**
- Updated LSP configuration to use `none-ls.nvim`
- Removed duplicate `null-ls.lua` configuration file
- Maintained all existing formatters and linters

### 3. **Formatters & Linters Preserved**
All your existing tools continue to work:

#### Python
- **black**: Code formatting
- **isort**: Import sorting
- **flake8**: Linting

#### Go
- **goimports**: Import management
- **golines**: Line length formatting (120 chars)
- **gomodifytags**: Struct tag modification
- **impl**: Interface implementation
- **golangci-lint**: Comprehensive linting

#### C/C++
- **clang-format**: Code formatting

#### R
- **styler**: Code formatting

## 🚀 Benefits

1. **Compatibility**: Works with latest Neovim versions
2. **Maintenance**: Actively maintained and updated
3. **Stability**: No more deprecation errors
4. **Future-proof**: Will continue to receive updates

## ⚠️ No Action Required

- All keybindings remain the same
- Format-on-save still works
- All language support preserved
- Zero configuration changes needed

## 📋 What Changed Under the Hood

- Plugin dependency: `jose-elias-alvarez/null-ls.nvim` → `nvimtools/none-ls.nvim`
- Removed duplicate configuration file
- API remains identical (100% backward compatible)

Your development environment continues to work exactly as before, but now with better stability and future support! 🎉
