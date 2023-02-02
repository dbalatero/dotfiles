local lspconfig = require('lspconfig')
local on_attach = require('config.lsp.shared').on_attach

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern('Cargo.toml'),
  settings = {
    ['rust-analyzer'] = {
      assist = {
        importGranularity = 'module',
        importPrefix = 'by_self',
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
})
