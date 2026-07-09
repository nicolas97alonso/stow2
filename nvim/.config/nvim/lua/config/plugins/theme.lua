return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      theme = "wave",
      transparent = true,
      dimInactive = false,
      commentStyle = { italic = true },
    })

    vim.cmd.colorscheme("kanagawa")

    -- Keep the gutter and floats transparent (kanagawa's transparent mode
    -- leaves a few of these with a background).
    local function apply_hl()
      local c = require("config.palette")
      vim.api.nvim_set_hl(0, "SignColumn",   { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder",  { bg = "NONE" })
      -- Kill the gutter/line-number backgrounds kanagawa leaves in transparent mode
      vim.api.nvim_set_hl(0, "LineNr",       { fg = c.grey,   bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.orange, bg = "NONE", bold = true })
      -- Cmdline (noice) fully transparent
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup",       { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = c.blue, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdline",            { bg = "NONE" })
    end
    apply_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })
  end,
}
