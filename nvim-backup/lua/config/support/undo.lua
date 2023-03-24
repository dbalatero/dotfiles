-- ================ Persistent Undo ====================
-- Keep undo history across sessions, by storing in file.

vim.cmd([[
  if has('persistent_undo')
    set undodir=~/.vim/backups
    set undofile
  endif
]])
