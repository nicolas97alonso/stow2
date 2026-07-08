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

    -- Align the cmdline ">" color with the cyberdream purple.
    -- Deferred + on ColorScheme so it wins over noice's own scheduled highlights.
    local function cmdline_hl()
      local palette = require("cyberdream.colors")
      local variant = require("cyberdream.config").options.variant
      local colors = (variant == "light" or (variant == "auto" and vim.o.background == "light"))
        and palette.light or palette.default
      vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = colors.purple, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = colors.purple, bg = "NONE" })
    end
    vim.schedule(cmdline_hl)
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = function() vim.schedule(cmdline_hl) end })

    vim.notify = require("notify")
    require("notify").setup({
      background_colour = "#000000", -- used for transparency blending
    })
  end,
  }