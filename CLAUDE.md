# Dotfiles repo

Stow-based. Packages are symlinked into place with GNU stow. Edit the source under
`~/stow/<package>/`, never the symlink target.

## Editing the nvim config

conform formats on save, and `lua` is wired to stylua, so **the config formats
itself**. `nvim/.config/nvim/.stylua.toml` pins 2-space indent — it sits inside the
package so stylua finds it through the `~/.config/nvim` symlink too. Without it
stylua's default (tabs) would retab everything. Run `stylua .` from
`nvim/.config/nvim` after hand-editing; `stylua --check .` should be clean.

## LSP: there is no mason-lspconfig

`plugins/lsp.lua` uses **native `vim.lsp.config` / `vim.lsp.enable` only**. mason-lspconfig
was removed; do not add it back. Two reasons, both measured:

1. It cost 19 ms — a third of all plugin load time.
2. Its `automatic_enable = true` enables *any installed Mason package that
   nvim-lspconfig has an `lsp/` file for*. nvim-lspconfig ships `lsp/stylua.lua`,
   so the `stylua` **formatter** was being started as a second LSP client on every
   Lua buffer, alongside `lua_ls`. Verified with `vim.lsp.get_clients()`.

That is why the file has **two name lists in one table**: `vim.lsp.enable()` takes
nvim-lspconfig's config name, `mason-tool-installer` takes the Mason registry name,
and they differ often (`dockerls` / `dockerfile-language-server`, `lua_ls` /
`lua-language-server`, `jsonls` / `json-lsp`). Keep them in the one `servers` table
so they can't drift. Formatters live in a **separate** `formatters` list precisely
so they can never be passed to `vim.lsp.enable()`.

### `format_on_save` uses `lsp_format = "never"` on purpose

Not `"fallback"`. With `"fallback"`, every filetype that has an LSP but no
`formatters_by_ft` entry gets formatted by that LSP on save. yamlls bundles
prettier and advertises `documentFormattingProvider`, so `"fallback"` would have
enrolled all 663 `.yml` files in the dbt repo into prettier-on-save — 481 of them
change substantively, and `dbt_project.yml` loses its whole aligned-comment block.
`yamlls` additionally has `yaml.format.enable = false` as a second guard.
`<leader>cf` is the opt-in path and is the only place `lsp_format = "fallback"`
appears.

### There is deliberately no SQL formatter or SQL LSP

This is the most surprising omission given the repo is mostly T-SQL, so: it was
measured, not overlooked.

- **sqlfluff cannot template these models.** 25/25 real models fail with
  `Undefined jinja template variable`. Resolving the project's macros needs
  `templater = dbt`, and the brew sqlfluff only offers
  `raw/jinja/python/placeholder`. Same reason sqlfluff-as-a-linter via nvim-lint
  is dead — it emits one templating error per file and nothing else.
- **shandy-sqlfmt handles the Jinja but rewrites the codebase.** 699 of 748 files
  change: it lowercases every identifier and moves leading commas to trailing,
  which is the exact opposite of the project's own `.sqlfluff`
  (`extended_capitalisation_policy = pascal`, `line_position = leading`). 8 macro
  files fail its token-safety check.
- **`sqlfmt` is also ambiguous on this machine**: `~/homebrew/bin/sqlfmt` is the Go
  `sqlfum.pt` and shadows the pipx-installed shandy-sqlfmt, so a bare `"sqlfmt"` in
  conform runs the wrong binary.
- Both `sqls` and `sqlls` are connection-oriented (they want live Azure SQL
  credentials) and neither can parse an uncompiled Jinja template.

The only working path is `sqlfluff` + `sqlfluff-templater-dbt` inside the project's
own venv, which needs a live dbt profile and runs at seconds per file. That belongs
to the project, not to this config.

### dbt `.sql` files: the broken treesitter parse is the best available option

Every dbt model reports `has_error = true` from the `sql` parser, because it chokes
on `{{ }}`. It still highlights 77–86% of lines, and the errors are localised to the
Jinja spans. A `jinja.sql` compound filetype is **strictly worse**:
`vim.treesitter.language.get_lang("jinja.sql")` resolves to `jinja` (nvim splits on
the dot), and jinja's `highlights.scm` covers only Jinja tags — you'd get a clean
parse and zero SQL highlighting. Leave it alone.

## Formatters conform shells out to

`black stylua shfmt clang-format`, declared in `plugins/lsp.lua`'s `formatters` list
and installed by mason-tool-installer alongside the servers.

## Changing the theme / colorscheme

A theme change is never one file. Every surface below carries color and has to be
updated in the same pass, or the setup ends up half-themed.

The current theme is Omarchy's official **Kanagawa** (`themes/kanagawa/` in
[basecamp/omarchy](https://github.com/basecamp/omarchy), Quattro branch) —
terminal-only here (nvim, Ghostty, Starship). No macOS wallpaper or other Omarchy
surfaces are tracked in this repo.

### Where the background actually lives

Neovim's `Normal` is forced to `bg = "NONE"`, so **nvim does not draw the
background** — the terminal does. The background hex lives in the Ghostty config,
not in the colorscheme. Changing the nvim theme alone will not change the
background.

Transparency is Ghostty's `background-opacity = 0.85` + `background-blur = 30`,
independent of which colors the theme uses — changing the color palette does not
require touching these two.

Ghostty has **no gradient option**. The only related knobs are `background-image`
and its `-opacity`/`-position`/`-fit`/`-repeat`. A gradient therefore means
generating a PNG, which is opaque and cancels the blur above; flat + blur was
chosen over that deliberately.

### Neovim (`~/stow/nvim/.config/nvim/lua/config/`)

- `palette.lua` — **single source of truth.** Every other file reads from it:
  `bg bg_dark surface surface_hi selection fg grey grey_dim grey_light violet blue
  aqua green yellow orange red`. Removing or renaming a key breaks the consumers
  below silently. (`bg_dark`, `surface_hi` and `grey_light` currently have no
  consumer — kept for parity with the key set, not because something reads them.)

  It is a **verbatim copy of kanagawa.nvim's own Wave palette**
  (`lua/kanagawa/themes.lua`'s `wave` table, resolved against
  `lua/kanagawa/colors.lua`). That is why `theme.lua` passes no `colors.theme`
  override to `setup()`: there is nothing to pull the plugin onto, the two are
  already the same values and cannot drift.

  The **accents** are Wave, verbatim. The **neutral base** (`bg`, `bg_dark`,
  `surface`, `surface_hi`) is Dragon's `dragonBlack*` grey ladder — the same
  deviation Ghostty makes, for the same reason; see the Terminal section above
  for the rationale and the mapping. `selection` (`#223249`) deliberately stays
  the Wave navy: it is an accent, and `TabLineSel` has to stand out from the grey
  ladder rather than blend into it.

  nvim never paints `bg`, so it exists only for nvim-notify (which rejects
  `"NONE"`) and lualine's section-a foreground. Keep it equal to Ghostty's
  `background`.
- `plugins/theme.lua` — the colorscheme (`rebelot/kanagawa.nvim`, `theme = "wave"`)
  plus **every highlight override in the config that isn't blink-specific**.
  `theme = "wave"` is load-bearing: it is the variant `palette.lua` is copied
  from. Changing it shifts every accent out from under `palette.lua`.

  Overrides go through kanagawa's `overrides(colors)` config function, so there is
  **no `ColorScheme` autocmd here** — it re-runs on every colorscheme load by
  construction. blink is the only place that needs the autocmd; don't add one
  back here.

  Traps, all measured:

  1. `overrides(colors)` does a **shallow `vim.tbl_extend("force", ...)` per
     group** (`lua/kanagawa/highlights/init.lua`), not a full replace like
     tokyonight's `on_highlights` used to. Omitting `bg` in an override table
     leaves the plugin's own opaque value in place — every group that needs to
     see through to the terminal states `bg = "NONE"` explicitly, or it silently
     stays opaque.
  2. `transparent = true` reaches **only `Normal`** — verified against
     `lua/kanagawa/highlights/editor.lua`, the single `config.transparent` check
     in the whole highlight set. There is no `styles.floats`/`sidebars`
     equivalent either. `NormalNC` needs no override — it default-links to
     `Normal` (`dimInactive` stays `false`), so it inherits the transparency.
  3. `DiagnosticVirtualText*` already link to `DiagnosticError`/`Warn`/`Info`/`Hint`
     with no `bg` — unlike tokyonight, nothing to clear here.
  4. Telescope is the one surface tokyonight didn't need help with:
     kanagawa.nvim's own `plugins.lua` gives `TelescopeBorder` a real bg instead
     of linking it to `Normal`, so it needed an explicit override too.

  Cleared by hand because `transparent` doesn't cover them: `LineNr`,
  `CursorLineNr`, `SignColumn`, `FoldColumn`, `Folded`, the `Pmenu` family,
  `NormalFloat` / `FloatBorder` / `FloatTitle` / `FloatFooter`, `TelescopeBorder`,
  `StatusLine` / `StatusLineNC`, the `TabLine` groups, the Noice cmdline groups
  and `InclineNormal` / `InclineNormalNC`.
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
  `ColorScheme`. kanagawa.nvim ships native `BlinkCmp*` highlights of its own
  (linking to `Pmenu` / `NormalFloat` / `FloatBorder` / `PmenuThumb`), so anything
  not listed in `blink.lua` inherits those — and, transitively, `theme.lua`'s
  overrides on the groups they link to.
  Gotcha: a highlight definition consisting only of `bg = "NONE"` collapses to an
  empty group and blink's `default link` wins, so transparency has to come from
  the link target, not from restating it here.
- `plugins/noice.lua` — `background_colour` for nvim-notify.

### Terminal

- `ghostty/.config/ghostty/config` — `background`, `foreground`, `cursor-color`,
  `cursor-text`, `selection-background/foreground`, `palette = 0..15`, plus
  `background-opacity` / `background-blur`.

The 15 **accent** colors come from Omarchy's own `themes/kanagawa/colors.toml`,
run through its `default/themed/ghostty.conf.tpl` mapping, verbatim. This is a
**separate source from `palette.lua`**: Omarchy's own `neovim.lua` theme file
just installs stock `kanagawa.nvim` with no recoloring, so editor and terminal
accents are expected to diverge slightly (e.g. terminal `orange` `#c17158` vs.
nvim's `#ffa066`) — that mismatch is the official behavior, not a bug.

The **neutral base is one deliberate deviation**: Kanagawa **Dragon**'s
`dragonBlack*` grey ladder replaces Wave's purple-tinted `sumiInk*`, because a
dark grey background was wanted. Both ladders live in the same
`kanagawa.nvim/lua/kanagawa/colors.lua`, so these are still official values, not
hand-mixed ones:

| role | Wave (was) | Dragon (now) |
|---|---|---|
| `background`, `cursor-text`, `palette = 0` | `sumiInk3` `#1f1f28` | `dragonBlack2` `#1D1C19` |
| `selection-background` | `sumiInk5` `#363646` | `dragonBlack5` `#393836` |

`dragonBlack2` rather than Dragon's own `bg` (`dragonBlack3` `#181616`) because
`#181616` is L\* 7.5 — near-black, not grey. `#1D1C19` is L\* 10.3, the same
lightness as the One Half Dark base that preceded all this, and it lifts
foreground contrast from 11.26:1 to 11.74:1. Keep `background`, `cursor-text` and
`palette = 0` equal to each other and to `bg` in `palette.lua`.

`bright-black` `#54546d` is the worst pairing against this base at 2.33:1 — it is
`grey_dim`, i.e. line numbers, and that is intentional. Anything below ~2:1 there
would make the gutter vanish.

### Font weight

`font-style = Medium` + `font-thicken = true`. Both were added because the text
read thin; the diagnosis matters, because the obvious explanation is wrong.
Measured stem width of `H` (sampled above the crossbar, 1/1000 em, so comparable
across faces):

| | Regular | Medium | SemiBold | Bold |
|---|---|---|---|---|
| JetBrains Mono | 90 | 99 | 108 | 125 |
| IBM Plex (Blex) | 84 | 97 (`Text`) | — | — |

JetBrains Regular is **7% heavier** than IBM Plex Regular, so the face was never
the thin one. The thinness was a **contrast** effect: Kanagawa's warm beige fg
gave 11.26:1 where the previous theme's near-white on near-black gave 12.75:1.
The grey base above recovers part of it, `Medium` (a real drawn face, so no
synthetic-bold blur) the rest. Bold is left at default so bold text still reads
distinctly heavier (125 vs 99). `font-thicken-strength` (0–255, default 255) is
the dial to back off before disabling `font-thicken`; note **0 means "lightest
thickening", not "none"**.

**Trap: `+validate-config` does not check font style names.** A config with
`font-style = NotARealStyle` exits 0, and Ghostty then silently renders regular —
so validation passing is *not* evidence the weight applied. Verify against the
font's own name table instead: `font-style` must match **nameID 17**
(typographic subfamily) under the family in nameID 16. For this face those are
exactly `Medium` and `Medium Italic` under `JetBrainsMono Nerd Font Mono` —
note nameID 1/2 say `JetBrainsMono NFM Medium` / `Regular`, which is the
misleading pair to avoid matching against.

Font is `JetBrainsMono Nerd Font Mono` (cask `font-jetbrains-mono-nerd-font`) —
the **`Mono`** variant specifically, as the plain and `Propo` builds don't force
icons to single cell width and make lualine/incline misalign. The name matters:
all six families the cask installs are present on this machine —
`JetBrainsMono Nerd Font`, `… Nerd Font Mono`, `… Nerd Font Propo` and the three
`JetBrainsMonoNL` equivalents (NL = no ligatures), per
`system_profiler SPFontsDataType`. **Do not use `ghostty +list-fonts` to conclude
otherwise**: it filters to monospace-flagged faces, so it lists only the two
`Mono` ones, which previously read here as "only the `Mono` builds are installed"
— false, and it would have silently allowed a mis-set `font-family` to resolve to
the proportional build. It exposes a `zero` GSUB feature substituting `zero` → `zero.zero`
(dumped from the GSUB table — its default zero is unslashed and the feature is
what slashes it), so `font-feature = zero` applies.

**Do not reinstate the old "IBM Plex Mono is a wider face than JetBrains Mono at
the same nominal size, so bump font-size down" note.** It was wrong and is now
measured: both faces have an identical `600/1000` em advance (from `hmtx`/`head`),
so 13pt yields a 7.80pt cell either way and the column count is unchanged between
them. The real differences are x-height (JetBrains `0.550` em vs Blex `0.516`, so
JetBrains reads slightly larger at the same size) and line box (`1.32` vs `1.30`).

Glyph coverage was checked, not assumed:

```sh
G=~/Applications/Ghostty.app/Contents/MacOS/ghostty
# E0B0 = powerline (Ghostty internal sprites), EA87/F00D/E62B/F031B = Nerd Font,
# 25CF = incline's modified marker, 2726 = Menlo fallback (see below)
for cp in 0x25CF 0x2726 0xE0B0 0xEA87 0xF00D 0xE62B 0xF031B; do $G +show-face --cp=$cp; done
```

One codepoint is genuinely absent from this face and it is fine: **U+2726**
(resolves to `Menlo` via the fallback — it was starship's `jobs` symbol, and the
current prompt has no `jobs` module at all).

`+show-face` is the authority here — it reports which face actually served the
codepoint, including `"handled by Ghostty's internal sprites"` for powerline.
That matters beyond powerline: **the U+1FB00 legacy-computing block is served by
those sprites too**, so it is font-independent. All 60 distinct legacy-computing
codepoints in smear-cursor's `draw.lua` resolve. The old note claiming the block
was missing from the font, and that this was why
`legacy_computing_symbols_support` stays off, was wrong — the option is simply
untried. Nothing in the font choice constrains it.

Validate with `~/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config`
(exit 0) and `+show-config`. Note `+show-config` omits any value equal to a
built-in default, so e.g. `font-size = 13` will not appear — that is expected, not
a parse failure. `+show-config --default` confirms. A genuinely unknown key fails
validation with `unknown field`; deprecated aliases do not.

Note on checking symlinks: stow uses **directory folding** here, so
`~/.config/ghostty` and `~/.config/nvim` are themselves the
symlinks, and the files inside them are not. `test -L` on the file therefore
reports "not a symlink" even though it is correctly stowed. Verify with
`readlink -f <file>` or by comparing inodes, not by testing the file itself.

### Prompt

- `starship/.config/starship.toml` — Omarchy's official `config/starship.toml`
  with **four deviations**: a two-line prompt, a right-aligned clock (`[fill]` +
  `[time]`), a non-cyan git branch, and `git_branch` truncation. Plus a `$schema`
  line, which is editor tooling, not config. Everything else is Omarchy's, and
  that is verifiable rather than asserted — diff against
  `https://raw.githubusercontent.com/basecamp/omarchy/master/config/starship.toml`
  produces exactly those hunks and nothing else (checked 2026-09-28).

  Unlike nvim/Ghostty, Omarchy ships exactly one Starship config for every theme,
  because every style is a **named ANSI color** (`cyan`, `italic yellow`, ...),
  never a hex — so the prompt re-colors automatically off whatever
  `palette = 0..15` the Ghostty config sets. **Keep it that way**: pinning hexes
  here would mean hand-editing this file on every theme change, which is exactly
  what the previous gruvbox-era config got wrong.

  **Trap: starship silently ignores color names it doesn't recognize** — no error,
  no warning, the text just renders unstyled. The magenta slot is spelled
  `purple`, *not* `magenta`; bright variants are hyphenated (`bright-purple`, not
  `bright_purple`). Both wrong spellings emit zero escape codes. Verified against
  `starship prompt` output, not the docs (which don't enumerate the names).

  **The clock is `$fill`, not `right_format`, and this is load-bearing.**
  Starship's docs are explicit that the right prompt is "a single line following
  the input location" — in zsh `right_format` *is* `RPROMPT`, so it renders next
  to where you type on line 2, not out at the right of the context line. `fill`
  is the documented way to right-align something *above* the input line. Don't
  "simplify" it into `right_format`.

  **`git_branch.truncation_length = 32` is load-bearing too**, not cosmetic.
  `fill` clamps to a 2-space minimum and starship never reflows on overflow, so
  with a real branch name from the dbt repo
  (`feature/IPMS-6912_fix_high_vulnerabilities_dbt_runtime_api`, 58 chars) the
  context line ran to ~83 columns and the terminal soft-wrapped the clock down
  onto the `❯` line. 32 keeps the whole line under ~58 columns and preserves the
  IPMS ticket id, which is the part worth reading.

  Colors, with contrast measured against the **current** `#1D1C19` background:
  `directory` and `character` stay `bold cyan`; `git_branch` is `italic yellow`
  (#c0a36e, 7.06:1, ~124° of hue off cyan so the two are distinct at a glance,
  with italic as a second non-color differentiator); `time` is `purple` (#957fb8,
  4.87:1 — readable but low-saturation, so it reads as a quiet lavender rather
  than a third competing accent; `bright-black` #54546d at 2.33:1 is the swap if
  it still pulls focus). Note `black`/`bright-black` at 1.0:1/2.33:1 and the
  identical `white`/`bright-white` are effectively unusable for distinguishing
  roles.

  These numbers were stale until 2026-09-28: they were computed against the old
  `#1f1f28` Wave background (yellow 6.78:1, purple 4.67:1, `bright-black` 2.23:1)
  and not recomputed when the base moved to `#1D1C19`. **Recompute this paragraph
  whenever `background` changes** — every ratio here depends on it.

  Transient prompt is **not available** — `starship init zsh` in 1.26 ships no
  transience code at all (it's PowerShell/Cmd/Fish/Bash only; zsh support is
  still open upstream). Don't chase it.

  Validate with `starship explain` (prints the resolved escapes per module —
  `1;36` = bold cyan, `3;33` = italic yellow, `35` = purple) and
  `starship timings`. Check line geometry by rendering at an explicit width,
  e.g. `starship prompt -w 80`, from inside the dbt repo.

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
  "BlinkCmpMenu","NoiceCmdlinePopup","InclineNormal","TelescopeNormal","TelescopeBorder","NeoTreeNormal"}
local bad = {}
for _, g in ipairs(core) do
  if vim.api.nvim_get_hl(0, { name = g, link = false }).bg then table.insert(bad, g) end
end
print(#bad == 0 and "OK" or ("STILL OPAQUE: " .. table.concat(bad, ", ")))' +qa
```

Run it a second time with `-c 'colorscheme default'` prepended, then
`-c 'colorscheme kanagawa'` again, to confirm the overrides survive a reload
(`overrides()` re-runs on every `:colorscheme kanagawa`, not on an arbitrary
`ColorScheme` autocmd — see `theme.lua`). `stylua --check .` from
`nvim/.config/nvim` must also be clean.
