-- 🗂️ File Explorer: neo-tree
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  -- lazy = false because `nvim <dir>` has to hijack netrw before a buffer exists.
  -- Consequence: lazy's `keys` handler would never fire, so <leader>e is a plain
  -- keymap set below rather than a lazy trigger.
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  init = function()
    vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
  end,
  opts = {
    filesystem = {
      hijack_netrw_behavior = "open_current",
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
    window = {
      width = 30,
    },
  },
}
