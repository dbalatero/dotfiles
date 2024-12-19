local setup = require("packages.lsp.setup")

require("lspconfig").eslint.setup({
  capabilities = setup.build_capabilities(),
  on_attach = setup.on_attach,
})
