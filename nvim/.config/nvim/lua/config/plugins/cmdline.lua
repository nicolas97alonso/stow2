-- Cmdline + messages: Neovim's built-in ui2 (`:help ui2`, experimental in 0.12),
-- with tiny-cmdline moving the `:` cmdline into a centered float the way noice's
-- cmdline_popup did. `/` and `?` stay at the bottom, as noice's bottom_search had
-- them. Deleting this file reverts to the stock cmdline.
return {
  "rachartier/tiny-cmdline.nvim",
  lazy = false,
  init = function()
    -- tiny-cmdline leaves the cmdline at the bottom unless cmdheight is already 0
    -- when it initializes, hence `init` and not `config`.
    vim.o.cmdheight = 0
    require("vim._core.ui2").enable({
      -- With cmdheight = 0 the default "cmd" target has no row to print into;
      -- "msg" is ui2's ephemeral float meant for exactly that case.
      msg = { targets = "msg" },
    })
  end,
  config = function()
    local tiny = require("tiny-cmdline")
    tiny.setup({
      -- blink.cmp places its own cmdline menu; this moves it under the float.
      on_reposition = tiny.adapters.blink,
    })
  end,
}
