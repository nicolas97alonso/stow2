-- 🗂️ File Explorer: nvim-tree
return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile" },
  keys = {
    { "<leader>s", function() require("nvim-tree.view").resize() end, desc = "Refit NvimTree width" },
  },
  opts = {
    view = {
      width = { min = 30 },      -- grow to fit content, never narrower than 30
      centralize_selection = true,
    },
    renderer = {
      highlight_git = "name",
      highlight_opened_files = "icon",
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
  },
}
