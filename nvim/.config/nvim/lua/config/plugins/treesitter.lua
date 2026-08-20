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

    -- Only hit the network on a cold config; ts.install() otherwise ran on every start.
    local installed = ts.get_installed()
    local missing = vim.tbl_filter(function(p)
      return not vim.tbl_contains(installed, p)
    end, parsers)
    if #missing > 0 then
      ts.install(missing)
    end

    -- Start on any filetype that has a parser; the pcall handles the ones that
    -- don't, so this no longer needs a hardcoded list to keep in sync.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
