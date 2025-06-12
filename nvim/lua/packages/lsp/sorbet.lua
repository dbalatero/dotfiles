local setup = require("packages.lsp.setup")

require("lspconfig").sorbet.setup({
  capabilities = setup.build_capabilities(),
  on_attach = setup.on_attach,
  root_dir = function(fname)
    -- We're in a sorbet project if we can find a sorbet/config file
    local root = require("lspconfig.util").root_pattern("sorbet/config")(fname)

    -- but we don't want to attach if it's a pay-server repo,
    -- that's handled by a different LSP
    if root and not string.match(root, "pay%-server") then
      return root
    end

    return nil
  end,
})
