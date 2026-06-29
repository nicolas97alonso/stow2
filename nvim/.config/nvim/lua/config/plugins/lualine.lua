-- 📏 Bottom statusline: lualine (Catppuccin Edition - Bubbles)
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, 
  config = function()
    require("lualine").setup({
      options = {
        -- 🎨 Theme matches your Kanagawa setup
        theme = "kanagawa",
        
        -- 🫧 BUBBLE SEPARATORS:
        -- Using rounded ends to match your Oh My Posh theme
        section_separators = { left = '', right = '' }, 
        component_separators = { left = '', right = '' }, -- Subtle rounded dividers
        
        globalstatus = true,
        disabled_filetypes = { statusline = { "alpha", "dashboard" } },
      },
      -- Keeping your layout simple and sharp, but with rounded edges
      sections = {
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } }
      }
    })
  end,
}