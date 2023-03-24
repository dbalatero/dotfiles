-- Every time you open a git object using fugitive it creates a new buffer.
-- This means that your buffer listing can quickly become swamped with
-- fugitive buffers. This prevents this from becomming an issue:
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { 'fugitive://*' },
  callback = function()
    vim.cmd([[set bufhidden=delete]])
  end,
})

vim.api.nvim_set_keymap('v', '<leader>g', ':GBrowse!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<space>gb', ':Gblame<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<space>gs', ':Gstats<CR>', { noremap = true })
