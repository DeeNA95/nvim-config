-- Global settings that need to be set early
vim.g.mapleader = " "       -- Set leader key
vim.g.maplocalleader = ","  -- Set local leader key

-- Load configuration modules
require "config.options"    -- General Neovim options
require "custom.remap"      -- Key mappings
require "config.lazy"       -- Plugin manager setup

-- Load autocommands
require("config.autocmds").setup()

-- Basic settings (some duplicated in options.lua but important to have here)
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
