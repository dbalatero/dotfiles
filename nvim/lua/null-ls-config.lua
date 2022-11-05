local null_ls = require("null-ls")
local utils = require("null-ls.utils")

null_ls.setup({
  root_dir = utils.root_pattern(
    ".git",
    "Gemfile.lock",
    "package.json",
  ),
  sources = {
    -- eslint
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.eslint,

    -- prettier
    null_ls.builtins.formatting.prettier,
  }
})
