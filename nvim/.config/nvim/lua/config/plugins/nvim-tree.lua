-- 🗂️ File Explorer: nvim-tree
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      view = {
        adaptive_size = true,      -- Auto adjust width based on content
        centralize_selection = true,
      },
      actions = {
        open_file = {
          resize_window = true,    -- Auto resize when opening files
        },
      },
      renderer = {
        highlight_git = true,
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
    })

    -- 🔧 Keybinding: auto adjust width manually
    vim.keymap.set("n", "<leader>s", function()
      local view = require("nvim-tree.view")
      view.resize(view.View.width)
    end, { desc = "Auto adjust NvimTree width" })
  end,
}
