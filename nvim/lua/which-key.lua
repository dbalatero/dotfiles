-- https://www.reddit.com/r/neovim/comments/khtan0/configure_vimwhichkey_in_lua/

-- 500ms timeout
vim.o.timeoutlen = 500

-- Leader maps
vim.g.which_key_leader = {
  ['name'] = 'Leader',
  ['a']    = 'ack-search',
  ['A']    = 'ack-search-under-cursor',
  ['b']    = 'toggle-ruby-block',
  ['d']    = 'toggle-binding-pry',
  ['f']    = 'fzf-ripgrep',
  ['l']    = 'toggle-location-list',
  ['o']    = {
    ['name'] = "+org-mode",
    ['a'] = "open-agenda-prompt",
    ['c'] = "open-capture-prompt",
  },
  ['q']    = 'toggle-quick-fix',
  ['t']    = 'test-current-file',
  ['T']    = 'test-current-line',
  ['x']    = {
    ['name'] = '+trouble',
    ['d']    = 'document-diagnostics',
    ['l']    = 'location-list',
    ['q']    = 'quickfix',
    ['w']    = 'workspace-diagnostics',
    ['x']    = 'toggle-between',
  }
}

vim.g.which_key_leader[','] = {
  ['name'] = '+easymotion',
}

vim.api.nvim_set_keymap("n", "<leader>", [[:<c-u>WhichKey ','<CR>]], { silent = true })
vim.call('which_key#register', ',', "g:which_key_leader")

-- Spacebar maps

vim.g.which_key_space = {
  ['name'] = 'Spacebar',
  ['f']    = {
    ['name'] = '+find',
    ['d']    = 'find-pattern',
    ['s']    = 'find-under-cursor',
  },
  ['g']    = {
    ['name'] = '+git',
    ['b']    = 'blame',
    ['g']    = 'neogit',
    ['m']    = 'show-commit-message',
    ['s']    = 'status',
  },
  ['l']    = {
    ['name'] = '+lsp',
    ['0'] = 'list-buffer-document-symbols',
    ['d'] = 'jump-to-definition',
    ['D'] = 'jump-to-implementation',
    ['h'] = 'hover-documentation',
    ['i'] = 'info-status',
    ['r'] = 'show-references',
    ['t'] = 'jump-to-type-definition',
    ['w'] = 'list-workspace-document-symbols',
  },
  ['t'] = 'file-tree',
}

vim.api.nvim_set_keymap("n", "<space>", [[:<c-u>WhichKey '<space>'<CR>]], { silent = true })
vim.call('which_key#register', '<space>', "g:which_key_space")
