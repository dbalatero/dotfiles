local neogen = require('neogen')

neogen.setup({
  snippet_engine = 'luasnip',
})

vim.api.nvim_set_keymap('n', '<Space>nf', ":lua require('neogen').generate()<CR>", {
  noremap = true,
  silent = true,
})
