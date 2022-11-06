vim.cmd [[
  nnoremap <Space>bb <Cmd>lua require('comment-box').lbox()<CR>
  vnoremap <Space>bb <Cmd>lua require('comment-box').lbox()<CR>

  nnoremap <Space>bc <Cmd>lua require('comment-box').cbox()<CR>
  vnoremap <Space>bc <Cmd>lua require('comment-box').cbox()<CR>
]]
