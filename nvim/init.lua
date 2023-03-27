-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Make line numbers default for sure
vim.o.number = true

--  ╭──────────────────────────────────────────────────────────╮
--  │ Ensure lazy.nvim is installed                            │
--  ╰──────────────────────────────────────────────────────────╯
require("custom.ensure_package_manager")

--  ╭──────────────────────────────────────────────────────────╮
--  │ Set up packages                                          │
--  ╰──────────────────────────────────────────────────────────╯
require("lazy").setup({
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Core plugins                                           │
  --  ╰──────────────────────────────────────────────────────────╯
  -- Additional help under :h nvim-lua-guide
  "nanotee/nvim-lua-guide",

  -- useful Lua functions, e.g. like boost
  "nvim-lua/plenary.nvim",

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Git / version control                                  │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "tpope/vim-fugitive",
    config = function()
      -- Every time you open a git object using fugitive it creates a new buffer.
      -- This means that your buffer listing can quickly become swamped with
      -- fugitive buffers. This prevents this from becomming an issue:
      vim.api.nvim_create_autocmd({ "BufReadPost" }, {
        pattern = { "fugitive://*" },
        callback = function()
          vim.cmd([[set bufhidden=delete]])
        end,
      })

      vim.api.nvim_set_keymap(
        "v",
        "<leader>g",
        ":GBrowse!<CR>",
        { noremap = true, desc = "Copy link to source in Github" }
      )
    end,
  },

  -- enable GHE/Github links with :Gbrowse
  "tpope/vim-rhubarb",

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Snippets                                               │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "rafamadriz/friendly-snippets",
    dependencies = { "L3MON4D3/LuaSnip" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Color schemes and themes                               │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "bluz71/vim-nightfly-guicolors",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nightfly")

      -- Enable transparent terminal background
      vim.o.termguicolors = true
      vim.cmd([[
        hi Normal guibg=NONE ctermbg=NONE
        hi LineNr guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE ctermbg=NONE
        hi EndOfBuffer guibg=NONE ctermbg=NONE
      ]])
    end,
  },

  -- show hex colors in CSS/HTML files
  {
    "NvChad/nvim-colorizer.lua",
    opts = {},
  },

  { "kyazdani42/nvim-web-devicons", opts = {} },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "drzel/vim-line-no-indicator",
    },
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = "nightfly",
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = { "filename", "diff", "diagnostics" },
        lualine_x = { "filesize", "encoding", "fileformat", "filetype" },
        lualine_y = {},
        lualine_z = {
          function()
            return vim.fn.LineNoIndicator()
          end,
        },
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   File management                                        │
  --  ╰──────────────────────────────────────────────────────────╯
  "Shougo/unite.vim",

  {
    "Shougo/vimfiler.vim",
    config = function()
      vim.g.vimfiler_force_overwrite_statusline = 0
      vim.g.vimfiler_as_default_explorer = 1
      vim.g.vimshell_force_overwrite_statusline = 0

      vim.fn["vimfiler#custom#profile"]("default", "context", { safe = 0 })

      -- bind the minus key to show the file explorer in the dir of the current open
      -- buffer's file
      vim.keymap.set({ "n" }, "-", ":VimFilerBufferDir<CR>", { noremap = true, silent = true })
    end,
    requires = { "Shougo/unite.vim" },
  },

  "danro/rename.vim",

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   tmux                                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      -- set our shell to be bash for fast tmux switching times
      -- see: https://github.com/christoomey/vim-tmux-navigator/issues/72
      vim.o.shell = "/bin/bash --norc -i"

      -- <C-K>       * :<C-U>TmuxNavigateUp<CR>
      vim.keymap.set(
        { "n" },
        "<C-k>",
        ":<C-U>TmuxNavigateUp<CR>",
        { silent = true, noremap = true }
      )
    end,
  },

  {
    "melonmanchan/vim-tmux-resizer",
    config = function()
      vim.g.tmux_resizer_no_mappings = 0
    end,
  },

  "benmills/vimux",

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Testing                                                │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "janko-m/vim-test",
    config = function()
      vim.cmd([[
        nmap <silent> <leader>T :TestNearest<CR>
        nmap <silent> <leader>t :TestFile<CR>

        let g:test#preserve_screen = 1
        let test#neovim#term_position = "vert"
        let test#vim#term_position = "vert"

        let g:test#javascript#mocha#file_pattern = '\v.*_test\.(js|jsx|ts|tsx)$'

        if exists('$TMUX')
          " Use tmux to kick off tests if we are in tmux currently
          let test#strategy = 'vimux'
        else
          " Fallback to using terminal split
          let test#strategy = "neovim"
        endif

        let test#enabled_runners = ["lua#busted", "ruby#rspec", "javascript#jest"]

        let test#custom_runners = {}
        let test#custom_runners['ruby'] = ['rspec']
        let test#custom_runners['lua'] = ['busted']

        let test#custom_runners['javascript'] = ['jest']
        let test#custom_runners['typescript'] = ['jest']
      ]])
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Editing                                                │
  --  ╰──────────────────────────────────────────────────────────╯

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.keymap.set(
        { "n" },
        "<leader>nc",
        ":lua require('neogen').generate({ type = 'class' })<CR>",
        { noremap = true, silent = true, desc = "Generate [c]lass annotations" }
      )
      vim.keymap.set(
        { "n" },
        "<leader>nf",
        ":lua require('neogen').generate()<CR>",
        { noremap = true, silent = true, desc = "Generate [f]unction annotations" }
      )
    end,
    opts = {
      snippet_engine = "luasnip",
    },
  },

  -- Splitjoin like plugin
  {
    "AndrewRadev/splitjoin.vim",
    config = function()
      -- Disable the default keybindings so we can bind it below
      vim.g.splitjoin_split_mapping = ""
      vim.g.splitjoin_join_mapping = ""
    end,
  },

  {
    "Wansmer/treesj",
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })

      -- Configure a fallback to splitjoin.vim when a language is not supported.
      local langs = require("treesj.langs")["presets"]

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "*",
        callback = function()
          if langs[vim.bo.filetype] then
            vim.keymap.set(
              "n",
              "gS",
              "<Cmd>TSJSplit<CR>",
              { buffer = true, desc = "[S]plit under cursor" }
            )
            vim.keymap.set(
              "n",
              "gJ",
              "<Cmd>TSJJoin<CR>",
              { buffer = true, desc = "[J]oin under cursor" }
            )
          else
            vim.keymap.set(
              "n",
              "gS",
              "<Cmd>SplitjoinSplit<CR>",
              { buffer = true, desc = "[S]plit under cursor" }
            )
            vim.keymap.set(
              "n",
              "gJ",
              "<Cmd>SplitjoinJoin<CR>",
              { buffer = true, desc = "[J]oin under cursor" }
            )
          end
        end,
      })
    end,
  },

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- lets you surround comments in a box.
  {
    "LudoPinelli/comment-box.nvim",
    config = function()
      vim.keymap.set(
        { "n", "v" },
        "<leader>bb",
        require("comment-box").llbox,
        { noremap = true, desc = "Left-aligned comment box" }
      )

      vim.keymap.set(
        { "n", "v" },
        "<leader>bc",
        require("comment-box").lcbox,
        { noremap = true, desc = "Centered comment box" }
      )

      vim.keymap.set(
        { "n", "v" },
        "<leader>bc",
        require("comment-box").lrbox,
        { noremap = true, desc = "Right-aligned comment box" }
      )
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- marks in gutter
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup({})

      vim.keymap.set(
        "n",
        "<leader>m<space>",
        ":delm! | delm A-Z0-9<CR>",
        { desc = "Delete all marks", silent = true, noremap = true }
      )
    end,
  },

  -- switch syntaxes around with `gs`
  "AndrewRadev/switch.vim",

  -- disable highlights automatically on cursor move
  "romainl/vim-cool",

  -- strip whitespace on save
  "itspriddle/vim-stripper",

  -- cs`' to change `` to '', etc
  "tpope/vim-surround",

  -- <leader>q to toggle quickfix
  "milkypostman/vim-togglelist",

  -- snake_case -> camelCase, etc
  "tpope/vim-abolish",

  -- remaps .
  "tpope/vim-repeat",

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Larger plugin configs we import                        │
  --  ╰──────────────────────────────────────────────────────────╯
  { import = "custom.plugins.completion" },
  { import = "custom.plugins.fzf" },
  { import = "custom.plugins.lsp" },
  { import = "custom.plugins.telescope" },
  { import = "custom.plugins.treesitter" },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Disable this stupid mode
vim.o.noexrc = true
vim.o.noex = true
vim.o.nosecure = true

-- Indentation
vim.o.expandtab = true
vim.o.linebreak = true
vim.o.nowrap = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2

-- 80 chars
vim.opt.textwidth = 80
vim.opt.colorcolumn = "81" -- show column at 81

-- No swap or backup file
vim.o.noswapfile = true
vim.o.nobackup = true
vim.o.nowb = true

-- Scrolling
vim.o.scrolloff = 8 -- Start scrolling when we're 8 lines away from margins
vim.o.sidescrolloff = 15
vim.o.sidescroll = 1

-- Set highlight on search
vim.o.hlsearch = false
vim.o.listchars = "tab:▸ ,trail:ـ,extends:➧,eol:¬"

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.history = 1000 -- store lots of :cmdline history
vim.o.undodir = vim.fn.stdpath("data") .. "/backups"
vim.o.undofile = true
vim.o.undolevels = 1000

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
vim.opt.wildignore = { "node_modules/*", "vendor/bundle/*", "tmp/*" }

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Open splits to the right or below; more natural than the default
vim.o.splitright = true
vim.o.splitbelow = true

-- Minimum window width
vim.o.winwidth = 100

-- [[ Set up languages ]]

-- Go away perl
vim.g.loaded_perl_provider = 0

-- Python
vim.g.python_host_prog = vim.env.HOME .. "/.pyenv/versions/py2neovim/bin/python"
vim.g.python3_host_prog = vim.env.HOME .. "/.pyenv/versions/py3neovim/bin/python"

-- Node
vim.g.latest_node_path = vim.env.HOME .. "/.nodenv/versions/15.7.0/bin/node"

-- [[ Basic Keymaps ]]

-- Allow ctrl+z backgrounding in of insert mode
vim.keymap.set({ "i" }, "<C-Z>", "<Esc><C-Z>", { noremap = true })

-- Use more sane regexes by default
vim.keymap.set({ "n", "v" }, "/", "/\\v", { noremap = true })

-- Remap : to ;
vim.keymap.set({ "n" }, ";", ":", { noremap = true })

-- jk for normal mode
vim.keymap.set({ "i" }, "jk", "<Esc>")

-- Create some window splits easier with vv or ss
vim.keymap.set({ "n" }, "ss", "<C-w>s", { noremap = true })
vim.keymap.set({ "n" }, "vv", "<C-w>v", { noremap = true })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
