# Dotfiles repo

Stow-based. Packages are symlinked into place with GNU stow. Edit the source under
`~/stow/<package>/`, never the symlink target.

## Editing the nvim config

conform formats on save, and `lua` is wired to stylua, so **the config formats
itself**. `nvim/.config/nvim/.stylua.toml` pins 2-space indent — it sits inside the
package so stylua finds it through the `~/.config/nvim` symlink too. Without it
stylua's default (tabs) would retab everything. Run `stylua .` from
`nvim/.config/nvim` after hand-editing; `stylua --check .` should be clean.

The formatters conform shells out to (`black stylua shfmt clang-format`) are
declared in `plugins/lsp.lua`'s `tools` list and installed by mason-tool-installer.
mason-lspconfig's `ensure_installed` only accepts LSP servers — adding a formatter
there does nothing.

## Changing the theme / colorscheme

A theme change is never one file. Every surface below carries color and has to be
updated in the same pass, or the setup ends up half-themed.

### Where the background actually lives

Neovim's `Normal` is forced to `bg = "NONE"`, so **nvim does not draw the
background** — the terminal does. The background hex lives in the Ghostty config,
not in the colorscheme. Changing the nvim theme alone will not change the
background.

And the background is only half the story: the current look is Ghostty's
`background-opacity = 0.95` + `background-blur = 20` letting a **blue-toned
wallpaper** through a neutral `#282c34`. The navy cast is the wallpaper, not a
hex. On a neutral or warm wallpaper the theme reads as flat grey — the wallpaper
is part of the theme and is not tracked in this repo.

### Neovim (`~/stow/nvim/.config/nvim/lua/config/`)

- `palette.lua` — **single source of truth.** Every other file reads from it. Every
  key is consumed: `bg bg_dark surface surface_hi selection fg grey grey_dim
  grey_light violet blue aqua green yellow orange red`. Removing or renaming a key
  breaks the consumers below silently. Three keys have no OneHalfDark value and
  are filled from onedark's own `dark` palette: `bg_dark`, `grey_dim`, `orange` —
  see the comments in the file.
- `plugins/theme.lua` — the colorscheme (`navarasu/onedark.nvim`, style `dark`)
  plus **every highlight override in the config that isn't blink-specific**.
  `style = "dark"` is load-bearing: it is the style whose `bg0` is `#282c34`.
  The other styles (`darker`/`cool`/`deep`/`warm`) shift the background off the
  Ghostty value.

  `palette.lua` is fed in through the `colors` option so the plugin and the
  statusline can't drift. Everything else goes through `highlights`, so there is
  **no `ColorScheme` autocmd here** — `setup()` output is regenerated on every
  colorscheme load by construction. blink is the only place that needs the
  autocmd; don't add one back here.

  Two merge-semantics traps in this plugin:

  1. `highlights` (user) and the plugin's internal `vim_highlights` behave
     **oppositely**. Internally, an unspecified attribute is written as `none`;
     in the user table, an unspecified attribute is left *untouched* (see
     `replace_color` in `onedark/highlights.lua`). So transparency needs an
     explicit `bg = "NONE"` — omitting `bg` preserves the opaque one.
  2. Overrides use **`fmt = "bold"`**, not `bold = true`. It emits legacy
     `:highlight` commands, so `bold`/`italic` keys are silently dropped.

  `transparent = true` only reaches `Normal`, `Terminal`, `EndOfBuffer`,
  `Folded`, `FoldColumn`, `SignColumn` and `WinBar`. Everything else that carries
  a background has to be listed by hand: the `Pmenu` family, `NormalFloat` /
  `FloatBorder`, `StatusLine` / `StatusLineNC`, the `TabLine` groups, `Conceal`,
  plus the Noice cmdline groups and `InclineNormal` / `InclineNormalNC`.

  Not needed, unlike with the colorschemes tried before it: onedark's
  `@variable` is already `fg` (not red), and its diagnostic and treesitter groups
  are complete. `diagnostics.background = false` is set so virtual text doesn't
  carry an opaque block.
- `plugins/lualine.lua` — a hand-built theme table with a distinct mode color for
  `normal / insert / visual / replace / command / terminal / inactive`.
- `plugins/incline.lua` — only the four diagnostic severity colors in `render`.
  `InclineNormal` / `InclineNormalNC` live in `theme.lua`: passing them through
  incline's own `highlight.groups` merges them onto its
  `{ group = "NormalFloat", default = true }` default and emits a legacy
  `:highlight ... link ...` command, which drops `guibg` and leaves the inactive
  label opaque.
- `plugins/blink.lua` — only the `BlinkCmp*` groups that **deviate** from the
  colorscheme (borders, selection, kinds, ghost text, matches), re-applied on
  `ColorScheme`. Anything blink default-links to `Pmenu` / `PmenuExtra` /
  `PmenuKind` / `PmenuSbar` / `NormalFloat` is styled once in `theme.lua` instead.
  Gotcha: a highlight definition consisting only of `bg = "NONE"` collapses to an
  empty group and blink's `default link` wins, so transparency has to come from
  the link target, not from restating it here.
- `plugins/noice.lua` — `background_colour` for nvim-notify.

### Terminal

- `ghostty/.config/ghostty/config` — `background`, `foreground`, `cursor-color`,
  `cursor-text`, `selection-background/foreground`, `palette = 0..15`, plus
  `background-opacity` / `background-blur`.

Two deliberate deviations from upstream OneHalfDark are marked in the file: it
sets both black and bright-black to `#282c34` (= the background, so ANSI black
text is invisible), and it makes brights 9–15 identical to 1–7. The first is
fixed, the second is kept.

Validate with `~/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config`
(exit 0) and `+show-config`. Note `+show-config` omits any value equal to a
built-in default — `background = #282c34` happens to *be* Ghostty's default, so
its absence from the output is expected, not a parse failure. `+show-config
--default` confirms.

Note on checking symlinks: stow uses **directory folding** here, so
`~/.config/ghostty` and `~/.config/nvim` are themselves the
symlinks, and the files inside them are not. `test -L` on the file therefore
reports "not a symlink" even though it is correctly stowed. Verify with
`readlink -f <file>` or by comparing inodes, not by testing the file itself.

### Prompt

- `starship/.config/starship.toml` — **mixed** since the OneHalfDark change.
  `directory` and `git_branch` are pinned to the reference prompt's lavender
  `#AE8FE7`, and `time` to its grey `#454758`; these do *not* follow the terminal
  palette and must be changed by hand. `git_status` and `cmd_duration` are still
  ANSI names and do follow it.
  `#AE8FE7` is intentionally outside the OneHalfDark palette (whose purple is
  `#c678dd`), which is why an ANSI name can't produce it.
  `git_branch` is cyan `#56b6c2`, **not** the lavender: at 25° of hue from it the
  branch was indistinguishable from the directory. Cyan is the widest separation
  available here — 74° off the lavender, ≥90° off the red status, yellow duration
  and green prompt char.
  Validate with `starship explain` — it prints the resolved truecolor escapes.

### After changing

Restart the terminal fully (macOS needs a full quit for `background-opacity`) and
open nvim to confirm: statusline mode colors, completion menu, floating windows,
gutter, and the cmdline all still have contrast against the new background.

For nvim, this is checkable without eyeballing it — dump the resolved groups:

```sh
# any group that still has a bg is a surface that will block the terminal blur
nvim --headless -c 'lua
local core = {"Normal","NormalFloat","FloatBorder","Pmenu","PmenuSbar","SignColumn",
  "LineNr","StatusLine","TabLine","TabLineFill","Folded","FoldColumn","Conceal",
  "BlinkCmpMenu","NoiceCmdlinePopup","InclineNormal","TelescopeNormal","NeoTreeNormal"}
local bad = {}
for _, g in ipairs(core) do
  if vim.api.nvim_get_hl(0, { name = g, link = false }).bg then table.insert(bad, g) end
end
print(#bad == 0 and "OK" or ("STILL OPAQUE: " .. table.concat(bad, ", ")))' +qa
```

Run it a second time with `-c 'colorscheme onedark'` prepended to confirm the
overrides survive a reload. `stylua --check .` from `nvim/.config/nvim` must also
be clean.
