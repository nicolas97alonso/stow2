return {
  "echasnovski/mini.nvim", -- We use the main repo to ensure it downloads correctly
  version = false,
  lazy = false, -- load early so mini.icons can mock devicons before lualine/neo-tree
  priority = 900, -- after the colorscheme (1000), before everything else
  config = function()
    -- 🎨 Colorful file/folder icons (replaces nvim-web-devicons everywhere).
    -- Must mock BEFORE lualine/neo-tree require the real nvim-web-devicons.
    require("mini.icons").setup({
      style = "glyph",
    })
    require("mini.icons").mock_nvim_web_devicons()

    -- ➕ Auto-close brackets and quotes. There was no pairing capability at all
    -- before this. Defaults on purpose: they already skip pairing after a
    -- backslash, already exclude quotes from <CR> handling, and `'` already uses
    -- `^[^%a\\]` so an apostrophe after a letter doesn't insert a stray closer.
    -- It also doesn't fight blink's <CR> = accept, since blink only consumes <CR>
    -- while the completion menu is open.
    require("mini.pairs").setup()

    -- 🔗 Surround: sa (add), sd (delete), sr (replace), sf/sF (find), sh
    -- (highlight). Nothing in this config provided surround before.
    -- This does take the `s` prefix, so plain `s` (substitute char) is gone --
    -- `cl` is the identical built-in, which is why the default prefix is
    -- generally accepted rather than remapped.
    require("mini.surround").setup()

    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
      draw = {
        delay = 0,
        -- 🟢 ANIMATION: This creates the sliding/extending effect
        animation = require("mini.indentscope").gen_animation.quadratic({
          easing = "out",
          duration = 500,
          unit = "total",
        }),
      },
    })

    -- Disable it on files where it looks ugly (help menus, plugin UIs)
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("miniindentscope_disable", { clear = true }),
      pattern = { "help", "lazy", "mason", "notify", "neo-tree", "TelescopePrompt", "noice" },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
