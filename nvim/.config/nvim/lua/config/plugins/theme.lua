return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      transparent = true, -- keeps the WezTerm transparent blurred background visible!
      dimInactive = false,
      terminalColors = true,
      theme = "wave", -- "wave" (default), "dragon", or "lotus"
    })

    -- Set the colorscheme
    vim.cmd.colorscheme("kanagawa")
  end,
}