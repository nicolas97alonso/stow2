return {
  "scottmckendry/cyberdream.nvim",
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      transparent = true,
    })

    vim.cmd.colorscheme("cyberdream")

    -- Transparent gutter + floats, plus more visible line numbers
    local function apply_hl()
      local c = require("cyberdream.colors").default
      vim.api.nvim_set_hl(0, "SignColumn",  { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
      -- Brighter relative numbers, bold + accented current line number
      vim.api.nvim_set_hl(0, "LineNr",       { fg = c.grey, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.yellow, bg = "NONE", bold = true })
    end
    apply_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })
  end,
}
