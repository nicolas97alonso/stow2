# dotfiles (stow)

GNU stow packages. From `~/stow`, run `stow <pkg>` to symlink a package into place.

| Package | Symlinks to |
|---|---|
| `ghostty` | `~/.config/ghostty/config` |
| `nvim` | `~/.config/nvim` |
| `starship` | `~/.config/starship.toml` |
| `zsh` | `~/.zshrc` (see below) |

```sh
cd ~/stow && stow ghostty nvim starship
```

## Dependencies

`Brewfile` tracks everything the configs actually need. On a new machine, or to
find out what drifted on this one:

```sh
cd ~/stow
brew bundle check --verbose   # what's missing
brew bundle install           # install it
```

Worth running occasionally, not just on setup: a missing optional dependency of an
nvim plugin is not an error anywhere. `ripgrep` went missing at some point and the
only symptom was telescope's `<leader>fg` quietly doing nothing.

## zsh is per-machine

`.zshrc` is **not** tracked (gitignored) — work and personal machines differ in
Homebrew prefix, username, and aliases. The repo ships `zsh/.zshrc.example` as a
starting point.

```sh
cp ~/stow/zsh/.zshrc.example ~/stow/zsh/.zshrc
# edit ~/stow/zsh/.zshrc for this machine, then:
cd ~/stow && stow zsh
```

### Lines every machine's `.zshrc` needs

- **Starship prompt** (required — this is the prompt). `.zshrc` is not tracked, so
  this line has to be added by hand on every new machine:
  ```sh
  command -v starship >/dev/null && eval "$(starship init zsh)"
  ```
  Install the binary first (`brew install starship`); it reads
  `~/.config/starship.toml`, which the `starship` package above provides.
- **zsh plugins** — source autosuggestions + syntax-highlighting. Path depends on
  how they were installed:
  - Homebrew: `source <brew-prefix>/share/zsh-autosuggestions/zsh-autosuggestions.zsh`
    and `.../zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`
  - oh-my-zsh: `source ~/.oh-my-zsh/custom/plugins/.../...zsh`

## Fonts

Ghostty uses **JetBrainsMono Nerd Font Mono** (falls back to Menlo). Install:

```sh
brew install --cask font-jetbrains-mono-nerd-font
```
