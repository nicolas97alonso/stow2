-- 🌈 Syntax Highlighting & Indentation: Treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "python", "sql", "json", "yaml", "markdown", "markdown_inline",
        "bash", "javascript", "jinja", "jinja_inline", "dockerfile", "groovy",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}
