local lspconfig = require('lspconfig')
local shared = require('config.lsp.shared')

lspconfig.sorbet.setup({
  cmd = {
    'srb',
    'tc',
    '--lsp',
    -- '--enable-experimental-lsp-document-formatting-rubyfmt',
  },
  capabilities = shared.default_capabilities,
  on_attach = shared.on_attach,
  root_dir = lspconfig.util.root_pattern('sorbet'),
})
