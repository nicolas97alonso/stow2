-- Single source of truth for colors. Consumed by theme, lualine, blink, incline
-- and noice so nothing hardcodes hex values.
--
-- "One Half Dark". The accents and greys are sonph/onehalf's
-- vim/colors/onehalfdark.vim `s:` variables verbatim. The background was
-- upstream's #282c34, darkened to #1a1c22 by request -- the navy cast is
-- produced by Ghostty's background-opacity + blur over a blue-toned wallpaper,
-- not by a navy hex here.
-- Mirrors ghostty/.config/ghostty/config; change both together.
--
-- The colorscheme plugin is navarasu/onedark.nvim, style `dark`, which is Atom
-- One Dark. theme.lua feeds this table into its `colors` option; the two share
-- near-identical accents, so only fg, red and the greys actually differ.
--
-- Three values have no OneHalfDark equivalent and come from onedark's own
-- `dark` palette instead: bg_dark, grey_dim and orange. Marked below.
return {
  bg = "#1a1c22", -- darkened from upstream #282c34; also the terminal background
  bg_dark = "#21252b", -- onedark's bg_d; OneHalfDark defines nothing darker
  surface = "#313640", -- upstream cursor_line / color_col (lualine section b)
  surface_hi = "#373c45", -- upstream non_text; one step up from surface
  selection = "#474e5d", -- upstream selection; same as the terminal's selection-background
  fg = "#dcdfe4", -- upstream white/fg
  grey = "#5c6370", -- comments / muted; upstream comment_fg
  -- OneHalfDark's gutter_fg is #919baa, which is *brighter* than its comments.
  -- Kept dim here so line numbers stay below comments; swap to #919baa for
  -- strict OneHalfDark fidelity. onedark itself puts LineNr at the comment grey,
  -- which is why theme.lua overrides LineNr to this.
  grey_dim = "#495162",
  grey_light = "#919baa", -- upstream gutter_fg, reused as the bright grey
  violet = "#c678dd", -- upstream purple
  blue = "#61afef",
  aqua = "#56b6c2", -- upstream cyan
  green = "#98c379",
  yellow = "#e5c07b",
  orange = "#d19a66", -- onedark's orange; OneHalfDark defines none
  red = "#e06c75",
}
