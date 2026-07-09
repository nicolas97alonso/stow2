return {
  -- 🔧 Git Integration: gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
          untracked    = { text = "▎" },
        },
      })
    end,
  },

  -- 🧭 Git: Fugitive
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gblame", "Glog" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Fugitive Git status" },
    },
  },
}

