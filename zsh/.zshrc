# 1. INSTANT PROMPT (Keep at the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. PATHS & EXPORTS
export PATH="/opt/homebrew/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

#3. Oh my posh
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/clean.omp.json)"

# 5. ALIASES
alias repos="cd /Users/nicolasalonso/Desktop/code"
alias zoo="cd /Users/nicolasalonso/Desktop/code/cd_zoo/zoo_de"
alias viconfig="nvim ~/.config/nvim/init.lua"
alias zshconfig="nvim ~/.zshrc"
alias home="cd ~"
alias ft="cd /Users/nicolasalonso/Desktop/code/football-pipeline"
export PATH=$HOME/.local/bin:$PATH

# Plugins
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
