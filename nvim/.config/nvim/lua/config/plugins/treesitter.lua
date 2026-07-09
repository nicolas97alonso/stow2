-- 🌈 Syntax Highlighting & Indentation: Treesitter (main branch — required for Neovim 0.12+)
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    local parsers = {
      "lua", "python", "sql", "json", "yaml", "markdown", "markdown_inline",
      "bash", "javascript", "dockerfile", "groovy", "c",
    }
    ts.install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua", "python", "sql", "json", "yaml", "markdown",
        "sh", "bash", "javascript", "dockerfile", "groovy", "c",
      },
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
