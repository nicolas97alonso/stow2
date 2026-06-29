# -----------------------------
# 1. ZSH Plugins (via Homebrew)
# -----------------------------
source /Users/nicolas.alonso/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /Users/nicolas.alonso/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -----------------------------
# 2. PATHS
# -----------------------------
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Install Homebrew casks (GUI apps) to ~/Applications — no sudo on this laptop,
# so brew can't write the default /Applications.
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# -----------------------------
# 3. ALIASES
# -----------------------------
alias desktop="cd ~/Desktop"
alias repos="cd ~/code"
alias ir="cd ~/code/all/are-strada-ir-dwh/"
alias stu="cd ~/code/nico/studies/"
alias home="cd ~"
alias fut="cd ~/code/projects/de-football/"

# -----------------------------
# 4. Colors
# -----------------------------
export LS_COLORS="di=1;34:fi=0;37"

# -----------------------------
# 5. Prompt — Oh My Posh
# -----------------------------
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/clean.omp.json)"

# -----------------------------
# 6. Tools & shortcuts
# -----------------------------
# ADF Monitor — morning digest (19:00 yesterday → 08:00 today, Europe/Madrid)
alias adf='cd ~/code/adf_monitor && uv run monitor.py yesterday'
alias data-sync="~/scripts/data_sync.sh"
alias data-pull="~/scripts/data_pull.sh"
alias pyclean='find . -type d -name "__pycache__" -exec rm -rf {} +'

export DYLD_LIBRARY_PATH=/Users/nicolas.alonso/homebrew/lib${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}

# sqlnico — local Azure SQL query tool (https://localhost:4123)
alias sqlnico='/Users/nicolas.alonso/code/projects/sqlnico/start.sh'
