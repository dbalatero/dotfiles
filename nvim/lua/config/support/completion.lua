-- ===================== Completion =========================
vim.cmd([[
  set completeopt=menu,menuone,noselect

  " wildignore
  set wildignore+=node_modules/*,bower_components/*,vendor/bundle/*,tmp/*
]])
