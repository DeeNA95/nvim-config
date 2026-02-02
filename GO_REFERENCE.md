# Go Development in Neovim - Quick Reference

## 🚀 Go Language Support Added

Your Neovim setup now includes comprehensive Go language support with LSP, debugging, testing, and advanced tooling.

## 📦 Plugins Installed

- **gopls**: Go Language Server for intelligent code completion, navigation, and analysis
- **go.nvim**: Comprehensive Go development tools
- **vim-go**: Enhanced Go syntax highlighting and text objects
- **nvim-dap**: Debug Adapter Protocol for Go debugging
- **neotest-go**: Advanced testing framework integration

## ⌨️ Key Bindings

### LSP Features (Available in Go files)
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>f` - Format code
- `]d` / `[d` - Next/previous diagnostic

### Go-Specific Commands (Available in Go files)
- `<leader>gr` - Go run current file
- `<leader>gt` - Go test current file/package
- `<leader>gb` - Go build
- `<leader>gc` - Go coverage
- `<leader>gi` - Organize imports

### Testing (with neotest)
- `<leader>tn` - Test nearest function
- `<leader>tf` - Test current file
- `<leader>ts` - Toggle test summary
- `<leader>to` - Show test output

### Debugging (DAP)
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dr` - Toggle REPL
- `<leader>du` - Toggle debug UI
- `<leader>dt` - Terminate debug session

### File Navigation
- `<leader>ff` - Find Go files
- `<leader>fs` - Find symbols in current file
- `<leader>fS` - Find symbols in workspace

## 🔧 Automatic Features

### On Save (for Go files):
- **Format code** with gofumpt
- **Organize imports** automatically
- **Run goimports** to fix import statements

### LSP Features:
- **Real-time diagnostics** and error checking
- **Intelligent code completion** with gopls
- **Symbol navigation** and workspace analysis
- **Inline documentation** and signatures

### Code Analysis:
- **golangci-lint** integration for comprehensive linting
- **Unused parameter detection**
- **Shadow variable analysis**
- **Static analysis** with staticcheck

## 🎯 Go-Specific Settings

### Indentation:
- Uses **tabs** (Go standard)
- Tab width: 4 spaces
- Column guide at 120 characters

### Tools Integration:
- **golines**: Go formatter with line length control (120 chars)
- **goimports**: Import management
- **gomodifytags**: Struct tag modification
- **impl**: Interface implementation generator

## 🧪 Testing Features

### Test Discovery:
- Automatically detects Go tests
- Supports table-driven tests
- Timeout: 60 seconds per test

### Test Navigation:
- Run individual test functions
- Run all tests in a file
- View test coverage
- Interactive test results

## 🐛 Debugging Features

### Delve Integration:
- Full Go debugging support with delve
- Visual breakpoints and step debugging
- Variable inspection and watches
- REPL access during debugging

### Debug UI:
- **Scopes panel**: View variables and their values
- **Breakpoints panel**: Manage all breakpoints
- **Stack trace**: Navigate call stack
- **Watches**: Monitor specific variables

## 🚀 Quick Start

1. **Open a Go file**: The LSP will automatically start
2. **Install Go tools**: Run `:GoInstallBinaries` for additional tools
3. **Start coding**: Use `gd` to navigate, `K` for docs
4. **Run tests**: Use `<leader>tn` to test nearest function
5. **Debug**: Set breakpoint with `<leader>db`, then `<leader>dc`

## 📋 Requirements

Make sure you have these installed:
```bash
# Core Go installation
brew install go  # or download from golang.org

# Essential Go tools
go install golang.org/x/tools/gopls@latest           # Language server
go install github.com/go-delve/delve/cmd/dlv@latest  # Debugger
go install github.com/segmentio/golines@latest       # Line length formatter
go install golang.org/x/tools/cmd/goimports@latest   # Import organizer

# Linting and code quality
brew install golangci-lint  # Comprehensive linter

# Additional tools (optional)
go install github.com/fatih/gomodifytags@latest      # Struct tags
go install github.com/josharian/impl@latest          # Interface implementation
```

## 🔍 Troubleshooting

If you encounter issues:
1. Run `:checkhealth` to verify setup
2. Check Go installation with `:GoEnv`
3. Update tools with `:GoUpdateBinaries`
4. Restart LSP with `:LspRestart`

---

Happy Go coding! 🐹
