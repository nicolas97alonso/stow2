vim.filetype.add({ pattern = { ["Jenkinsfile.*"] = "groovy" } })

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap Lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim", lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
        }, true, {})
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugin specs from lua/plugins/
require("lazy").setup({{
    import = "config.plugins"
}})

require("config.keymaps")

-- Basic Functions
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Sensible defaults
vim.opt.signcolumn = "yes"        -- always show gutter so it doesn't jump on diagnostics
vim.opt.ignorecase = true
vim.opt.smartcase = true          -- case-sensitive only when search has uppercase
vim.opt.scrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250          -- faster CursorHold / diagnostics
vim.opt.undofile = true           -- persistent undo across sessions
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.timeoutlen = 400          -- snappier which-key popup
