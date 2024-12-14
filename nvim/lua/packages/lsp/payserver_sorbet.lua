local config = require("custom.config")

if config.stripe.machine then
  local setup = require("packages.lsp.setup")

  require("lspconfig_stripe")
  require("lspconfig").payserver_sorbet.setup({
    capabilities = setup.build_capabilities(),
    on_attach = setup.on_attach,
  })
end
