local lspconfig = require('lspconfig')
local on_attach = require('config.lsp.shared').on_attach

lspconfig.tsserver.setup({
  cmd = {
    'typescript-language-server',
    '--stdio',
    -- attempt to speed up TypeScript
    '--tsserver-path='
      .. vim.fn.getenv('HOME')
      .. '/.nodenv/shims/tsserver',
  },
  cmd_env = { NODE_OPTIONS = '--max-old-space-size=8192' }, -- Give 8gb of RAM to node
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  init_options = {
    maxTsServerMemory = '8192',
    preferences = {
      -- Ensure we always import from absolute paths
      importModuleSpecifierPreference = 'non-relative',
    },
  },
  root_dir = lspconfig.util.root_pattern('tsconfig.json'),
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end

    on_attach(client, bufnr)
  end,
})
