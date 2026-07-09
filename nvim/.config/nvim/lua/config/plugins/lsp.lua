-- lua/config/plugins/lsp.lua

local servers = { "pyright", "ruff", "dockerls", "marksman", "bashls", "clangd" }

return {
  -- 🧰 Mason: LSP installer
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
    config = function()
      require("mason").setup()
    end,
  },

  -- 🔌 Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })
    end,
  },

  -- 🧠 LSP Config (new API)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
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

      -- Apply shared capabilities to all servers. mason-lspconfig auto-enables
      -- installed servers (automatic_enable = true), so no manual vim.lsp.enable().
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
      end

      -- LSP keymaps, bound only once a server attaches to the buffer
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
          map("gr", vim.lsp.buf.references, "References")
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
    config = function()
      require("conform").setup({
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
      })
    end,
  },
}

