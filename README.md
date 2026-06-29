# dotfiles (stow)

GNU stow packages. From `~/stow`, run `stow <pkg>` to symlink a package into place.

| Package | Symlinks to |
|---|---|
| `nvim` | `~/.config/nvim` |
| `oh-my-posh` | `~/.config/oh-my-posh/clean.omp.json` |
| `wezterm` | `~/.config/wezterm/wezterm.lua` |
| `zsh` | `~/.zshrc` (see below) |

```sh
cd ~/stow && stow nvim oh-my-posh wezterm
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

- **Oh My Posh prompt** (required — this is the prompt):
  ```sh
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/clean.omp.json)"
  ```
- **zsh plugins** — source autosuggestions + syntax-highlighting. Path depends on
  how they were installed:
  - Homebrew: `source <brew-prefix>/share/zsh-autosuggestions/zsh-autosuggestions.zsh`
    and `.../zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`
  - oh-my-zsh: `source ~/.oh-my-zsh/custom/plugins/.../...zsh`

## Fonts

WezTerm uses **Hack Nerd Font** (falls back to JetBrains Mono). Install:

```sh
brew install --cask font-hack-nerd-font
```
