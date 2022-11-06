local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')
local lsp_format = require("lsp-format")
local lsp_status = require('lsp-status')
local null_ls = require("null-ls")

-- Load the friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

lsp_format.setup()

-- Shared on_attach + capabilities
--
-- We set these on the `default_config` so we don't have to set up `on_attach`
-- and `capabilities` for every last LSP.
local on_attach = function(client, bufnr)
  lsp_format.on_attach(client, bufnr)
  lsp_status.on_attach(client, bufnr)

  -- Floating window signature
  require('lsp_signature').on_attach({
    debug = false,
    handler_opts = {
      border = "single",
    },
  })
end

-- null ls
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
  on_attach = on_attach,
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
      env = {
        -- PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
      },
      -- Always use the local prettier, especially when prettier is pointing
      -- at a feature branch.
      prefer_local = "node_modules/.bin",
    }),

    -- eslint
    null_ls.builtins.code_actions.eslint_d.with(eslintConfig),
    null_ls.builtins.diagnostics.eslint_d.with(eslintConfig),
    -- null_ls.builtins.formatting.eslint_d.with(eslintConfig),
  }
})

lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
    capabilities = lsp_status.capabilities,
    on_attach = on_attach,
  }
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  virtual_text = {
    spacing = 4,
    format = function(diagnostic)
      -- Only show the first line with virtualtext.
      return string.gsub(diagnostic.message, '\n.*', '')
    end,
  },
  signs = true,
  update_in_insert = false,
})

-- setup nvim-cmp
local lspCapabilities = require('cmp_nvim_lsp').default_capabilities()

---------------------------------

-- Setup LSP statusline
lsp_status.register_progress()

-- Flow
lspconfig.flow.setup({
  capabilities = lspCapabilities,
  cmd = { 'node_modules/.bin/flow', 'lsp' },
})

-- Lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
  capabilities = lspCapabilities,
  -- cmd = sumneko_cmd,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          vim.fn.expand('$VIMRUNTIME/lua'),
          vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
          vim.fn.stdpath('config') .. '/lua'
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Rust
lspconfig.rust_analyzer.setup({
  capabilities = lspCapabilities,
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true
      },
      procMacro = {
        enable = true
      },
    }
  }
})

-- Emmet
lspCapabilities.textDocument.completion.completionItem.snippetSupport = true

if not lspconfig.emmet_ls then
  configs.emmet_ls = {
    default_config = {
      cmd = { 'emmet-ls', '--stdio' };
      filetypes = { 'html', 'css', 'blade', 'javascriptreact', 'javascript.jsx' };
      root_dir = function()
        return vim.loop.cwd()
      end;
      settings = {};
    };
  }
end

lspconfig.emmet_ls.setup({
  capabilities = lspCapabilities,
})

lspconfig.tsserver.setup({
  capabilities = lspCapabilities,
  cmd = {
    'typescript-language-server',
    '--stdio',
    -- attempt to speed up TypeScript
    '--tsserver-path=' .. vim.fn.getenv("HOME") .. '/.nodenv/shims/tsserver',
  },
  cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" }, -- Give 8gb of RAM to node
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  init_options = {
    maxTsServerMemory = "8192",
    preferences = {
      -- Ensure we always import from absolute paths
      importModuleSpecifierPreference = "non-relative",
    },
  },
  root_dir = lspconfig.util.root_pattern("tsconfig.json"),
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false

    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end

    on_attach(client, bufnr)
  end
})

lspconfig.sorbet.setup({
  capabilities = lspCapabilities,
  root_dir = lspconfig.util.root_pattern("sorbet"),
})
