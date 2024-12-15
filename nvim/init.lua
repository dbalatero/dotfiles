-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Make line numbers default for sure
vim.o.number = true

--  ╭──────────────────────────────────────────────────────────╮
--  │ Setting options                                          │
--  │ See `:help vim.o`                                        │
--  ╰──────────────────────────────────────────────────────────╯

-- Disable this stupid mode
vim.o.exrc = false
vim.o.ex = false
vim.o.secure = false

-- Indentation
vim.o.expandtab = true
vim.o.linebreak = true
vim.o.wrap = false
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2

-- 80 chars
vim.opt.textwidth = 80
vim.opt.colorcolumn = "81" -- show column at 81

-- No swap or backup file
vim.o.swapfile = false
vim.o.backup = false
vim.o.wb = false

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

-- Don't autowrap lines as I type
vim.cmd([[set formatoptions-=t]])

--  ╭──────────────────────────────────────────────────────────╮
--  │ Set up languages                                         │
--  ╰──────────────────────────────────────────────────────────╯

-- Go away, Perl
vim.g.loaded_perl_provider = 0

-- Python
vim.g.python_host_prog = vim.env.HOME .. "/.pyenv/versions/py2neovim/bin/python"
vim.g.python3_host_prog = vim.env.HOME
  .. "/.pyenv/versions/py3neovim/bin/python"

-- Node
vim.g.latest_node_path = vim.env.HOME .. "/.nodenv/versions/15.7.0/bin/node"

--  ╭──────────────────────────────────────────────────────────╮
--  │ Basic Keymaps                                            │
--  ╰──────────────────────────────────────────────────────────╯

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

vim.cmd([[
  " relative path  (src/foo.txt)
  nnoremap <leader>cf :let @*=expand("%")<CR>

  " absolute path  (/something/src/foo.txt)
  nnoremap <leader>cF :let @*=expand("%:p")<CR>

  " filename       (foo.txt)
  nnoremap <leader>ct :let @*=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>ch :let @*=expand("%:p:h")<CR>
]])

--  ╭──────────────────────────────────────────────────────────╮
--  │ Highlight on yank                                        │
--  │ See `:help vim.highlight.on_yank()`                      │
--  ╰──────────────────────────────────────────────────────────╯

local highlight_group =
  vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.md",
  command = "set wrap",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.md",
  command = "set formatoptions-=t",
})

--  ╭──────────────────────────────────────────────────────────╮
--  │ Ensure lazy.nvim is installed                            │
--  ╰──────────────────────────────────────────────────────────╯
require("custom.ensure_package_manager")

require("lazy").setup({
  change_detection = {
    enabled = true,
    notify = false,
  },
  ui = {
    border = "rounded",
  },
  spec = {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │   Core plugins                                           │
    --  ╰──────────────────────────────────────────────────────────╯
    -- Additional help under :h nvim-lua-guide
    "nanotee/nvim-lua-guide",

    -- useful Lua functions, e.g. like boost
    "nvim-lua/plenary.nvim",

    { import = "packages.completion" },
    { import = "packages.diagnostics.init" },
    { import = "packages.editing" },
    { import = "packages.files" },
    { import = "packages.formatting" },
    { import = "packages.fzf" },
    { import = "packages.git" },
    { import = "packages.lsp.init" },
    -- Can't use telescope in pay-server
    -- { import = "packages.telescope" },
    { import = "packages.snippets" },
    { import = "packages.testing" },
    { import = "packages.tmux" },
    { import = "packages.treesitter" },
    { import = "packages.ui" },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
