return {
  "thimc/gruber-darker.nvim",
  priority = 1000,
  config = function()
    require("gruber-darker").setup({
      transparent = true,
    })

    vim.cmd.colorscheme("gruber-darker")

    -- Transparent gutter + floats
    local function apply_hl()
      vim.api.nvim_set_hl(0, "SignColumn",  { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
    end
    apply_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })
  end,
}
