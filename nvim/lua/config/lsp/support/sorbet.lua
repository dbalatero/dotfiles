local lspconfig = require('lspconfig')

lspconfig.sorbet.setup({
  root_dir = lspconfig.util.root_pattern("sorbet"),
})
