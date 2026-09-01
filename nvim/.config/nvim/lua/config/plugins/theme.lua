return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    local c = require("config.palette")

    require("onedark").setup({
      -- "deep" is the navy-leaning variant, closest to the reference before the
      -- background override below.
      style = "deep",
      transparent = true,
      term_colors = false, -- the terminal owns its own palette; don't fight it
      code_style = { comments = "italic" },
      -- Pull onedark onto palette.lua's values so the plugin and the statusline
      -- can't drift apart.
      colors = {
        black = c.bg,
        bg0 = c.bg,
        bg1 = c.surface,
        fg = c.fg,
        grey = c.grey,
        purple = c.violet,
        blue = c.blue,
        cyan = c.aqua,
        green = c.green,
        yellow = c.yellow,
        orange = c.orange,
        red = c.red,
      },
    })

    vim.cmd.colorscheme("onedark")

    -- Keep the gutter and floats transparent (onedark's transparent mode leaves
    -- a few of these with a background).
    local function apply_hl()
      vim.api.nvim_set_hl(0, "SignColumn",   { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder",  { bg = "NONE" })
      -- Kill the gutter/line-number backgrounds left behind in transparent mode
      vim.api.nvim_set_hl(0, "LineNr",       { fg = c.grey_dim, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.orange, bg = "NONE", bold = true })
      -- Cmdline (noice) fully transparent
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup",       { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = c.blue, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdline",            { bg = "NONE" })
    end
    apply_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })
  end,
}
