-- Single source of truth for colors. Consumed by theme, lualine, blink, incline
-- and noice so nothing hardcodes hex values.
--
-- Kanagawa -- Omarchy's official "kanagawa" theme. Every accent below is
-- rebelot/kanagawa.nvim's own `lua/kanagawa/themes.lua` `wave` table, resolved
-- against its `lua/kanagawa/colors.lua` palette, verbatim -- see the upstream
-- key in each comment.
--
-- The neutral base (bg / bg_dark / surface / surface_hi) is the ONE deviation:
-- it uses Dragon's `dragonBlack*` grey ladder instead of Wave's purple-tinted
-- `sumiInk*`, because a dark grey background was wanted. Still official Kanagawa
-- values from the same colors.lua, just the other variant's greys -- so base and
-- accents remain one designer's palette. Ghostty's config makes the same swap;
-- the reasoning (and why dragonBlack2 rather than Dragon's own darker bg) lives
-- there.
--
-- nvim never paints `bg` -- Normal is bg = "NONE" and the terminal draws the
-- background -- so this value exists only for the two consumers that need a
-- real hex: nvim-notify (rejects "NONE") and lualine's section-a foreground.
-- Keep it equal to ghostty's `background`.
--
-- Mirrors ghostty/.config/ghostty/config; change both together.
return {
  bg = "#1D1C19", -- upstream palette.dragonBlack2; == ghostty `background`
  bg_dark = "#12120f", -- upstream ui.bg_dim(dragon) / palette.dragonBlack1
  -- upstream ui.bg_p1(dragon) / palette.dragonBlack4 (lualine section b)
  surface = "#282727",
  -- upstream ui.bg_p2(dragon) / palette.dragonBlack5; one step up from surface,
  -- and the value ghostty uses for `selection-background`.
  surface_hi = "#393836",
  -- upstream ui.bg_visual / palette.waveBlue1 -- Wave's own Visual-mode
  -- highlight, deliberately left as the Wave navy rather than following the
  -- base onto Dragon's greys: it is an accent, and TabLineSel needs to stand
  -- out from the grey ladder above, not blend into it.
  selection = "#223249",
  fg = "#dcd7ba", -- upstream ui.fg / palette.fujiWhite
  grey = "#727169", -- comments / muted; upstream syn.comment / palette.fujiGray
  -- upstream ui.nontext + ui.whitespace / palette.sumiInk6; dimmer than `grey`
  -- so line numbers stay below comments.
  grey_dim = "#54546d",
  grey_light = "#c8c093", -- upstream ui.fg_dim / palette.oldWhite
  violet = "#957fb8", -- upstream syn.keyword / palette.oniViolet
  blue = "#7e9cd8", -- upstream syn.fun / palette.crystalBlue
  aqua = "#7aa89f", -- upstream syn.type / palette.waveAqua2
  green = "#98bb6c", -- upstream syn.string(diag.ok) / palette.springGreen
  yellow = "#e6c384", -- upstream syn.identifier / palette.carpYellow
  -- upstream syn.constant / palette.surimiOrange. Omarchy's own terminal
  -- orange (#c17158) is a different, more muted value -- Omarchy's neovim.lua
  -- itself just installs stock kanagawa.nvim with no recoloring, so this
  -- mismatch between editor and terminal accents is the official behavior,
  -- not a gap.
  orange = "#ffa066",
  red = "#e82424", -- upstream diag.error / palette.samuraiRed
}
