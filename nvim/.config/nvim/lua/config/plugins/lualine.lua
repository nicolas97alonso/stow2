-- 📏 Bottom statusline: lualine
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local c = require("config.palette")

    -- Powerline glyphs via byte escapes so the UTF-8 sequence survives writes.
    local sep = {
      arrow_right = "\238\130\176", -- U+E0B0
      arrow_left = "\238\130\178", -- U+E0B2
      thin_right = "\238\130\177", -- U+E0B1
      thin_left = "\238\130\179", -- U+E0B3
    }

    -- Colored mode block, section b subtle bg, section c transparent.
    local theme = {
      normal = {
        a = { fg = c.bg, bg = c.green, gui = "bold" },
        b = { fg = c.fg, bg = c.surface },
        c = { fg = c.fg, bg = "NONE" },
      },
      insert = { a = { fg = c.bg, bg = c.blue, gui = "bold" } },
      visual = { a = { fg = c.bg, bg = c.violet, gui = "bold" } },
      replace = { a = { fg = c.bg, bg = c.red, gui = "bold" } },
      command = { a = { fg = c.bg, bg = c.yellow, gui = "bold" } },
      terminal = { a = { fg = c.bg, bg = c.aqua, gui = "bold" } },
      inactive = {
        a = { fg = c.grey, bg = "NONE" },
        b = { fg = c.grey, bg = "NONE" },
        c = { fg = c.grey, bg = "NONE" },
      },
    }

    require("lualine").setup({
      options = {
        theme = theme,
        globalstatus = true,
        -- NOT `disabled_filetypes`: with globalstatus there is one bar for the
        -- whole editor, and lualine returns nil for it when the focused window's
        -- filetype is disabled -- which blanks the statusline editor-wide the
        -- moment the tree takes focus. `extensions` is the globalstatus-safe way
        -- to special-case a filetype.
        section_separators = { left = sep.arrow_right, right = sep.arrow_left },
        component_separators = { left = sep.thin_right, right = sep.thin_left },
      },
      extensions = { "neo-tree", "fugitive", "lazy", "mason" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        -- No `encoding` / `fileformat`: both are permanent constants here
        -- (utf-8 / unix), so they were two segments of pure noise.
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
