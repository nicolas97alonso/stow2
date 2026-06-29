-- 🛠️ dbt: syntax overlay (SQL + Jinja) + run/test/compile, ref/source navigation
return {
  "PedramNavid/dbtpal",
  ft = { "sql", "md", "yaml" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("dbtpal").setup({
      path_to_dbt = "dbt",
      path_to_dbt_project = "",
      path_to_dbt_profiles_dir = "",
      extended_path_search = true,
      protect_compiled_files = true,
    })
    require("telescope").load_extension("dbtpal")

    vim.keymap.set("n", "<leader>drf", require("dbtpal").run, { desc = "dbt run (file)" })
    vim.keymap.set("n", "<leader>drp", require("dbtpal").run_all, { desc = "dbt run all" })
    vim.keymap.set("n", "<leader>dt", require("dbtpal").test, { desc = "dbt test" })
    vim.keymap.set("n", "<leader>dm", require("telescope").extensions.dbtpal.models, { desc = "dbt models" })
  end,
}
