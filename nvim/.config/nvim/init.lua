vim.cmd [[
  autocmd BufRead,BufNewFile Jenkinsfile* set filetype=groovy
]]

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap Lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim", lazypath})
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
