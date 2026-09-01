local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 1. Theme / Color Scheme ("Everforest dark, navy")
-- The accents are everforest's dark base palette verbatim (sainnhe/everforest).
-- The background and the greys are shifted onto a near-black navy instead of
-- everforest's warm forest grey (#272e33). Mirrored in
-- ghostty/.config/ghostty/config and in nvim's lua/config/palette.lua --
-- change all three together.
config.colors = {
  foreground = "#d3c6aa",
  background = "#060d16", -- Near-black navy background
  cursor_bg = "#d3c6aa",
  cursor_border = "#d3c6aa",
  cursor_fg = "#060d16",
  selection_bg = "#24313f",
  selection_fg = "#d3c6aa",
  ansi = {
    "#1a2430", -- Black (navy-shifted from everforest #272e33)
    "#e67e80", -- Red
    "#a7c080", -- Green
    "#dbbc7f", -- Yellow
    "#7fbbb3", -- Blue (reads teal)
    "#d699b6", -- Magenta (purple)
    "#83c092", -- Cyan (aqua)
    "#d3c6aa", -- White
  },
  -- everforest defines no separate bright set, so these are the accents blended
  -- 15% toward white. btop/htop lean on brights being distinguishable.
  brights = {
    "#7d8b8b", -- Bright Black (comment grey, navy-shifted)
    "#ea9193", -- Bright Red
    "#b4c993", -- Bright Green
    "#e0c692", -- Bright Yellow
    "#92c5be", -- Bright Blue
    "#dca8c1", -- Bright Magenta
    "#96c9a2", -- Bright Cyan
    "#dacfb7", -- Bright White
  },
  tab_bar = {
    background = "#060d16",
    active_tab = {
      bg_color = "#24313f", -- Muted navy active tab
      fg_color = "#d3c6aa",
    },
    inactive_tab = {
      bg_color = "#060d16",
      fg_color = "#7d8b8b",
    },
    inactive_tab_hover = {
      bg_color = "#24313f",
      fg_color = "#d3c6aa",
    },
    new_tab = {
      bg_color = "#060d16",
      fg_color = "#d3c6aa",
    },
    new_tab_hover = {
      bg_color = "#24313f",
      fg_color = "#d3c6aa",
    },
  },
}

-- 2. Font configuration with fallback fonts
-- "JetBrainsMono NFM" is the Nerd Font Mono build's abbreviated family name
-- (nameID 1); the full name is "JetBrainsMono Nerd Font Mono". The patched build
-- rather than plain JetBrains Mono, because lualine's powerline separators,
-- mini.icons and blink's kind icons all need the Nerd Font glyphs.
config.font = wezterm.font_with_fallback({
  "JetBrainsMono NFM",
  "Symbols Nerd Font Mono",
  "Menlo",
})
-- Clip square glyphs to their cell; prevents ink bleed into adjacent cells.
config.allow_square_glyphs_to_overflow_width = "Never"
config.font_size = 12.0

-- No override: JetBrains Mono's natural line box is already 1.3200em (vs
-- GoogleSansCode's 1.2520em), so 12pt gives a 15.84px cell unaided. This matches
-- upstream's config, which sets no line-height adjustment at all.
-- For the old 17.42px cell height instead, use 1.099.
config.line_height = 1.0

-- Lighter hinting; the doc-sanctioned "closer to macOS rendering" target.
-- Deliberately NOT pairing this with freetype_render_target = "HorizontalLcd",
-- which cannot set the text alpha channel and would break window transparency.
config.freetype_load_target = "Light"

-- 3. Transparent & Blurred Background (macOS specific)
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30

-- 4. Borderless window decoration (Hides title bar & buttons, allows resizing)
config.window_decorations = "RESIZE"

-- 5. Window padding (Breathing room around text)
config.window_padding = {
  left = 20,
  right = 20,
  top = 20,
  bottom = 20,
}

-- 6. Clean tab bar behavior
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false -- simple/retro tab bar

-- 7. Cursor style — steady block, no blink (zero idle redraw, best for battery)
config.default_cursor_style = "SteadyBlock"

-- 8. Don't prompt to confirm when closing a window/tab
config.window_close_confirmation = "NeverPrompt"

return config
