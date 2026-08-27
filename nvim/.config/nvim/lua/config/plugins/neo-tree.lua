-- 🗂️ File Explorer: neo-tree
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
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
