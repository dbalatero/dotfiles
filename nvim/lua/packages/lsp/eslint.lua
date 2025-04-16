local setup = require("packages.lsp.setup")

require("lspconfig").eslint.setup({
  capabilities = setup.build_capabilities(),
  on_attach = setup.on_attach,
})

vim.keymap.set("n", "<leader>le", ":EslintFixAll<CR>", {
  noremap = true,
  silent = true,
  desc = "Fix all ESLint issues in current file",
})
