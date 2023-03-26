-- ╭────────────────────────────────────────────────────────────────────╮
-- │                               Plugins                              │
-- ╰────────────────────────────────────────────────────────────────────╯

return require('packer').startup(function(use)
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Core plugins                                           │
  --  ╰──────────────────────────────────────────────────────────╯
  -- context menu when hitting leader key(s)
  use({
    'folke/which-key.nvim',
    config = function()
      require('config.which-key')
    end,
  })

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Editing                                                │
  --  ╰──────────────────────────────────────────────────────────╯

  -- successor to vim-sneak
  use({
    'ggandor/lightspeed.nvim',
    config = function()
      require('config.lightspeed')
    end,
  })

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Grepping / searching                                   │
  --  ╰──────────────────────────────────────────────────────────╯
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
