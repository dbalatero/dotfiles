local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
  filetype = 'org',
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'css',
    'go',
    'graphql',
    'javascript',
    'java',
    'json',
    'kotlin',
    'lua',
    'nix',
    'php',
    'python',
    'ruby',
    'tsx',
    'typescript',
    'yaml',
  },
  highlight = {
    enable = true,

    -- Remove this to use TS highlighter for some of the highlights (Experimental)
    disable = { 'org' },
    -- Required since TS highlighter doesn't support all syntax features (conceal)
    additional_vim_regex_highlighting = { 'org' },
  },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  matchup = {
    enable = true,
  },
}
