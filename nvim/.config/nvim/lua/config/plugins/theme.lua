return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    local c = require("config.palette")

    require("kanagawa").setup({
      -- Wave, not Dragon/Lotus: it is the variant palette.lua is retuned from,
      -- and its role mapping (syn.string = springGreen, ...) is what turns the
      -- retuned names below into highlight groups.
      theme = "wave",
      background = { dark = "wave", light = "wave" },
      transparent = true,
      terminalColors = true,
      -- Matching the previous colorscheme: comments italic, nothing else.
      -- kanagawa's own defaults italicize keywords and bold statements too.
      commentStyle = { italic = true },
      keywordStyle = {},
      statementStyle = {},
      functionStyle = {},
      typeStyle = {},
      -- The retuned palette, merged over kanagawa's own before the theme is
      -- built (lua/kanagawa/colors.lua: vim.tbl_extend over `palette`), so every
      -- syntax group picks up the retuned values with no per-group overrides.
      colors = { palette = c.kanagawa },
      --
      -- Unlike tokyonight, kanagawa's `transparent` option reaches only
      -- `Normal` (verified against lua/kanagawa/highlights/editor.lua: it is
      -- the single `config.transparent` check in the whole highlight set).
      -- There is no `styles.floats/sidebars` equivalent either, so every other
      -- surface below is cleared by hand. `NormalNC` needs nothing: it default
      -- links to `Normal` (dimInactive is false), so it inherits the
      -- transparency for free.
      --
      -- overrides() is a shallow `vim.tbl_extend("force", ...)` per group, not
      -- a full replace like tokyonight's on_highlights -- omitting `bg` here
      -- would leave the plugin's own opaque value in place, so every group
      -- that needs to see through to the terminal states `bg = "NONE"`
      -- explicitly.
      ---@param colors { theme: table, palette: table } kanagawa's resolved colors
      overrides = function(colors)
        local theme = colors.theme
        return {
          LineNr = { fg = c.grey_dim, bg = "NONE" },
          CursorLineNr = { fg = c.orange, bg = "NONE", bold = true },
          SignColumn = { fg = theme.ui.special, bg = "NONE" },
          FoldColumn = { fg = theme.ui.nontext, bg = "NONE" },
          Folded = { fg = c.grey, bg = "NONE" },

          -- Popup menu. blink.cmp's BlinkCmpMenu/Doc/SignatureHelp link to
          -- Pmenu/NormalFloat/FloatBorder by default (kanagawa.nvim's own
          -- plugins.lua), so styling those once here keeps the completion menu
          -- transparent without restating it in blink.lua. PmenuSel/PmenuKindSel
          -- are left at kanagawa's own value, same as before: blink overrides
          -- its own selection to violet.
          NormalFloat = { fg = c.fg, bg = "NONE" },
          FloatBorder = { fg = c.grey_dim, bg = "NONE" },
          FloatTitle = { fg = theme.ui.special, bg = "NONE", bold = true },
          FloatFooter = { fg = theme.ui.nontext, bg = "NONE" },
          Pmenu = { fg = c.fg, bg = "NONE" },
          PmenuKind = { fg = c.violet, bg = "NONE" },
          PmenuExtra = { fg = c.grey, bg = "NONE" },
          PmenuSbar = { bg = "NONE" },

          -- Telescope's own default `TelescopeBorder` links to `Normal`, but
          -- kanagawa.nvim's plugins.lua overrides it with a real bg -- the one
          -- surface tokyonight didn't have an equivalent for.
          TelescopeBorder = { fg = c.grey_dim, bg = "NONE" },

          -- lualine draws the statusline, but the bare groups still show in
          -- windows it does not cover.
          StatusLine = { bg = "NONE" },
          StatusLineNC = { bg = "NONE" },

          -- Tabline: mini.tabline is not enabled, so these are the groups that
          -- actually render on :tabnew.
          TabLine = { fg = c.grey, bg = "NONE" },
          TabLineFill = { fg = c.grey, bg = "NONE" },
          TabLineSel = { fg = c.fg, bg = c.selection, bold = true },

          -- Cmdline float (tiny-cmdline over ui2). Green border to match the
          -- statusline. Its own links are `default = true`, so these win.
          TinyCmdlineNormal = { fg = c.fg, bg = "NONE" },
          TinyCmdlineBorder = { fg = c.green, bg = "NONE" },

          -- Incline's floating filename label. Set here, not through incline's
          -- own highlight.groups: incline deep-merges user values onto its
          -- `{ group = "NormalFloat", default = true }` default and renders the
          -- result as a legacy `:highlight` command, which silently left
          -- InclineNormalNC with an opaque background.
          InclineNormal = { fg = c.fg, bg = "NONE" },
          InclineNormalNC = { fg = c.grey, bg = "NONE" },
        }
      end,
    })

    vim.cmd.colorscheme("kanagawa")
  end,
}
