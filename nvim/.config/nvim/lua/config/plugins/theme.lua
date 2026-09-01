return {
  "neanias/everforest-nvim",
  version = false,
  priority = 1000,
  config = function()
    local c = require("config.palette")

    require("everforest").setup({
      -- "hard" is the darkest of the three, closest to the navy override below.
      background = "hard",
      -- 2 also drops the statusline/signcolumn backgrounds, which is what makes
      -- the terminal background show through everywhere.
      transparent_background_level = 2,
      -- Comments are italic by default (disable_italic_comments = false); this
      -- flag would also italicise keywords, which the reference does not.
      italics = false,
      sign_column_background = "none",
      ui_contrast = "low",
      float_style = "dim",
      -- Pull everforest onto palette.lua's values so the plugin and the
      -- statusline can't drift apart. Every bg/grey slot has to be listed:
      -- everforest's own backgrounds are warm forest grey and bg_visual is a
      -- maroon (#4c3743), which leak into Visual, Pmenu and WinSeparator if
      -- left alone.
      colours_override = function(p)
        p.bg_dim    = c.bg_dark
        p.bg0       = c.bg
        p.bg1       = c.surface
        p.bg2       = c.surface_hi
        p.bg3       = c.selection
        p.bg4       = c.selection
        p.bg5       = c.grey_dim
        p.bg_visual = c.selection
        p.grey0     = c.grey_dim
        p.grey1     = c.grey
        p.grey2     = c.grey_light
        p.fg        = c.fg
        p.red       = c.red
        p.orange    = c.orange
        p.yellow    = c.yellow
        p.green     = c.green
        p.aqua      = c.aqua
        p.blue      = c.blue
        p.purple    = c.violet
        p.statusline1 = c.green
        p.statusline2 = c.fg
        p.statusline3 = c.red
      end,
    })

    vim.cmd.colorscheme("everforest")

    -- Keep the gutter and floats transparent (everforest's transparent levels
    -- leave a few of these with a background).
    local function apply_hl()
      vim.api.nvim_set_hl(0, "SignColumn",   { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder",  { bg = "NONE" })
      -- Kill the gutter/line-number backgrounds left behind in transparent mode
      vim.api.nvim_set_hl(0, "LineNr",       { fg = c.grey_dim, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.orange, bg = "NONE", bold = true })
      -- Tabline: mini.tabline is not enabled, so these are the groups that
      -- actually render on :tabnew.
      vim.api.nvim_set_hl(0, "TabLine",     { fg = c.grey, bg = "NONE" })
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TabLineSel",  { fg = c.fg, bg = c.selection, bold = true })
      -- Cmdline (noice) fully transparent, green border to match the statusline
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup",       { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = c.green, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdlineIcon",        { fg = c.green, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdline",            { fg = c.fg, bg = "NONE" })
    end
    apply_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })
  end,
}
