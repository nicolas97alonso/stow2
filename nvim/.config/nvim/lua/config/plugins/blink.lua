-- 🤖 Autocompletion: blink.cmp
-- Replaces nvim-cmp + cmp-nvim-lsp + cmp-buffer + cmp-path + cmp_luasnip
-- + LuaSnip + lspkind: fuzzy matching, snippets and kind icons are built in.
return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-k>"] = { "show_documentation", "hide_documentation", "fallback" },
    },
    appearance = {
      -- GoogleSansCode NFM is a Nerd Font *Mono* build, so icons are single-width.
      nerd_font_variant = "mono",
    },
    completion = {
      menu = {
        border = "rounded",
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
        },
      },
      documentation = {
        auto_show = false, -- toggle with <C-k>
        window = { border = "rounded" },
      },
      ghost_text = { enabled = true },
    },
    sources = {
      default = { "lsp", "snippets", "path", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
  config = function(_, opts)
    require("blink.cmp").setup(opts)

    -- Transparent-friendly menu: only the selected row carries a solid bg.
    local function blink_highlights()
      local c = require("config.palette")
      local set = vim.api.nvim_set_hl
      set(0, "BlinkCmpMenu", { fg = c.fg, bg = "NONE" })
      set(0, "BlinkCmpMenuBorder", { fg = c.grey, bg = "NONE" })
      set(0, "BlinkCmpMenuSelection", { fg = c.bg, bg = c.violet, bold = true })
      set(0, "BlinkCmpScrollBarThumb", { bg = c.surface })
      set(0, "BlinkCmpScrollBarGutter", { bg = "NONE" })
      set(0, "BlinkCmpDoc", { fg = c.fg, bg = "NONE" })
      set(0, "BlinkCmpDocBorder", { fg = c.grey, bg = "NONE" })
      set(0, "BlinkCmpDocSeparator", { fg = c.grey, bg = "NONE" })
      set(0, "BlinkCmpDocCursorLine", { bg = c.surface })
      set(0, "BlinkCmpSignatureHelp", { fg = c.fg, bg = "NONE" })
      set(0, "BlinkCmpSignatureHelpBorder", { fg = c.grey, bg = "NONE" })
      set(0, "BlinkCmpSignatureHelpActiveParameter", { fg = c.orange, bold = true })
      set(0, "BlinkCmpGhostText", { fg = c.grey, bg = "NONE", italic = true })
      set(0, "BlinkCmpLabel", { fg = c.fg, bg = "NONE" })
      set(0, "BlinkCmpLabelDeprecated", { fg = c.grey, bg = "NONE", strikethrough = true })
      set(0, "BlinkCmpLabelMatch", { fg = c.blue, bg = "NONE", bold = true })
      set(0, "BlinkCmpLabelDetail", { fg = c.grey, bg = "NONE" })
      set(0, "BlinkCmpLabelDescription", { fg = c.grey, bg = "NONE" })
      set(0, "BlinkCmpSource", { fg = c.grey, bg = "NONE", italic = true })
      set(0, "BlinkCmpKind", { fg = c.violet, bg = "NONE" })
      set(0, "BlinkCmpKindFunction", { fg = c.violet, bg = "NONE" })
      set(0, "BlinkCmpKindMethod", { fg = c.violet, bg = "NONE" })
      set(0, "BlinkCmpKindVariable", { fg = c.blue, bg = "NONE" })
      set(0, "BlinkCmpKindClass", { fg = c.yellow, bg = "NONE" })
      set(0, "BlinkCmpKindInterface", { fg = c.yellow, bg = "NONE" })
      set(0, "BlinkCmpKindKeyword", { fg = c.red, bg = "NONE" })
      set(0, "BlinkCmpKindSnippet", { fg = c.green, bg = "NONE" })
      set(0, "BlinkCmpKindText", { fg = c.green, bg = "NONE" })
      set(0, "BlinkCmpKindField", { fg = c.aqua, bg = "NONE" })
      set(0, "BlinkCmpKindProperty", { fg = c.aqua, bg = "NONE" })
    end
    blink_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = blink_highlights })
  end,
}
