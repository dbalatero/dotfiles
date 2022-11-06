-- ╭────────────────────────────────────────────────────────────────────╮
-- │                               Plugins                              │
-- ╰────────────────────────────────────────────────────────────────────╯

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Core plugins                                           │
  --  ╰──────────────────────────────────────────────────────────╯
  -- Additional help under :h nvim-lua-guide
  use 'nanotee/nvim-lua-guide'

  -- useful Lua functions, e.g. like boost
  use 'nvim-lua/plenary.nvim'

  -- syntax highlights
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('config.treesitter') end,
  }

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Color schemes and themes                               │
  --  ╰──────────────────────────────────────────────────────────╯
  use 'bluz71/vim-nightfly-guicolors'

  -- show hex colors in CSS/HTML files
  use {
    'chrisbra/Colorizer',
    config = function() require('config.colorizer') end,
  }

  -- fancy icons
  use 'kyazdani42/nvim-web-devicons'

  -- nice scroll indicator
  use 'drzel/vim-line-no-indicator'

  -- fast Lua statusline
  use 'dbalatero/galaxyline.nvim'

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Editing                                                │
  --  ╰──────────────────────────────────────────────────────────╯
  -- Show function context as you scroll
  use {
    'romgrk/nvim-treesitter-context',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }

  -- split/join single line/multiline
  use {
    'AndrewRadev/splitjoin.vim',
    config = function() require('config.splitjoin') end,
  }

  -- switch syntaxes around with `gs`
  use 'AndrewRadev/switch.vim'

  -- comment with `gcc`
  use 'tpope/vim-commentary'

  -- disable highlights automatically on cursor move
  use 'romainl/vim-cool'

  -- alternate files with :AV/:AS
  use 'tpope/vim-projectionist'

  -- show marks in the gutter
  use {
    'kshenoy/vim-signature',
    config = function() require('config.vim-signature') end,
  }

  -- strip whitespace on save
  use 'itspriddle/vim-stripper'

  -- cs`' to change `` to '', etc
  use 'tpope/vim-surround'

  -- <leader>q to toggle quickfix
  use 'milkypostman/vim-togglelist'

  -- snake_case -> camelCase, etc
  use 'tpope/vim-abolish'

  -- successor to vim-sneak
  use {
    'ggandor/lightspeed.nvim',
    config = function() require('config.lightspeed') end,
  }

  -- remaps .
  use 'tpope/vim-repeat'

  -- extended % key matching
  use 'andymass/vim-matchup'

  -- lets you surround comments in a box.
  use 'LudoPinelli/comment-box.nvim'

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   File management                                        │
  --  ╰──────────────────────────────────────────────────────────╯
  use 'danro/rename.vim'

  use {
    'Shougo/vimfiler.vim',
    config = function() require('config.vimfiler') end,
    requires = { 'Shougo/unite.vim' },
  }

  use 'Shougo/unite.vim'

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Grepping / searching                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'mileszs/ack.vim',
    config = function() require('config.ack') end,
  }

  use {
    'ibhagwan/fzf-lua',
    branch = 'main',
    config = function() require('config.fzf') end,
  }

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Language support                                       │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'cappyzawa/starlark.vim',
    config = function() require('config.starlark') end,
  }

  use 'rodjek/vim-puppet'
  use 'hashivim/vim-terraform'

  -- markdown preview with :Glow
  use 'npxbr/glow.nvim'

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Ruby                                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  -- better RSpec syntax highlighting
  use 'keith/rspec.vim'

  -- toggle block styles with ,b
  use 'jgdavey/vim-blockle'

  -- allow for alternate files
  use 'tpope/vim-rake'

  -- indentation, etc
  use 'vim-ruby/vim-ruby'

  -- fenced syntax colors in heredocs
  use 'joker1007/vim-ruby-heredoc-syntax'

  -- extract vars, methods, etc
  use 'ecomba/vim-ruby-refactoring'

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Testing                                                │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'janko-m/vim-test',
    config = function() require('config.vim-test') end,
  }

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Version control                                        │
  --  ╰──────────────────────────────────────────────────────────╯
  -- show commit popup with <leader>gm
  use {
    'rhysd/git-messenger.vim',
    config = function() require('config.git-messenger') end,
  }

  -- the git plugin
  use {
    'tpope/vim-fugitive',
    config = function() require('config.fugitive') end,
  }

  -- show changed line marks in gutter
  use 'airblade/vim-gitgutter'

  -- enable GHE/Github links with :Gbrowse
  use 'tpope/vim-rhubarb'

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Vimscript                                              │
  --  ╰──────────────────────────────────────────────────────────╯
  use 'tpope/vim-scriptease'
end)
