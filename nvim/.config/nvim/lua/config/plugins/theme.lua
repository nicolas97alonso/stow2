return {
  "navarasu/onedark.nvim",
  version = false,
  priority = 1000,
  config = function()
    local c = require("config.palette")

    require("onedark").setup({
      -- `dark` is the style whose bg0 is #282c34, i.e. One Half Dark's own
      -- background. The other styles (darker/cool/deep/warm) shift it.
      style = "dark",
      -- Only sets Normal, Terminal, EndOfBuffer, Folded, FoldColumn, SignColumn
      -- and WinBar to none -- see the `highlights` table below for the popup,
      -- float, tabline and statusline groups it leaves opaque.
      transparent = true,
      term_colors = true,
      ending_tildes = false,
      -- Comments italic, nothing else, matching the reference.
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },
      -- Virtual text keeps a background by default, which reads as an opaque
      -- block against the blurred terminal.
      diagnostics = {
        darker = true,
        undercurl = true,
        background = false,
      },
      -- Pull onedark onto palette.lua's values so the plugin and the statusline
      -- can't drift apart. onedark ships Atom One Dark; these overrides are what
      -- make it One *Half* Dark. The accents are near-identical between the two,
      -- so in practice only fg, red and the greys actually move.
      colors = {
        bg0 = c.bg,
        bg1 = c.surface,
        bg2 = c.surface_hi,
        bg3 = c.selection, -- drives Visual and WinSeparator
        bg_d = c.bg_dark,
        fg = c.fg, -- #dcdfe4; onedark ships Atom One Dark's dimmer #abb2bf
        red = c.red, -- onedark's #e86671 is oranger than OneHalfDark's
        orange = c.orange,
        yellow = c.yellow,
        green = c.green,
        cyan = c.aqua,
        blue = c.blue,
        purple = c.violet,
        grey = c.grey,
        light_grey = c.grey_light,
      },
      -- Note this table's merge semantics are the opposite of the plugin's
      -- internal ones: user highlights leave *unspecified* attributes alone
      -- (see replace_color in onedark/highlights.lua), so `bg = "NONE"` has to
      -- be stated explicitly to get transparency -- omitting bg preserves it.
      highlights = {
        -- onedark puts LineNr at the comment grey and CursorLineNr at plain fg.
        LineNr = { fg = c.grey_dim },
        CursorLineNr = { fg = c.orange, fmt = "bold" },
        -- Popup menu and floats: `transparent` does not reach these, they stay
        -- on bg1. blink.cmp's BlinkCmpMenu / Label / LabelDetail /
        -- LabelDescription / Kind / ScrollBarGutter default-link here, so these
        -- keep the completion menu transparent without restating it in
        -- blink.lua. PmenuSel is left at onedark's bg_blue; blink overrides its
        -- own selection to violet.
        Pmenu = { fg = c.fg, bg = "NONE" },
        PmenuExtra = { fg = c.grey, bg = "NONE" },
        PmenuKind = { fg = c.violet, bg = "NONE" },
        PmenuSbar = { bg = "NONE" },
        NormalFloat = { fg = c.fg, bg = "NONE" },
        FloatBorder = { fg = c.grey_dim, bg = "NONE" },
        -- Concealed text (markdown, json) otherwise carries a bg1 block.
        Conceal = { fg = c.grey, bg = "NONE" },
        -- lualine draws the statusline, but the bare groups still show in
        -- windows it does not cover.
        StatusLine = { bg = "NONE" },
        StatusLineNC = { bg = "NONE" },
        -- Tabline: mini.tabline is not enabled, so these are the groups that
        -- actually render on :tabnew. onedark's TabLineSel is an inverted white
        -- block (fg = bg0, bg = fg).
        TabLine = { fg = c.grey, bg = "NONE" },
        TabLineFill = { fg = c.grey, bg = "NONE" },
        TabLineSel = { fg = c.fg, bg = c.selection, fmt = "bold" },
        -- Cmdline (noice): no onedark integration. Green border to match the
        -- statusline.
        NoiceCmdlinePopup = { bg = "NONE" },
        NoiceCmdlinePopupBorder = { fg = c.green, bg = "NONE" },
        NoiceCmdlineIcon = { fg = c.green, bg = "NONE" },
        NoiceCmdline = { fg = c.fg, bg = "NONE" },
        -- Incline's floating filename label. Set here, not through incline's
        -- own highlight.groups: incline deep-merges user values onto its
        -- `{ group = "NormalFloat", default = true }` default and renders the
        -- result as a legacy `:highlight` command, which silently left
        -- InclineNormalNC with an opaque background. Its defaults are
        -- `highlight default link`, so they yield to these.
        InclineNormal = { fg = c.fg, bg = "NONE" },
        InclineNormalNC = { fg = c.grey, bg = "NONE" },
      },
    })

    require("onedark").load()
  end,
}
