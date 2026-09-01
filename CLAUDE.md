# Dotfiles repo

Stow-based. Packages are symlinked into place with GNU stow. Edit the source under
`~/stow/<package>/`, never the symlink target.

## Changing the theme / colorscheme

A theme change is never one file. Every surface below carries color and has to be
updated in the same pass, or the setup ends up half-themed.

### Where the background actually lives

Neovim runs `transparent = true`, so **nvim does not draw the background** — the
terminal does. The background hex lives in the terminal configs, not in the
colorscheme. Changing the nvim theme alone will not change the background.

### Neovim (`~/stow/nvim/.config/nvim/lua/config/`)

- `palette.lua` — **single source of truth.** Every other file reads from it. Keys
  currently consumed: `bg surface fg grey violet blue aqua green yellow orange red`
  (`bg_dark` and `pink` are defined but unused). Removing or renaming a key breaks
  the consumers below silently.
- `plugins/theme.lua` — the colorscheme itself, plus the transparency fixups
  everforest leaves behind: `SignColumn`, `NormalFloat`, `FloatBorder`,
  `LineNr`, `CursorLineNr`, and the Noice cmdline groups. Re-applied on a
  `ColorScheme` autocmd.
- `plugins/lualine.lua` — a hand-built theme table with a distinct mode color for
  `normal / insert / visual / replace / command / terminal / inactive`.
- `plugins/incline.lua` — `InclineNormal` / `InclineNormalNC` and the four
  diagnostic severity colors.
- `plugins/blink.lua` — ~30 `BlinkCmp*` highlight groups, re-applied on
  `ColorScheme`. The most tedious surface; easy to forget.
- `plugins/noice.lua` — `background_colour` for nvim-notify.

### Terminal — both configs, kept as deliberate mirrors

- `wezterm/.config/wezterm/wezterm.lua` — `colors.foreground`, `background`,
  `cursor_bg/border/fg`, `selection_bg/fg`, the 8 `ansi` + 8 `brights` entries,
  and the whole `tab_bar` block.
- `ghostty/.config/ghostty/config` — `background`, `foreground`, `cursor-color`,
  `cursor-text`, `selection-background/foreground`, `palette = 0..15`.

Keep the two byte-comparable. If one changes, change the other.

Note on checking symlinks: stow uses **directory folding** here, so
`~/.config/wezterm`, `~/.config/ghostty` and `~/.config/nvim` are themselves the
symlinks, and the files inside them are not. `test -L` on the file therefore
reports "not a symlink" even though it is correctly stowed. Verify with
`readlink -f <file>` or by comparing inodes, not by testing the file itself.

### Prompt

- `starship/.config/starship.toml` deliberately uses ANSI color *names*, not hexes,
  so it inherits whatever the terminal palette is. Normally needs no change — but
  if the ANSI 0–15 values shift, verify the prompt still reads well.

### After changing

Restart the terminal fully (macOS needs a full quit for `background-opacity`) and
open nvim to confirm: statusline mode colors, completion menu, floating windows,
gutter, and the cmdline all still have contrast against the new background.
