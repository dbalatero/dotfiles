local null_ls = require("null-ls")

local ignorePrettierRules = function(diagnostic)
  return diagnostic.code ~= "prettier/prettier"
end

local hasEslintConfig = function(utils)
  return utils.root_has_file({
    ".eslintrc",
    ".eslintrc.json",
    ".eslintrc.js"
  })
end

local hasPrettierConfig = function(utils)
  return utils.root_has_file({
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.js",
    ".prettierrc.toml",
    ".prettierrc.yml",
    ".prettierrc.yaml",
  })
end

local eslintConfig = {
  condition = hasEslintConfig,
  filter = ignorePrettierRules,
}

null_ls.setup({
  -- For :NullLsLog support
  -- debug = true,
  root_dir = require("null-ls.utils").root_pattern(
    ".git",
    "Gemfile.lock",
    "package.json"
  ),
  sources = {
    -- prettier
    -- todo get prettierd configured and setup
    null_ls.builtins.formatting.prettier.with({
      condition = hasPrettierConfig,
      -- env = {
      --   -- PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
      -- },
      -- Always use the local prettier, especially when prettier is pointing
      -- at a feature branch or something weird.
      only_local = "node_modules/.bin",
    }),

    -- eslint
    -- null_ls.builtins.code_actions.eslint_d.with(eslintConfig),
    -- null_ls.builtins.diagnostics.eslint_d.with(eslintConfig),
  }
})
