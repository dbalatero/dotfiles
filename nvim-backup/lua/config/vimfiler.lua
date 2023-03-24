vim.cmd([[
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_as_default_explorer = 1
  let g:vimshell_force_overwrite_statusline = 0

  call vimfiler#custom#profile('default', 'context', {
    \ 'safe': 0
    \ })

  " bind the minus key to show the file explorer in the dir of the current open
  " buffer's file
  nnoremap - :VimFilerBufferDir<CR>
]])
