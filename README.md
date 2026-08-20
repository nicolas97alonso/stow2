# dotfiles (stow)

GNU stow packages. From `~/stow`, run `stow <pkg>` to symlink a package into place.

| Package | Symlinks to |
|---|---|
| `nvim` | `~/.config/nvim` |
| `starship` | `~/.config/starship.toml` |
| `wezterm` | `~/.config/wezterm/wezterm.lua` |
| `zsh` | `~/.zshrc` (see below) |

```sh
cd ~/stow && stow nvim starship wezterm
```

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

WezTerm uses **Google Sans Code Nerd Font Mono** (falls back to Symbols Nerd Font
Mono, then Menlo). Install:

```sh
brew install --cask font-googlesanscode-nerd-font
```
