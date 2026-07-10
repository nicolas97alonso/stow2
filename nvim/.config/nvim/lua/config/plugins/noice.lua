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
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
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
      background_colour = "#1F1F28",
    })
  end,
  }