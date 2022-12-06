local telescope = require('telescope')

telescope.setup()
telescope.load_extension('fzf')

vim.cmd([[
  nnoremap <space><space> <cmd>Telescope find_files<cr>
  nnoremap <space>ff <cmd>Telescope find_files<cr>
  nnoremap <space>fg <cmd>Telescope live_grep<cr>
  nnoremap <space>fb <cmd>Telescope buffers<cr>
  nnoremap <space>fh <cmd>Telescope help_tags<cr>
]])
