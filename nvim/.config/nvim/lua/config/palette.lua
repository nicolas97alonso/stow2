-- Single source of truth for colors. Consumed by theme, lualine, blink and
-- incline so nothing hardcodes hex values.
--
-- Kanagawa Wave, retuned. `kanagawa` holds kanagawa.nvim's own palette names
-- (lua/kanagawa/colors.lua) with retuned values. theme.lua passes it to the
-- plugin as `colors.palette`, so editor syntax, the role keys below and
-- ghostty's palette (same names, same hexes) cannot drift apart.
--
-- Retune rule, in OKLCH, every hue kept:
--   * whites near-neutral instead of cream: fujiWhite C 0.039 -> 0.012 (L 0.90),
--     oldWhite C 0.061 -> 0.025 (L 0.82)
--   * main accents: chroma clamped into 0.10-0.16, then lightened until >= 6:1
--     against bg
--   * quiet roles (oniViolet2 parameters, springViolet1 special, springViolet2
--     punctuation): chroma 0.06-0.09, same 6:1 floor
--   * reds use lower floors instead (autumnRed 5.0, samuraiRed 5.5 with chroma up
--     to 0.19, waveRed / peachRed 5.0). Lifting all four to 6:1 collapsed them into
--     one coral; this keeps Kanagawa's deep -> vivid order.
-- Backgrounds and the dim greys (fujiGray, sumiInk6) are upstream, untouched.
-- Result vs upstream Wave on this bg: text 11.74 -> 12.64:1, weakest terminal
-- accent 3.36 -> 5.05:1, mean accent chroma (CIE LCh) 33.8 -> 41.0.
local k = {
  fujiWhite = "#e0ded5", -- upstream #DCD7BA
  oldWhite = "#c8c5b3", -- upstream #C8C093
  autumnRed = "#e36362", -- upstream #C34043
  samuraiRed = "#fa6154", -- upstream #E82424
  waveRed = "#e46876", -- upstream, already above its floor
  peachRed = "#ef6e6e", -- upstream #FF5D62 (chroma capped)
  autumnGreen = "#7aa668", -- upstream #76946A
  springGreen = "#98bb6c", -- upstream
  boatYellow2 = "#c7a15a", -- upstream #C0A36E
  carpYellow = "#e9c27b", -- upstream #E6C384
  autumnYellow = "#dca561", -- upstream
  roninYellow = "#ff9e3b", -- upstream
  surimiOrange = "#ffa066", -- upstream
  crystalBlue = "#7c9cdb", -- upstream #7E9CD8
  springBlue = "#5db8db", -- upstream #7FB4CA
  oniViolet = "#a98fd2", -- upstream #957FB8
  sakuraPink = "#d5819c", -- upstream #D27E99
  waveAqua1 = "#46ab94", -- upstream #6A9589
  waveAqua2 = "#48b1a1", -- upstream #7AA89F
  oniViolet2 = "#b8b2dc", -- upstream #b8b4d0
  springViolet1 = "#a094bd", -- upstream #938AA9
  springViolet2 = "#98abd2", -- upstream #9CABCA
}

-- The neutral base (bg / bg_dark / surface / surface_hi) uses Dragon's
-- `dragonBlack*` grey ladder instead of Wave's purple-tinted `sumiInk*`, because a
-- dark grey background was wanted. Ghostty's config makes the same swap; the
-- reasoning (and why dragonBlack2 rather than Dragon's own darker bg) lives there.
--
-- nvim never paints `bg` -- Normal is bg = "NONE" and the terminal draws the
-- background -- so this value exists only for the one consumer that needs a
-- real hex: lualine's section-a foreground.
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
  fg = k.fujiWhite, -- ui.fg
  grey = "#727169", -- comments / muted; syn.comment / palette.fujiGray, upstream
  -- ui.nontext + ui.whitespace / palette.sumiInk6, upstream; dimmer than `grey`
  -- so line numbers stay below comments.
  grey_dim = "#54546d",
  grey_light = k.oldWhite, -- ui.fg_dim
  violet = k.oniViolet, -- syn.keyword
  blue = k.crystalBlue, -- syn.fun
  aqua = k.waveAqua2, -- syn.type
  green = k.springGreen, -- syn.string (diag.ok)
  yellow = k.carpYellow, -- syn.identifier
  orange = k.surimiOrange, -- syn.constant
  red = k.samuraiRed, -- diag.error
  kanagawa = k,
}
