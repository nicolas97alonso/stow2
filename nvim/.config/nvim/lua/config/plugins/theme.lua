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
      -- can't drift apart. Every bg/grey slot has to be listed: the "deep" style's
      -- own backgrounds are purple-indigo (bg3 #2a324a, bg2 #283347) and leak into
      -- Visual, StatusLine, MatchParen and WinSeparator if left alone.
      colors = {
        black = c.bg_dark,
        bg0 = c.bg,
        bg1 = c.surface,
        bg2 = c.surface_hi,
        bg3 = c.selection,
        bg_d = c.bg_dark,
        bg_blue = c.blue,     -- PmenuSel; the style's #54b0fd is off-palette
        bg_yellow = c.yellow, -- Search; the style's #f2cc81 is off-palette
        fg = c.fg,
        grey = c.grey,
        light_grey = c.grey_light,
        purple = c.violet,
        blue = c.blue,
        cyan = c.aqua,
        green = c.green,
        yellow = c.yellow,
        orange = c.orange,
        red = c.red,
      },
      diagnostics = {
        -- darker = true muddies the fg down to dark_red #992525, which is
        -- unreadable on a navy background; background = true adds an off-hue block.
        darker = false,
        undercurl = true,
        background = false,
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
      -- Tabline: onedark ships TabLineSel as a near-solid white block, which
      -- reads as a hole against the transparent background. mini.tabline is not
      -- enabled, so these are the groups that actually render on :tabnew.
      vim.api.nvim_set_hl(0, "TabLine",     { fg = c.grey, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TabLineSel",  { fg = c.fg, bg = c.selection, bold = true })
      -- Cmdline (noice) fully transparent
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup",       { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = c.blue, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdline",            { bg = "NONE" })
    end
    apply_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })
  end,
}
