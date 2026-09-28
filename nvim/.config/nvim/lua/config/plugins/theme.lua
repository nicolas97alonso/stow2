return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    local c = require("config.palette")

    require("kanagawa").setup({
      -- Wave, not Dragon/Lotus: it is the variant palette.lua is copied from.
      -- Changing this shifts every accent out from under palette.lua, which the
      -- statusline, incline and blink all read. Matches Omarchy's own
      -- neovim.lua, which just installs stock kanagawa.nvim with no on_colors
      -- equivalent -- Omarchy does not try to recolor the plugin to match its
      -- terminal colors.toml, and neither does this.
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
      -- No per-key overrides in `colors`: palette.lua is a verbatim copy of
      -- kanagawa's own Wave palette, so there is nothing to pull the plugin
      -- onto -- they are already the same values and cannot drift.
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

          -- Cmdline (noice). Green border to match the statusline.
          NoiceCmdlinePopup = { bg = "NONE" },
          NoiceCmdlinePopupBorder = { fg = c.green, bg = "NONE" },
          NoiceCmdlineIcon = { fg = c.green, bg = "NONE" },
          NoiceCmdline = { fg = c.fg, bg = "NONE" },

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
