return {
  -- 🔧 Git Integration: gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      -- gitsigns ships no default mappings, so without this block everything
      -- except the sign column is unreachable. Buffer-local and bound only once
      -- gitsigns attaches, so none of it exists outside a repo.
      --
      -- Namespaced under <leader>g (which-key's "git" group) and NOT <leader>h --
      -- that whole prefix belongs to harpoon, and <leader>hd is already its
      -- "remove marked file".
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(mode, keys, fn, desc)
          vim.keymap.set(mode, keys, fn, { buffer = buf, desc = "Git: " .. desc })
        end

        -- ]h / [h rather than ]c / [c: ]c is the built-in diff-mode jump, and
        -- shadowing it would break navigating a real :Gdiffsplit.
        map("n", "]h", function()
          gs.nav_hunk("next")
        end, "Next hunk")
        map("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Prev hunk")

        map("n", "<leader>ga", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gA", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
        map("x", "<leader>ga", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selection")
        map("x", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selection")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
        map("n", "<leader>gd", gs.diffthis, "Diff against index")

        -- Works in operator-pending and visual, so `vih` / `dih` act on the hunk
        -- under the cursor.
        map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
      end,
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
