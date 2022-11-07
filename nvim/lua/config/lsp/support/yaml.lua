local lspconfig = require('lspconfig')

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      schemas = {
        -- Github actions
        ['https://json.schemastore.org/github-workflow'] = '.github/workflows/*.{yml,yaml}',
        ['https://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',

        -- Stainless schema
        ['./lib/config-schema.json'] = 'specs/*.stainless.yml',
      },
    },
  },
})
