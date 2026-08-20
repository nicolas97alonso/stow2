return {
  -- 🔧 Git Integration: gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
    },
  },

  -- 🧭 Git: Fugitive
  {
    "tpope/vim-fugitive",
    -- Gblame/Glog are legacy names that no longer exist; use :Git blame and :Gclog.
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gclog", "GcLog" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Fugitive Git status" },
    },
  },
}

