-- 🗂️ File Explorer: oil. A directory is a normal buffer: rename by editing a
-- line, delete with dd, create by typing a new line, then :w applies it.
return {
  "stevearc/oil.nvim",
  -- lazy = false because `nvim <dir>` has to be hijacked before netrw gets it, and
  -- oil's README advises against lazy-loading. As with any non-lazy plugin, the
  -- keymap is set in `init` rather than through lazy's `keys` trigger.
  lazy = false,
  init = function()
    vim.keymap.set("n", "<leader>e", function()
      require("oil").toggle_float(nil, { preview = {} })
    end, { desc = "Toggle file explorer" })
  end,
  opts = {
    columns = {
      "icon",
      { "permissions", highlight = "Type" },
      { "size", highlight = "String" },
      { "mtime", highlight = "Keyword" },
    },
    -- `h` replaces cursor-left inside oil buffers; use b/0 to move within a name.
    keymaps = {
      ["h"] = { "actions.parent", mode = "n" },
      ["q"] = { "actions.close", mode = "n" },
    },
    view_options = { show_hidden = true },
    float = { max_width = 200 },
    -- Renaming a file through oil sends LSP willRenameFiles; this saves the
    -- buffers whose imports the server rewrote instead of leaving them modified.
    lsp_file_methods = { autosave_changes = true },
  },
}
