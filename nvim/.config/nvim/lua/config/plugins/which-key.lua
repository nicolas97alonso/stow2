-- ⌨️ which-key: popup showing available keybindings
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "harpoon" },
      { "<leader>c", group = "code" },
      { "<leader>r", group = "rename" },
    },
  },
}
