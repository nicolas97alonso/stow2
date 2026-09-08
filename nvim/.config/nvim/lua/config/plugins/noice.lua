-- 🪄 Enhanced UI: Noice + Notify
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        progress = { enabled = false }, -- silence pyright/mason "analyzing…" spam
        override = {
          -- Only convert_input_to_markdown_lines: on 0.12 nothing in the runtime
          -- calls vim.lsp.util.stylize_markdown any more (it is itself deprecated
          -- until 0.14), so overriding it was a no-op.
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      cmdline = {
        view = "cmdline_popup", -- centered floating box
        format = {
          -- Match the terminal prompt: ">" symbol, same purple
          cmdline = { pattern = "^:", icon = ">", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = ">", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = ">", lang = "regex" },
        },
      },
    })

    vim.notify = require("notify")
    require("notify").setup({
      -- notify refuses "NONE" here, so this is the one place a real bg is required.
      background_colour = require("config.palette").bg,
    })
  end,
}
