-- ================ Indentation ======================
vim.cmd [[
  set autoindent
  set smartindent
  set smarttab
  set shiftwidth=2
  set softtabstop=2
  set tabstop=2
  set expandtab

  filetype plugin on
  filetype indent on

  " Display tabs and trailing spaces visually
  set list listchars=tab:\ \ ,trail:·

  set nowrap       " Don't wrap lines
  set linebreak    " Wrap lines at convenient points
]]
