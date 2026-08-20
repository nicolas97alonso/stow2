  -- 🎯 Navigation Booster: Harpoon 2
return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon mark file" },
      { "<leader>hm", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end, desc = "Harpoon menu" },
      { "<leader>hd", function() require("harpoon"):list():remove() end, desc = "Harpoon remove marked file" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
    },
    config = function(_, opts)
      require("harpoon"):setup(opts)
    end,
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    },
  }
