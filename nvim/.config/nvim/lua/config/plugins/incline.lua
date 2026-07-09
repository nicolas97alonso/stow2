-- 🪟 Floating per-window filename + diagnostics (companion to globalstatus lualine)
return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  config = function()
    local c = require("config.palette")

    require("incline").setup({
      window = {
        margin = { horizontal = 1, vertical = 1 },
        padding = 1,
        placement = { horizontal = "right", vertical = "top" },
      },
      hide = {
        cursorline = true,
      },
      highlight = {
        groups = {
          InclineNormal   = { guifg = c.fg,   guibg = "None" },
          InclineNormalNC = { guifg = c.grey, guibg = "None" },
        },
      },
      render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
        local modified = vim.bo[props.buf].modified

        local icon, icon_hl = require("mini.icons").get("file", filename)

        local diag_colors = {
          [vim.diagnostic.severity.ERROR] = c.red,
          [vim.diagnostic.severity.WARN]  = c.yellow,
          [vim.diagnostic.severity.INFO]  = c.blue,
          [vim.diagnostic.severity.HINT]  = c.aqua,
        }
        local diag_signs = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN]  = " ",
          [vim.diagnostic.severity.INFO]  = " ",
          [vim.diagnostic.severity.HINT]  = " ",
        }

        local res = { { icon, guifg = icon_hl }, " ", { filename } }
        if modified then
          table.insert(res, { " ●", guifg = c.orange })
        end

        for severity, hl in pairs(diag_colors) do
          local n = #vim.diagnostic.get(props.buf, { severity = severity })
          if n > 0 then
            table.insert(res, { "  " .. diag_signs[severity] .. n, guifg = hl })
          end
        end

        return res
      end,
    })
  end,
}
