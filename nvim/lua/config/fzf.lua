local actions = require('fzf-lua.actions')

require('fzf-lua').setup({
  fzf_opts = {
    ['--layout'] = false,
  },
  files = {
    actions = {
      ["default"] = actions.file_edit_or_qf,
      ["ctrl-x"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      ["alt-q"] = actions.file_sel_to_qf,
    },
    -- pay-server can't take the heat
    file_icons = false,
    git_icons = false,
  },
  git = {
    file_icons = false,
    git_icons = false,
  },
  grep = {
    file_icons = false,
    git_icons = false,
  },
  winopts = {
    preview = {
      layout = 'vertical',
    },
  },
})

vim.cmd [[
  noremap <C-b> :lua require('fzf-lua').buffers()<CR>
  noremap <C-p> <cmd>lua require('fzf-local').fzfFiles()<CR>
  noremap <space>fd <cmd>lua require('fzf-lua').grep()<CR>
  noremap <space>fs <cmd>lua require('fzf-lua').grep_cword()<CR>
]]
