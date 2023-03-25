-- ╭────────────────────────────────────────────────────────────────────╮
-- │                               Plugins                              │
-- ╰────────────────────────────────────────────────────────────────────╯

return require('packer').startup(function(use)
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Core plugins                                           │
  --  ╰──────────────────────────────────────────────────────────╯
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

  -- nice scroll indicator
  use('drzel/vim-line-no-indicator')

  -- fast Lua statusline
  use({
    'dbalatero/galaxyline.nvim',
    config = function()
      require('config.statusline')
    end,
  })

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

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Editing                                                │
  --  ╰──────────────────────────────────────────────────────────╯

  -- alternate files with :AV/:AS
  use('tpope/vim-projectionist')

  -- successor to vim-sneak
  use({
    'ggandor/lightspeed.nvim',
    config = function()
      require('config.lightspeed')
    end,
  })

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

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   LSP madness                                            │
  --  ╰──────────────────────────────────────────────────────────╯

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
  --  │   Snippets                                               │
  --  ╰──────────────────────────────────────────────────────────╯
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
end)
