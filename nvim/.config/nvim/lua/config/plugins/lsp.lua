-- lua/config/plugins/lsp.lua

local servers = { "pyright", "ruff", "dockerls", "marksman", "bashls", "clangd", "lua_ls" }

return {
  -- 🧰 Mason: LSP + tool installer
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- 🔌 Mason LSP Config
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = servers,
    },
  },

  -- 🧠 LSP Config (new API)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.diagnostic.config({
        virtual_text = false,        -- no inline text; underline only (<leader>d for the message)
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "",
          },
        },
        float = { border = "rounded", source = true },
      })

      -- "*" covers every server, including anything Mason auto-enables that
      -- isn't in the list above. mason-lspconfig has automatic_enable = true,
      -- so no manual vim.lsp.enable() is needed.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- LSP keymaps, bound only once a server attaches to the buffer.
      -- Neovim 0.11+ already provides K, grn, gra, grr, gri and grt; these are
      -- the shorter aliases. Note there is deliberately no bare "gr" — it would
      -- shadow the built-in gr* prefix and stall every one of them on timeoutlen.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- Let pyright own hover; ruff's hover would duplicate it.
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
          end
          map("gd", vim.lsp.buf.definition, "Goto Definition")
          map("gR", vim.lsp.buf.references, "References")
          map("gi", vim.lsp.buf.implementation, "Goto Implementation")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev Diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next Diagnostic")
        end,
      })
    end,
  },

  -- 🧼 Formatter: conform.nvim (format on save)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        python = { "black" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        c = { "clang-format" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    },
  },
}
