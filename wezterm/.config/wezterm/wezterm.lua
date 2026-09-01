local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 1. Theme / Color Scheme ("One Half Dark, navy")
-- The six accents are onehalfdark's verbatim (sonph/onehalf). The background and
-- the greys are shifted onto a deep navy instead of onehalfdark's warm slate
-- (#282c34). Mirrored in ghostty/.config/ghostty/config and in nvim's
-- lua/config/palette.lua -- change all three together.
config.colors = {
  foreground = "#dcdfe4",
  background = "#0d1b2a", -- Deep navy background
  cursor_bg = "#dcdfe4",
  cursor_border = "#dcdfe4",
  cursor_fg = "#0d1b2a",
  selection_bg = "#2a3f52",
  selection_fg = "#dcdfe4",
  ansi = {
    "#1d2836", -- Black (navy-shifted from onehalfdark #282c34)
    "#e06c75", -- Red
    "#98c379", -- Green
    "#e5c07b", -- Yellow
    "#61afef", -- Blue
    "#c678dd", -- Magenta (purple)
    "#56b6c2", -- Cyan
    "#dcdfe4", -- White
  },
  -- onehalfdark defines no separate bright set, so these are the accents blended
  -- 15% toward white. btop/htop lean on brights being distinguishable.
  brights = {
    "#5a6b7d", -- Bright Black (comment grey, navy-shifted)
    "#e5828a", -- Bright Red
    "#a7cc8d", -- Bright Green
    "#e9c98f", -- Bright Yellow
    "#79bbf1", -- Bright Blue
    "#cf8ce2", -- Bright Magenta
    "#6fc1cb", -- Bright Cyan
    "#eef0f3", -- Bright White
  },
  tab_bar = {
    background = "#0d1b2a",
    active_tab = {
      bg_color = "#2a3f52", -- Muted navy active tab
      fg_color = "#dcdfe4",
    },
    inactive_tab = {
      bg_color = "#0d1b2a",
      fg_color = "#5a6b7d",
    },
    inactive_tab_hover = {
      bg_color = "#2a3f52",
      fg_color = "#dcdfe4",
    },
    new_tab = {
      bg_color = "#0d1b2a",
      fg_color = "#dcdfe4",
    },
    new_tab_hover = {
      bg_color = "#2a3f52",
      fg_color = "#dcdfe4",
    },
  },
}

-- 2. Font configuration with fallback fonts
config.font = wezterm.font_with_fallback({
  "GoogleSansCode NFM",
  "Symbols Nerd Font Mono",
  "Menlo",
})
-- Clip square glyphs to their cell; prevents ink bleed into adjacent cells.
config.allow_square_glyphs_to_overflow_width = "Never"
config.font_size = 13.0

-- GoogleSansCode's natural line box is 1.252em vs Hack's 1.164em, so 1.07 here
-- reproduces the exact cell height 1.15 gave with Hack (17.4px at 13pt).
config.line_height = 1.07

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
