  -- 🔍 Fuzzy Finder: Telescope
return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-v>"] = require("telescope.actions").select_vertical,
              ["<C-x>"] = require("telescope.actions").select_horizontal,
              ["<C-t>"] = require("telescope.actions").select_tab,
            },
            n = {
              ["<C-v>"] = require("telescope.actions").select_vertical,
              ["<C-x>"] = require("telescope.actions").select_horizontal,
              ["<C-t>"] = require("telescope.actions").select_tab,
            },
          },
        },
      })
    end,
  }