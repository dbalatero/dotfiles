local setup = require("packages.lsp.setup")

require("lspconfig").eslint.setup({
  capabilities = setup.build_capabilities(),
  on_attach = setup.on_attach,
  root_dir = require("lspconfig.util").root_pattern("package.json"),
})

vim.keymap.set("n", "<leader>le", ":EslintFixAll<CR>", {
  noremap = true,
  silent = true,
  desc = "Fix all ESLint issues in current file",
})
