  -- 🤖 Autocompletion: nvim-cmp
return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = { menu = 50, abbr = 50 },
            ellipsis_char = "…",
            show_labelDetails = true,
            menu = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            },
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["jj"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Transparent-friendly menu: only the selected row carries a solid bg.
      local function cmp_highlights()
        local c = require("config.palette")
        local set = vim.api.nvim_set_hl
        set(0, "Pmenu",       { fg = c.fg,   bg = "NONE" })
        set(0, "NormalFloat", { fg = c.fg,   bg = "NONE" })
        set(0, "FloatBorder", { fg = c.grey, bg = "NONE" })
        set(0, "PmenuSel",  { fg = c.bg, bg = c.violet, bold = true })
        set(0, "PmenuSbar", { bg = "NONE" })
        set(0, "PmenuThumb",{ bg = c.surface })
        set(0, "CmpItemAbbr",           { fg = c.fg,   bg = "NONE" })
        set(0, "CmpItemAbbrDeprecated", { fg = c.grey, bg = "NONE", strikethrough = true })
        set(0, "CmpItemAbbrMatch",      { fg = c.blue, bg = "NONE", bold = true })
        set(0, "CmpItemAbbrMatchFuzzy", { fg = c.blue, bg = "NONE", bold = true })
        set(0, "CmpItemMenu",           { fg = c.grey, bg = "NONE", italic = true })
        set(0, "CmpItemKind",         { fg = c.violet, bg = "NONE" })
        set(0, "CmpItemKindFunction", { fg = c.violet, bg = "NONE" })
        set(0, "CmpItemKindMethod",   { fg = c.violet, bg = "NONE" })
        set(0, "CmpItemKindVariable", { fg = c.blue,   bg = "NONE" })
        set(0, "CmpItemKindClass",    { fg = c.yellow, bg = "NONE" })
        set(0, "CmpItemKindInterface",{ fg = c.yellow, bg = "NONE" })
        set(0, "CmpItemKindKeyword",  { fg = c.red,    bg = "NONE" })
        set(0, "CmpItemKindSnippet",  { fg = c.green,  bg = "NONE" })
        set(0, "CmpItemKindText",     { fg = c.green,  bg = "NONE" })
        set(0, "CmpItemKindField",    { fg = c.aqua,   bg = "NONE" })
        set(0, "CmpItemKindProperty", { fg = c.aqua,   bg = "NONE" })
      end
      cmp_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = cmp_highlights })
    end,
  }
