  -- 🔍 Fuzzy Finder: Telescope
return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          path_display = { "smart" },
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
            horizontal = { preview_width = 0.45 },
          },
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          mappings = {
            i = {
              ["<C-v>"] = actions.select_vertical,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-t>"] = actions.select_tab,
            },
            n = {
              ["<C-v>"] = actions.select_vertical,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-t>"] = actions.select_tab,
            },
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  }
