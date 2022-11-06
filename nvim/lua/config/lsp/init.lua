-- gutter space for lsp info on left
vim.cmd [[set signcolumn=yes]]

-- 300ms before CursorHold events fire (like hover text on errors)
vim.cmd [[set updatetime=300]]

--  ╭──────────────────────────────────────────────────────────╮
--  │ Core keybinds                                            │
--  ╰──────────────────────────────────────────────────────────╯

vim.cmd [[
  nnoremap <silent><space>la :CodeActionMenu<CR>
  nnoremap <silent> <space>l0  <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> <space>ld  <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> <space>li  :LspInfo<CR>
  nnoremap <silent> <space>lh  <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> <space>lk  <cmd>lua vim.diagnostic.open_float({scope="line"})<CR>
  nnoremap <silent> <space>lD  <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> <space>ln  <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <silent> <space>lr  <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> <space>lt  <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> <space>lw  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
]]

--  ╭──────────────────────────────────────────────────────────╮
--  │ Diagnostics                                              │
--  ╰──────────────────────────────────────────────────────────╯
vim.cmd [[
  nnoremap <silent> gj :lua vim.diagnostic.goto_next()<cr>
  nnoremap <silent> gk :lua vim.diagnostic.goto_prev()<cr>
]]
