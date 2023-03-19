local null_ls = require('null-ls')
local shared = require('config.lsp.shared')
local rubyfmt_formatter = require('config.lsp.support.formatters.rubyfmt')

local ignorePrettierRules = function(diagnostic)
  return diagnostic.code ~= 'prettier/prettier'
end

local hasEslintConfig = function(utils)
  return utils.root_has_file({
    '.eslintrc',
    '.eslintrc.json',
    '.eslintrc.js',
  })
end

local hasPrettierConfig = function(utils)
  return utils.root_has_file({
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.js',
    '.prettierrc.toml',
    '.prettierrc.yml',
    '.prettierrc.yaml',
  })
end

local eslintConfig = {
  condition = hasEslintConfig,
  filter = ignorePrettierRules,
}

null_ls.setup({
  -- For :NullLsLog support
  -- debug = true,
  capabilities = shared.default_capabilities,
  on_attach = shared.on_attach,
  root_dir = require('null-ls.utils').root_pattern('Gemfile.lock', 'package.json', '.git'),
  sources = {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │     Lua                                                  │
    --  ╰──────────────────────────────────────────────────────────╯
    null_ls.builtins.formatting.stylua,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │     Markdown                                             │
    --  ╰──────────────────────────────────────────────────────────╯
    -- null_ls.builtins.diagnostics.write_good,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │     Ruby                                                 │
    --  ╰──────────────────────────────────────────────────────────╯
    rubyfmt_formatter,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │     TypeScript                                           │
    --  ╰──────────────────────────────────────────────────────────╯
    null_ls.builtins.formatting.prettierd.with({
      condition = hasPrettierConfig,
      env = {
        -- Always use the local prettier in node_modules, especially when prettier is pointing
        -- at a feature branch or something weird.
        PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
      },
    }),

    null_ls.builtins.code_actions.eslint_d.with(eslintConfig),
    null_ls.builtins.diagnostics.eslint_d.with(eslintConfig),
  },
})
