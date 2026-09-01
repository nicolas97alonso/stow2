-- Single source of truth for colors. Consumed by theme, lualine, blink, incline
-- and noice so nothing hardcodes hex values.
--
-- "Everforest dark, navy": the accents are everforest's dark base palette
-- verbatim (neanias/everforest-nvim, lua/everforest/colours.lua -> base_palette
-- .dark). The backgrounds and greys are shifted off everforest's warm forest
-- grey (#272e33 hard) onto a near-black navy.
--
-- Hardcoded rather than read from the colorscheme plugin: the background is a
-- deliberate override, so pulling from everforest's palette would fight it.
return {
  bg         = "#08111c", -- near-black navy; also set as the terminal background
  bg_dark    = "#050b13",
  surface    = "#121d29", -- subtle section background (lualine section b)
  surface_hi = "#1a2634", -- one step up from surface
  selection  = "#24313f", -- Visual; same value as the terminals' selection_bg
  fg         = "#d3c6aa", -- everforest fg
  grey       = "#7d8b8b", -- comments / muted; everforest grey1 #859289 shifted navy
  grey_dim   = "#4b5a63", -- gutter; the reference keeps line numbers below comments
  grey_light = "#9aa8a5", -- everforest grey2 shifted navy
  violet     = "#d699b6", -- everforest purple
  blue       = "#7fbbb3", -- everforest blue (reads teal; fields/properties)
  aqua       = "#83c092", -- everforest aqua
  green      = "#a7c080",
  yellow     = "#dbbc7f",
  orange     = "#e69875",
  red        = "#e67e80",
  pink       = "#d699b6",
}
