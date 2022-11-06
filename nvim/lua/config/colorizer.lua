-- highlight hex colors in these file types
vim.cmd([[
  au BufNewFile,BufRead *.css,*.html,*.htm,*.sass,*.scss :ColorHighlight!
]])
