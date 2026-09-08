-- lua/config/plugins/lsp.lua

-- nvim-lspconfig config name -> Mason registry package name. One table so the
-- two can't drift: vim.lsp.enable() takes the lspconfig name, while
-- mason-tool-installer takes the registry name, and they are often different
-- (dockerls / dockerfile-language-server, lua_ls / lua-language-server, ...).
local servers = {
  pyright = "pyright",
  ruff = "ruff",
  dockerls = "dockerfile-language-server",
  marksman = "marksman",
  bashls = "bash-language-server",
  clangd = "clangd",
  lua_ls = "lua-language-server",
  yamlls = "yaml-language-server",
  jsonls = "json-lsp",
}

-- Formatters conform shells out to. They are NOT servers and must never be
-- passed to vim.lsp.enable(): nvim-lspconfig ships an lsp/stylua.lua, so
-- anything that auto-enables installed Mason packages will happily start stylua
-- as a second LSP client on every Lua buffer.
local formatters = { "black", "stylua", "shfmt", "clang-format" }

return {
  -- 🧰 Mason: installs the binaries and prepends its bin dir to PATH
  {
    "mason-org/mason.nvim",
    lazy = true, -- pulled in as a dependency below; nothing needs it eagerly
    opts = {},
  },

  -- 🛠️ Mason tool installer: one ensure_installed for servers *and* formatters.
  -- This replaces mason-lspconfig entirely. mason-lspconfig cost 19ms (a third
  -- of all plugin load time), and its automatic_enable = true was what leaked
  -- stylua into the LSP client list.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = vim.list_extend(vim.tbl_values(servers), formatters),
    },
  },

  -- 🧠 LSP. nvim-lspconfig is used purely as the `lsp/` config directory that
  -- vim.lsp.config/vim.lsp.enable read from; none of its old framework API.
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      "mason-org/mason.nvim",
      -- Data-only: the SchemaStore catalog as a Lua table, for jsonls.
      { "b0o/schemastore.nvim", lazy = true },
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = false, -- no inline text; underline only (<leader>d for the message)
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
        float = { border = "rounded", source = true },
      })

      -- "*" covers every server.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Without this, lua_ls flags `vim` as an undefined global 9 times in this
      -- very config. The VIMRUNTIME library is what makes vim.api/vim.fn
      -- completion and signatures work; deliberately just VIMRUNTIME rather than
      -- the whole nvim_get_runtime_file() set, which pulls in every plugin and
      -- makes the first Lua buffer noticeably slow.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = { vim.env.VIMRUNTIME .. "/lua" },
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      -- yamlls bundles prettier and advertises documentFormattingProvider out of
      -- the box. Running it at its defaults over this machine's 663 project .yml
      -- files rewrites 481 of them substantively -- dbt_project.yml alone loses
      -- its whole aligned-comment block. So: validation and completion yes,
      -- formatting no. No schemaStore or keyOrdering settings here; yamlls
      -- already fetches the catalog itself and keyOrdering already defaults off.
      vim.lsp.config("yamlls", {
        settings = { yaml = { format = { enable = false } } },
      })

      -- Two non-obvious things about jsonls:
      --  1. vscode-json-language-server reports documentFormattingProvider =
      --     false unless provideFormatter is passed, so JSON formatting is
      --     silently a no-op without this.
      --  2. Unlike yamlls it ships no schema catalog of its own, which is what
      --     schemastore.nvim is for.
      vim.lsp.config("jsonls", {
        init_options = { provideFormatter = true },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.lsp.enable(vim.tbl_keys(servers))

      -- LSP keymaps, bound only once a server attaches to the buffer.
      -- Neovim 0.12 already provides K, grn, gra, grr, gri, grt, [d and ]d;
      -- these are the shorter aliases. Note there is deliberately no bare "gr" --
      -- it would shadow the built-in gr* prefix and stall every one of them on
      -- timeoutlen.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
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

          -- Inlay hints are negotiated in the capabilities above but off by
          -- default in Neovim, so they were simply never rendered. Off at attach
          -- and toggled per buffer, because they shift text horizontally.
          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>ci", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
            end, "Toggle inlay hints")
          end
        end,
      })
    end,
  },

  -- 🧼 Formatter: conform.nvim (format on save)
  --
  -- No `sql` entry, deliberately, and it is the most consequential omission in
  -- this file. Measured against the real dbt project:
  --   * sqlfluff cannot template these models at all -- 25/25 fail with
  --     "Undefined jinja template variable", because resolving project macros
  --     needs `templater = dbt`, and the brew sqlfluff only offers
  --     raw/jinja/python/placeholder.
  --   * shandy-sqlfmt does handle the Jinja, but would rewrite 699 of 748 files:
  --     it lowercases every identifier and moves leading commas to trailing,
  --     which is the exact opposite of the project's own .sqlfluff
  --     (extended_capitalisation_policy = pascal, line_position = leading).
  --     8 macro files fail its token-safety check outright.
  -- Also note `sqlfmt` is ambiguous on this machine: ~/homebrew/bin/sqlfmt is the
  -- Go sqlfum.pt and shadows the pipx shandy-sqlfmt, so a bare "sqlfmt" here
  -- would run the wrong binary. Any SQL formatting has to go through
  -- sqlfluff-templater-dbt inside the project venv, not through this file.
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          -- lsp_format = "fallback" only here, never on save: this is where
          -- jsonls' formatter is reachable on purpose rather than by accident.
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Format buffer/selection",
      },
    },
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
        -- "never", NOT "fallback". With "fallback" every filetype that has an
        -- LSP but no entry above gets formatted by that LSP on save -- which the
        -- moment yamlls was added would have enrolled 663 dbt .yml files into
        -- prettier-on-save. Explicit formatters only; <leader>cf is the opt-in.
        lsp_format = "never",
      },
    },
  },
}
