-- Single source of truth for colors. Consumed by theme, lualine, blink, incline
-- and noice so nothing hardcodes hex values.
--
-- "One Half Dark, navy": the six accents are onehalfdark's verbatim
-- (sonph/onehalf, vim/colors/onehalfdark.vim). The greys and the background are
-- shifted off onehalfdark's warm slate (#282c34) onto a deep navy, which is what
-- the reference screenshots actually measure at (~#111f2c blended through 0.9
-- opacity over a wallpaper).
--
-- Hardcoded rather than read from the colorscheme plugin: the background is a
-- deliberate override, so pulling from onedark.nvim's palette would fight it.
return {
  bg      = "#0d1b2a", -- navy; also set as the terminal background
  bg_dark = "#0a151f",
  surface = "#1a2a3a", -- subtle section background (lualine section b)
  fg      = "#dcdfe4", -- onehalfdark white
  grey    = "#5a6b7d", -- comments / muted; onehalfdark #5c6370 shifted navy
  grey_dim = "#44525f", -- gutter; the reference keeps line numbers below comments
  violet  = "#c678dd", -- onehalfdark purple
  blue    = "#61afef",
  aqua    = "#56b6c2", -- onehalfdark cyan
  green   = "#98c379",
  yellow  = "#e5c07b",
  orange  = "#d19a66", -- One Dark's orange; onehalfdark defines none
  red     = "#e06c75",
  pink    = "#df6b8a",
}
