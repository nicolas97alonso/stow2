-- Keybinding: jk to escape
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true, desc = "Escape insert mode" })

-- nvim-tree keybinding
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle file explorer" })

-- Telescope keybindings
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true, desc = "Find files" })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true, desc = "Live grep" })
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true, desc = "Find buffers" })
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true, desc = "Help tags" })

-- Easier window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Go to right window" })


-- Increase tree width
vim.keymap.set("n", "<leader>+", ":vertical resize +5<CR>", { desc = "Increase tree width" })
-- Decrease tree width
vim.keymap.set("n", "<leader>-", ":vertical resize -5<CR>", { desc = "Decrease tree width" })

-- Remap ^ to _ for cleaner line navigation
vim.keymap.set("n", "^", "_", { noremap = true, silent = true, desc = "First non-blank char" })

-- Remap show diagnostic
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {desc = "Show diagnostic in floating window"})

