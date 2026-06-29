return {
  -- 🔧 Git Integration: gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- 🧭 Git: Fugitive
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Fugitive Git status", noremap = true, silent = true })
    end,
  },
}

