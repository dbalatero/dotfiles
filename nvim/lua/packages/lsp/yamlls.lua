local setup = require("packages.lsp.setup")

require("lspconfig").bashls.setup({
  capabilities = setup.build_capabilities(),
  on_attach = setup.on_attach,
  settings = {
    yaml = {
      format = {
        enable = false,
      },
      schemas = {
        ["https://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      },
    },
  },

})
