-- ╭────────────────────────────────────────────────────────────────────╮
-- │                               Plugins                              │
-- ╰────────────────────────────────────────────────────────────────────╯

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Core plugins                                           │
  --  ╰──────────────────────────────────────────────────────────╯
  -- Additional help under :h nvim-lua-guide
  use('nanotee/nvim-lua-guide')

  -- useful Lua functions, e.g. like boost
  use('nvim-lua/plenary.nvim')

  -- caching startup
  use('lewis6991/impatient.nvim')

  -- syntax highlights
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('config.treesitter')
    end,
    requires = {
      -- Extended matchers for %
      'andymass/vim-matchup',
      -- Highlight parenthesis pairs w/ different colors
      'p00f/nvim-ts-rainbow',
      -- Auto close <html> tags
      'windwp/nvim-ts-autotag',
    },
  })

  use({
    'Konfekt/vim-alias',
    config = function()
      require('config.aliases')
    end,
  })

  -- context menu when hitting leader key(s)
  use({
    'folke/which-key.nvim',
    config = function()
      require('config.which-key')
    end,
  })

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Color schemes and themes                               │
  --  ╰──────────────────────────────────────────────────────────╯
  use('bluz71/vim-nightfly-guicolors')

  -- show hex colors in CSS/HTML files
  use({
    'chrisbra/Colorizer',
    config = function()
      require('config.colorizer')
    end,
  })

  -- fancy icons
  use('kyazdani42/nvim-web-devicons')

  -- nice scroll indicator
  use('drzel/vim-line-no-indicator')

  -- fast Lua statusline
  use({
    'dbalatero/galaxyline.nvim',
    config = function()
      require('config.statusline')
    end,
  })

  -- replace missing colors for LSP
  use('folke/lsp-colors.nvim')

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Completion                                             │
  --  ╰──────────────────────────────────────────────────────────╯
  use({
    'saadparwaiz1/cmp_luasnip',
    requires = { 'L3MON4D3/LuaSnip' },
  })

  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('config.nvim-cmp')
    end,
    requires = {
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'lukas-reineke/cmp-under-comparator',
      'onsails/lspkind-nvim', -- add vscode-style icons to completion menu
    },
  })

  use({
    'danymat/neogen',
    config = function()
      require('config.neogen-setup')
    end,
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
    },
  })

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Editing                                                │
  --  ╰──────────────────────────────────────────────────────────╯
  -- Show function context as you scroll
  use({
    'romgrk/nvim-treesitter-context',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  })

  -- Splitjoin like plugin
  use({
    'Wansmer/treesj',
    requires = { 'nvim-treesitter' },
    config = function()
      require('config.treesj-setup')
    end,
  })

  -- switch syntaxes around with `gs`
  use('AndrewRadev/switch.vim')

  -- comment with `gcc`
  use('tpope/vim-commentary')

  -- disable highlights automatically on cursor move
  use('romainl/vim-cool')

  -- alternate files with :AV/:AS
  use('tpope/vim-projectionist')

  -- show marks in the gutter
  use({
    'kshenoy/vim-signature',
    config = function()
      require('config.vim-signature')
    end,
  })

  -- strip whitespace on save
  use('itspriddle/vim-stripper')

  -- cs`' to change `` to '', etc
  use('tpope/vim-surround')

  -- <leader>q to toggle quickfix
  use('milkypostman/vim-togglelist')

  -- snake_case -> camelCase, etc
  use('tpope/vim-abolish')

  -- successor to vim-sneak
  use({
    'ggandor/lightspeed.nvim',
    config = function()
      require('config.lightspeed')
    end,
  })

  -- remaps .
  use('tpope/vim-repeat')

  -- extended % key matching
  use('andymass/vim-matchup')

  -- lets you surround comments in a box.
  use({
    'LudoPinelli/comment-box.nvim',
    config = function()
      require('config.comment-box')
    end,
  })

  -- Show guides for indentation
  use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('config.indent-blankline')
    end,
  })

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   File management                                        │
  --  ╰──────────────────────────────────────────────────────────╯
  use('danro/rename.vim')

  use({
    'Shougo/vimfiler.vim',
    config = function()
      require('config.vimfiler')
    end,
    requires = { 'Shougo/unite.vim' },
  })

  use('Shougo/unite.vim')

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Grepping / searching                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  use({
    'mileszs/ack.vim',
    config = function()
      require('config.ack')
    end,
  })

  use({
    'ibhagwan/fzf-lua',
    branch = 'main',
    config = function()
      require('config.fzf')
    end,
  })

  use({
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  })

  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    config = function()
      require('config.telescope-setup')
    end,
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim' },
    },
  })

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Language support                                       │
  --  ╰──────────────────────────────────────────────────────────╯
  use({
    'cappyzawa/starlark.vim',
    config = function()
      require('config.starlark')
    end,
  })

  use('rodjek/vim-puppet')
  use('hashivim/vim-terraform')

  -- markdown preview with :Glow
  use('npxbr/glow.nvim')

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   LSP madness                                            │
  --  ╰──────────────────────────────────────────────────────────╯

  -- Standalone UI for nvim-lsp progress
  use('j-hui/fidget.nvim')

  -- LSP for formatting/diagnostics
  use({
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
      'lukas-reineke/lsp-format.nvim',
      'nvim-lua/plenary.nvim',
    },
  })

  -- diagnostic collector
  use({
    'folke/trouble.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('config.trouble')
    end,
  })

  use({
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu', -- lazy load when this command is ran
  })

  -- out of the box LSP configs for common langs
  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('config.lsp')
    end,
    requires = {
      -- floating signature 'as you type'
      'ray-x/lsp_signature.nvim',

      -- formatting/diagnostic server
      'jose-elias-alvarez/null-ls.nvim',

      -- LSP progress
      'j-hui/fidget.nvim',
    },
  })

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Ruby                                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  -- better RSpec syntax highlighting
  use('keith/rspec.vim')

  -- toggle block styles with ,b
  use('jgdavey/vim-blockle')

  -- allow for alternate files
  use('tpope/vim-rake')

  -- indentation, etc
  use('vim-ruby/vim-ruby')

  -- fenced syntax colors in heredocs
  use('joker1007/vim-ruby-heredoc-syntax')

  -- extract vars, methods, etc
  use('ecomba/vim-ruby-refactoring')

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Snippets                                               │
  --  ╰──────────────────────────────────────────────────────────╯
  use('L3MON4D3/LuaSnip')

  use({
    'rafamadriz/friendly-snippets',
    requires = { 'L3MON4D3/LuaSnip' },
    config = function()
      require('config.friendly-snippets')
    end,
  })

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Testing                                                │
  --  ╰──────────────────────────────────────────────────────────╯
  use({
    'janko-m/vim-test',
    config = function()
      require('config.vim-test')
    end,
  })

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   tmux                                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  use({
    'christoomey/vim-tmux-navigator',
    config = function()
      require('config.tmux-navigator')
    end,
  })

  use({
    'melonmanchan/vim-tmux-resizer',
    config = function()
      require('config.tmux-resizer')
    end,
  })

  use('benmills/vimux')

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Version control                                        │
  --  ╰──────────────────────────────────────────────────────────╯
  -- show commit popup with <leader>gm
  use({
    'rhysd/git-messenger.vim',
    config = function()
      require('config.git-messenger')
    end,
  })

  -- the git plugin
  use({
    'tpope/vim-fugitive',
    config = function()
      require('config.fugitive')
    end,
  })

  -- show changed line marks in gutter
  use('airblade/vim-gitgutter')

  -- enable GHE/Github links with :Gbrowse
  use('tpope/vim-rhubarb')

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Vimscript                                              │
  --  ╰──────────────────────────────────────────────────────────╯
  use('tpope/vim-scriptease')

  -- REPL for Neovim/Vimscript with :Repl
  use('ii14/neorepl.nvim')
end)
