vim.cmd [[
  " minimum width
  set winwidth=100

  " Open splits to the right or below; more natural than the default
  set splitright
  set splitbelow

  " Create window splits easier. The default
  " way is Ctrl-w,v and Ctrl-w,s. I remap
  " this to vv and ss
  nnoremap <silent> vv <C-w>v
  nnoremap <silent> ss <C-w>s
]]
