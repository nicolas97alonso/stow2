-- Single source of truth for colors, pulled from the active kanagawa palette.
-- Consumed by theme, lualine, blink and incline so nothing hardcodes hex values.
local ok, kanagawa = pcall(require, "kanagawa.colors")
if not ok then
  return {}
end

-- Read the variant kanagawa was actually set up with (theme.lua owns it) rather
-- than repeating it here, where the two could silently drift apart.
local variant = require("kanagawa").config.theme
local p = kanagawa.setup({ theme = variant }).palette

return {
  bg      = p.sumiInk3,   -- #1F1F28 main background
  bg_dark = p.sumiInk1,
  surface = p.sumiInk4,   -- subtle section background
  fg      = p.fujiWhite,  -- #DCD7BA
  grey    = p.fujiGray,   -- comments / muted
  violet  = p.oniViolet,  -- #957FB8
  blue    = p.crystalBlue,-- #7E9CD8
  aqua    = p.waveAqua2,
  green   = p.springGreen,
  yellow  = p.carpYellow,
  orange  = p.surimiOrange,
  red     = p.waveRed,
  pink    = p.sakuraPink,
}
