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
          progress = { enabled = true },
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
          view = "cmdline", -- bottom line, not a floating box
          format = {
            -- Match the terminal prompt: ">" symbol, same purple
            cmdline = { pattern = "^:", icon = ">", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = ">", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = ">", lang = "regex" },
          },
        },
      })

    -- Align the cmdline ">" color with the terminal prompt (#957fb8).
    -- Deferred + on ColorScheme so it wins over noice's own scheduled highlights.
    local function cmdline_hl()
      vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#957fb8", bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = "#957fb8", bg = "NONE" })
    end
    vim.schedule(cmdline_hl)
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = function() vim.schedule(cmdline_hl) end })

    vim.notify = require("notify")
    require("notify").setup({
      background_colour = "#000000", -- used for transparency blending
    })
  end,
  }