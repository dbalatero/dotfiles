" ================ general config ====================

" Allow ctrl+z backgrounding in of insert mode
inoremap <C-Z> <Esc><C-Z>

" ================ Editing ==========================

" color column
set colorcolumn=81

"make Y consistent with C and D
nnoremap Y y$
function! YRRunAfterMaps()
  nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v
