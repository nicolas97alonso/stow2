  -- 🌈 Syntax Highlighting & Indentation: Treesitter
  return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function() 
    require("nvim-treesitter.configs").setup({
      -- As a Data Manager, you'll want these specifically:
      ensure_installed = { 
        "lua", "python", "sql", "json", "yaml", "markdown", "bash", "javascript" 
      },
      highlight = {
        enable = true, 
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}
