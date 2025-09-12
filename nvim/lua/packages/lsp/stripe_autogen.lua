local config = require("custom.config")

if config.stripe.machine then
  local configs = require("lspconfig.configs")
  if not configs.stripe_autogen then
    configs.stripe_autogen = {
      default_config = {},
      commands = {},
    }
  end

  local setup = require("packages.lsp.setup")

  local cmd
  if config.stripe.devbox then
    cmd = { "autogen-lsp-server", "--stdio" }
  else
    cmd = { "pay", "exec", "autogen-lsp-server", "--stdio", "--debug" }
  end

  require("lspconfig").stripe_autogen.setup({
    cmd = cmd,
    filetypes = { "ruby", "yaml" },
    capabilities = setup.build_capabilities(),
    on_attach = setup.on_attach,
    root_dir = function(fname)
      -- Only activate in pay-server directories
      local root = require("lspconfig.util").root_pattern(".git")(fname)
      if root and string.match(root, "pay%-server") then
        return root
      end

      return nil
    end,
  })
end
