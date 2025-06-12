local config = require("custom.config")

if config.stripe.machine then
  local setup = require("packages.lsp.setup")

  require("lspconfig_stripe")
  require("lspconfig").payserver_sorbet.setup({
    capabilities = setup.build_capabilities(),
    on_attach = setup.on_attach,
    root_dir = function(fname)
      -- We're in a pay-server folder if we can find a sorbet/config file
      -- and the path contains "pay-server"
      local root = require("lspconfig.util").root_pattern("sorbet/config")(fname)
      if root and string.match(root, "pay%-server") then
        return root
      end

      return nil
    end,
  })
end
