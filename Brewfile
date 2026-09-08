# Dependencies this repo's configs actually need. `brew bundle check --verbose`
# from ~/stow lists what's missing; `brew bundle install` installs it.
#
# Deliberately NOT a dump of `brew list` -- work tools (azure-cli, dotnet,
# msodbcsql18, sqlfluff, ...) are per-project and don't belong to the dotfiles.
#
# This file exists because ripgrep was missing for an unknown length of time and
# nothing noticed: telescope's <leader>fg silently did nothing, because a missing
# optional dependency of a plugin isn't an error anywhere.

# Terminal + prompt + shell
cask "ghostty"
cask "font-jetbrains-mono-nerd-font" # font-family in ghostty/config; Nerd Font glyphs for lualine/mini.icons/blink
brew "starship"                      # reads starship/.config/starship.toml
brew "zsh-autosuggestions"           # sourced by .zshrc section 9
brew "zsh-syntax-highlighting"       # sourced by .zshrc section 9, must be last
brew "stow"                          # how any of this gets symlinked into place

# Editor
brew "neovim"
brew "stylua" # conform's lua formatter; also formats this repo (see CLAUDE.md)
brew "node"   # markdown-preview.nvim has no prebuilt binary, so it runs `node app/index.js`

# Required by the nvim config, not optional
brew "ripgrep" # telescope live_grep (<leader>fg) is dead without it
brew "fd"      # telescope find_files and FZF_DEFAULT_COMMAND; falls back to `find` otherwise

# Shell tooling referenced by .zshrc
brew "fzf"   # section 7 + the nvimf function
brew "zoxide" # section 7
brew "bat"   # `cat` alias and MANPAGER
brew "eza"   # ls/ll/la/lt aliases
