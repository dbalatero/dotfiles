-- turn on syntax highlighting
vim.cmd([[syntax on]])

vim.cmd([[
  " highlight funky characters and whatnot
  set list
  set listchars=tab:▸\ ,trail:ـ,extends:➧,eol:¬

  " Clear current search highlight by hitting g + /
  nmap <silent> g/ :nohlsearch<CR>
]])

vim.cmd([[
  " highlights yanked text for a little extra visual feedback
  " so we don't need to rely on visual mode as much, try yip or y4y
  augroup highlight_yank
    if has("nvim-0.5")
      autocmd!
      autocmd TextYankPost * silent! lua require('vim.highlight').on_yank()
    endif
  augroup END
]])
