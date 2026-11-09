-- 🐙 GitHub in Neovim: issues, PRs, reviews (octo.nvim)
return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    -- No nvim-web-devicons: mini.icons already mocks it (see mini.lua).
  },
  opts = {
    picker = "telescope",
    enable_builtin = true, -- bare `:Octo` opens the command list
    -- Which GraphQL fields octo requests (stackEntry, isInMergeQueue, and ~20
    -- PR/issue timeline-event fragments in fragments.lua) is baked in once at
    -- queries.setup()/fragments.setup() time, keyed off this value alone —
    -- not per-repo, not even per-call. Left at "" (= assume github.com) every
    -- one of those fields gets requested against GHES too, and GHES's older
    -- schema rejects them: confirmed both as `gh: Field 'stackEntry' doesn't
    -- exist on type 'PullRequest'` breaking `:Octo pr list`, and the same
    -- fragments.lua fields breaking `:Octo pr edit <n>` on any real PR.
    -- Setting this to the GHE host fixes both (verified against PR #876 on
    -- are-strada-ir-dwh). The cost: gh/init.lua's per-call --hostname routing
    -- checks this value *before* the repo's own git remote, so it also forces
    -- every octo gh call onto GHE even inside a github.com repo (confirmed:
    -- broke `:Octo pr list` in ~/stow with "Could not resolve to a Repository
    -- with the name 'nicolas97alonso/stow2'"). Accepted because stow2 has no
    -- PRs/issues — nothing here uses Octo on github.com. If that changes,
    -- this needs a real per-repo fix (e.g. toggling the option before each
    -- Octo command based on cwd), not a static value.
    github_hostname = "github.developer.allianz.io",
    use_local_fs = true, -- review diffs read the checked-out file, so LSP works in them
  },
  keys = {
    -- <leader>oo, not <leader>o: a mapping on the bare prefix would make every
    -- other key here wait out timeoutlen before firing.
    { "<leader>oo", "<cmd>Octo<cr>", desc = "Octo: command list" },
    { "<leader>oi", "<cmd>Octo issue list<cr>", desc = "Octo: issues" },
    { "<leader>op", "<cmd>Octo pr list<cr>", desc = "Octo: PRs" },
    { "<leader>oP", "<cmd>Octo pr create<cr>", desc = "Octo: create PR" },
    { "<leader>or", "<cmd>Octo review start<cr>", desc = "Octo: start review" },
    { "<leader>oR", "<cmd>Octo review resume<cr>", desc = "Octo: resume review" },
    { "<leader>os", "<cmd>Octo search<cr>", desc = "Octo: search" },
  },
}
