-- Keybinding: jk to escape
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- nvim-tree keybinding
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Telescope keybindings
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true })

-- Easier window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })


-- Increase tree width
vim.keymap.set("n", "<leader>+", ":vertical resize +5<CR>", { desc = "Increase tree width" })
-- Decrease tree width
vim.keymap.set("n", "<leader>-", ":vertical resize -5<CR>", { desc = "Decrease tree width" })

-- Remap ^ to _ for cleaner line navigation
vim.keymap.set("n", "^", "_", { noremap = true, silent = true})

-- Remap show diagnostic
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {desc = "Show diagnostic in floating window"})

