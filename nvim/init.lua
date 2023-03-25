-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   Core plugins                                           │
  --  ╰──────────────────────────────────────────────────────────╯
  -- Additional help under :h nvim-lua-guide
  "nanotee/nvim-lua-guide",

  -- useful Lua functions, e.g. like boost
  "nvim-lua/plenary.nvim",

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

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      -- Standalone UI for nvim-lsp progress
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup({
            sources = {
              ["null-ls"] = {
                ignore = true,
              },
            },
            timer = {
              task_decay = 400,
              fidget_decay = 700,
            },
          })
        end,
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "lukas-reineke/lsp-format.nvim",
    },
  },

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },
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

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = "┊",
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- Show function context as you scroll
      "romgrk/nvim-treesitter-context",

      -- Add new text object support based on language
      "nvim-treesitter/nvim-treesitter-textobjects",

      -- Extended matchers for %
      "andymass/vim-matchup",

      -- Highlight parenthesis pairs w/ different colors
      "p00f/nvim-ts-rainbow",

      -- Auto close <html> tags
      "windwp/nvim-ts-autotag",
    },
    config = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  },

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
  --  │   Editing                                                │
  --  ╰──────────────────────────────────────────────────────────╯
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

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.o.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

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

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Open splits to the right or below; more natural than the default
vim.o.splitright = true
vim.o.splitbelow = true

-- Minimum window width
vim.o.winwidth = 100

-- [[ Basic Keymaps ]]

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

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set(
  "n",
  "<leader>?",
  require("telescope.builtin").oldfiles,
  { desc = "[?] Find recently opened files" }
)
vim.keymap.set(
  "n",
  "<leader><space>",
  require("telescope.builtin").find_files,
  { desc = "[S]earch [F]iles" }
)

vim.keymap.set(
  "n",
  "<leader>sb",
  require("telescope.builtin").buffers,
  { desc = "[S]earch existing buffers" }
)
vim.keymap.set(
  "n",
  "<leader>sd",
  require("telescope.builtin").diagnostics,
  { desc = "[S]earch [D]iagnostics" }
)
vim.keymap.set(
  "n",
  "<leader>sf",
  require("telescope.builtin").find_files,
  { desc = "[S]earch [F]iles" }
)
vim.keymap.set(
  "n",
  "<leader>sg",
  require("telescope.builtin").live_grep,
  { desc = "[S]earch by [G]rep" }
)
vim.keymap.set(
  "n",
  "<leader>sh",
  require("telescope.builtin").help_tags,
  { desc = "[S]earch [H]elp" }
)
vim.keymap.set(
  "n",
  "<leader>sw",
  require("telescope.builtin").grep_string,
  { desc = "[S]earch current [W]ord" }
)

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "dockerfile",
    "elixir",
    "erlang",
    "go",
    "graphql",
    "help",
    "java",
    "javascript",
    "json",
    "kotlin",
    "lua",
    "nix",
    "php",
    "python",
    "regex",
    "ruby",
    "rust",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },
  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,
  highlight = { enable = true },
  indent = { enable = true, disable = { "python" } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<M-space>",
    },
  },
  textobjects = {
    enable = true,
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
  -- Plugins
  matchup = {
    enable = true,
  },
  rainbow = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
})

--  ╭──────────────────────────────────────────────────────────╮
--  │ Diagnostics                                              │
--  ╰──────────────────────────────────────────────────────────╯
vim.keymap.set("n", "gk", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "gj", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set(
  "n",
  "<leader>e",
  vim.diagnostic.open_float,
  { desc = "Open floating diagnostic message" }
)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
local lsp_format = require("lsp-format")
lsp_format.setup()

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  lsp_format.on_attach(client)

  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>li", ":LspInfo<CR>", "[I]nfo")
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap(
    "<leader>ws",
    require("telescope.builtin").lsp_dynamic_workspace_symbols,
    "[W]orkspace [S]ymbols"
  )

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  -- TODO: find another key
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  bashls = {},
  jsonls = {
    json = {
      schemas = {
        {
          description = "TypeScript compiler configuration file",
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
          url = "http://json.schemastore.org/tsconfig",
        },
        {
          description = "Babel configuration",
          fileMatch = { ".babelrc.json", ".babelrc", "babel.config.json" },
          url = "http://json.schemastore.org/lerna",
        },
        {
          description = "ESLint config",
          fileMatch = { ".eslintrc.json", ".eslintrc" },
          url = "http://json.schemastore.org/eslintrc",
        },
        {
          description = "Prettier config",
          fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
          url = "http://json.schemastore.org/prettierrc",
        },
        {
          description = "Vercel Now config",
          fileMatch = { "now.json" },
          url = "http://json.schemastore.org/now",
        },
        {
          description = "Stylelint config",
          fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
          url = "http://json.schemastore.org/stylelintrc",
        },
      },
    },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  rust_analyzer = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
  tsserver = {},
  yamlls = {
    yaml = {
      schemas = {
        -- Github actions
        ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
        ["https://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      },
    },
  },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

local lspconfig = require("lspconfig")

mason_lspconfig.setup_handlers({
  -- Default setup handler
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
  -- Custom handlers
  sorbet = function()
    lspconfig.sorbet.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {},
      root_dir = lspconfig.util.root_pattern("sorbet"),
    })
  end,
  tsserver = function()
    lspconfig.tsserver.setup({
      cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" }, -- Give 8gb of RAM to node
      filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
      init_options = {
        maxTsServerMemory = "8192",
        preferences = {
          -- Ensure we always import from absolute paths
          importModuleSpecifierPreference = "non-relative",
        },
      },
      root_dir = lspconfig.util.root_pattern("tsconfig.json"),
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        if client.config.flags then
          client.config.flags.allow_incremental_sync = true
        end

        on_attach(client, bufnr)
      end,
    })
  end,
})

local ignorePrettierRules = function(diagnostic)
  return diagnostic.code ~= "prettier/prettier"
end

local hasEslintConfig = function(utils)
  return utils.root_has_file({
    ".eslintrc",
    ".eslintrc.json",
    ".eslintrc.js",
  })
end

local hasPrettierConfig = function(utils)
  return utils.root_has_file({
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.js",
    ".prettierrc.toml",
    ".prettierrc.yml",
    ".prettierrc.yaml",
  })
end

local eslintConfig = {
  condition = hasEslintConfig,
  filter = ignorePrettierRules,
}

local null_ls = require("null-ls")
local rubyfmt_formatter = require("custom.rubyfmt")

null_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  sources = {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │     Lua                                                  │
    --  ╰──────────────────────────────────────────────────────────╯
    null_ls.builtins.formatting.stylua,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │     Ruby                                                 │
    --  ╰──────────────────────────────────────────────────────────╯
    rubyfmt_formatter,

    --  ╭──────────────────────────────────────────────────────────╮
    --  │     TypeScript                                           │
    --  ╰──────────────────────────────────────────────────────────╯
    null_ls.builtins.formatting.prettierd.with({
      condition = hasPrettierConfig,
      env = {
        -- Always use the local prettier in node_modules, especially when prettier is pointing
        -- at a feature branch or something weird.
        -- PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
      },
    }),

    null_ls.builtins.code_actions.eslint_d.with(eslintConfig),
    null_ls.builtins.diagnostics.eslint_d.with(eslintConfig),
  },
})

require("mason-null-ls").setup({
  ensure_installed = nil,
  automatic_installation = true,
  automatic_setup = false,
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
