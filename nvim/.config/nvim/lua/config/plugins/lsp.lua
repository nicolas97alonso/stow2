-- lua/config/plugins/lsp.lua

return {
  -- 🧰 Mason: LSP installer
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- 🔌 Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "ruff", "dockerls", "marksman", "bashls" },
      })
    end,
  },

  -- 🧠 LSP Config (new API)
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("pyright", {
        capabilities = capabilities,
      })
      for _, server in ipairs({ "ruff", "dockerls", "marksman", "bashls" }) do
        vim.lsp.config(server, { capabilities = capabilities })
      end
      vim.lsp.enable({ "pyright", "ruff", "dockerls", "marksman", "bashls" })

      -- LSP keymaps, bound only once a server attaches to the buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
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
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
      })
    end,
  },
}

