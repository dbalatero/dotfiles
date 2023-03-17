local lspconfig = require('lspconfig')

lspconfig.sorbet.setup({
  cmd = {
    'srb',
    'tc',
    '--lsp',
    '--enable-experimental-lsp-document-formatting-rubyfmt',
  },
  root_dir = lspconfig.util.root_pattern('sorbet'),
})
