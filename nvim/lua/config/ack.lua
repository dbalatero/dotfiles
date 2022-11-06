vim.g.ackprg = 'rg --vimgrep --no-heading'

vim.cmd([[
  cnoreabbrev Ack Ack!

  nnoremap <Leader>a :Ack!<Space>
  nnoremap <Leader>A :Ack!<CR>
]])
