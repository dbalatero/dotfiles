-- TODO: fix this
vim.cmd [[
  " Load aliases for :vh -> :vertical h
  if exists('s:loaded_vimafter')
    silent doautocmd VimAfter VimEnter *
  else
    let s:loaded_vimafter = 1
    augroup VimAfter
      autocmd!
      " autocmd VimEnter * source ~/.config/nvim/aliases.vim
    augroup END
  endif
]]
