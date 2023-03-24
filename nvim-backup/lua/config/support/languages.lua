-- ================= perl ====================

-- Go away perl
vim.g.loaded_perl_provider = 0

-- =============== python ====================

vim.g.python_host_prog = vim.env.HOME .. '/.pyenv/versions/py2neovim/bin/python'
vim.g.python3_host_prog = vim.env.HOME .. '/.pyenv/versions/py3neovim/bin/python'

-- =============== node.js ===================

vim.g.latest_node_path = vim.env.HOME .. '/.nodenv/versions/15.7.0/bin/node'
