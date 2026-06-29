return {
  "echasnovski/mini.nvim", -- We use the main repo to ensure it downloads correctly
  version = false,
  event = { "BufReadPre", "BufNewFile" }, -- 🟢 FIXED: Standard events instead of 'LazyFile'
  config = function()
    -- 🎨 Colorful file/folder icons (replaces nvim-web-devicons everywhere)
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
    
    -- Disable it on files where it looks ugly (like the dashboard or help menus)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify" },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
