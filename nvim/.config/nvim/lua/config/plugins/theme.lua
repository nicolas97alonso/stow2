return {
  "folke/tokyonight.nvim",
  name = "tokyonight",
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "moon", -- "storm", "moon", "night", "day"
      transparent = true, -- keeps the WezTerm transparent blurred background visible!
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
    })

    -- Set the colorscheme
    vim.cmd.colorscheme("tokyonight-moon")

    -- Transparent gutter + floats, neutral (non-purple) line numbers
    local function apply_hl()
      vim.api.nvim_set_hl(0, "LineNr",       { fg = "#737aa2", bg = "NONE" })
      vim.api.nvim_set_hl(0, "LineNrAbove",  { fg = "#737aa2", bg = "NONE" })
      vim.api.nvim_set_hl(0, "LineNrBelow",  { fg = "#737aa2", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff966c", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "SignColumn",   { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder",  { bg = "NONE" })
    end
    apply_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })
  end,
}