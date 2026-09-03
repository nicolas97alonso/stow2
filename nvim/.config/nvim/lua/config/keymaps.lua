-- Only global, plugin-independent maps live here. Plugin keys are declared in
-- the plugin's own spec (`keys = { ... }`) so they lazy-load with it.

-- Keybinding: jk to escape
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Escape insert mode" })

-- Easier window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Go to right window" })

-- Resize the focused window (works on the tree when the tree has focus)
vim.keymap.set(
  "n",
  "<leader>+",
  ":vertical resize +5<CR>",
  { noremap = true, silent = true, desc = "Widen focused window" }
)
vim.keymap.set(
  "n",
  "<leader>-",
  ":vertical resize -5<CR>",
  { noremap = true, silent = true, desc = "Narrow focused window" }
)

-- Remap show diagnostic
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic in floating window" })
