return {
  "echasnovski/mini.nvim", -- We use the main repo to ensure it downloads correctly
  version = false,
  lazy = false,      -- load early so mini.icons can mock devicons before lualine/nvim-tree
  priority = 900,    -- after the colorscheme (1000), before everything else
  config = function()
    -- 🎨 Colorful file/folder icons (replaces nvim-web-devicons everywhere).
    -- Must mock BEFORE lualine/nvim-tree require the real nvim-web-devicons.
    require("mini.icons").setup({
      style = "glyph",
    })
    require("mini.icons").mock_nvim_web_devicons()

    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
      draw = {
        delay = 0,
        -- 🟢 ANIMATION: This creates the sliding/extending effect
        animation = require("mini.indentscope").gen_animation.quadratic({ easing = 'out', duration = 500, unit = 'total' }),
      },
    })
    
    -- Disable it on files where it looks ugly (help menus, plugin UIs)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "help", "lazy", "mason", "notify" },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
