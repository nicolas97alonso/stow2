-- 💫 Animated smear/trail when the cursor jumps.
return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  config = function()
    local c = require("config.palette")

    require("smear_cursor").setup({
      -- The plugin's default is Neovim's `Cursor` highlight, but Ghostty
      -- overrides the cursor color itself (`cursor-color = dcd7ba`), so the
      -- smear would not match the block it trails from. Keep this equal to
      -- Ghostty's `cursor-color`.
      cursor_color = c.fg,
      -- `legacy_computing_symbols_support` is left at its default false, but NOT
      -- for the font reason that used to be claimed here. Ghostty draws the
      -- whole U+1FB00 block from its own internal sprites, independent of the
      -- font: all 60 distinct legacy-computing codepoints in the plugin's
      -- draw.lua resolve (checked with `ghostty +show-face --cp=`), so turning
      -- it on would render a finer smear, not tofu. It stays off only because
      -- it has not been tried.
      filetypes_disabled = { "neo-tree", "lazy", "mason", "TelescopePrompt" },
    })
  end,
}
