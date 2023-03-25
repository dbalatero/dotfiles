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
  --  │   Completion                                             │
  --  ╰──────────────────────────────────────────────────────────╯

  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('config.nvim-cmp')
    end,
    requires = {
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
