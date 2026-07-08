-- 📏 Bottom statusline: lualine
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        -- 🎨 Cyberdream lualine theme (transparent bg, detects palette)
        theme = "cyberdream",

        -- Flat separators: rounded "bubble" caps render as floating
        -- half-circles on a transparent background, so keep it clean.
        section_separators = '',
        component_separators = { left = '', right = '' },

        globalstatus = true,
        disabled_filetypes = { statusline = { "alpha", "dashboard" } },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      }
    })
  end,
}
