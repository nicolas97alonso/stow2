local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 1. Theme / Color Scheme (Kanagawa Wave palette override)
config.colors = {
  foreground = "#dcd7ba",
  background = "#0c0f12", -- Deep ice-blue-black background
  cursor_bg = "#c8c093",
  cursor_border = "#c8c093",
  cursor_fg = "#0c0f12",
  selection_bg = "#2d4f67",
  selection_fg = "#dcd7ba",
  ansi = {
    "#090618", -- Black (sumiInk0)
    "#c34043", -- Red (autumnRed)
    "#76946a", -- Green (springGreen)
    "#c0a36e", -- Yellow (boatYellow)
    "#7e9cd8", -- Blue (crystalBlue)
    "#957fb8", -- Magenta (oniViolet)
    "#6a9589", -- Cyan (waveBlue1)
    "#c8c093", -- White (oldWhite)
  },
  brights = {
    "#727169", -- Bright Black (fujiGray)
    "#e82424", -- Bright Red (samuraiRed)
    "#98bb6c", -- Bright Green (autumnGreen)
    "#e6c384", -- Bright Yellow (roninYellow)
    "#7fb4ca", -- Bright Blue (springBlue)
    "#938aa9", -- Bright Magenta (lightViolet)
    "#7aa89f", -- Bright Cyan (waveAqua)
    "#dcd7ba", -- Bright White (fujiWhite)
  },
  tab_bar = {
    background = "#0c0f12",
    active_tab = {
      bg_color = "#2d4f67", -- Muted blue active tab
      fg_color = "#dcd7ba",
    },
    inactive_tab = {
      bg_color = "#0c0f12",
      fg_color = "#727169",
    },
    inactive_tab_hover = {
      bg_color = "#2d4f67",
      fg_color = "#dcd7ba",
    },
    new_tab = {
      bg_color = "#0c0f12",
      fg_color = "#dcd7ba",
    },
    new_tab_hover = {
      bg_color = "#2d4f67",
      fg_color = "#dcd7ba",
    },
  },
}

-- 2. Font configuration with fallback fonts
config.font = wezterm.font_with_fallback({
  "Hack Nerd Font",
  "JetBrains Mono",
  "Fira Code",
  "Menlo",
})
config.font_size = 13.0

-- Font spacing adjustments
config.line_height = 1.15
config.cell_width = 1.0

-- 3. Transparent & Blurred Background (macOS specific)
config.window_background_opacity = 0.8
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

-- 7. Cursor style
config.default_cursor_style = "BlinkingBlock"

return config
