" use vim settings, rather then vi settings (much better!).
" this must be first, because it changes other options as a side effect.
set nocompatible

" =============== character fixes ====================

scriptencoding utf-8
set encoding=utf-8

" ================ general config ====================

set backspace=indent,eol,start  "allow backspace in insert mode
set history=1000                "store lots of :cmdline history
set showcmd                     "show incomplete cmds down the bottom
set showmode                    "show current mode down the bottom
set gcr=a:blinkon0              "disable cursor blink
set visualbell                  "no sounds
set autoread                    "reload files changed outside vim
set ruler                       "show ruler
set undolevels=1000             "undo levels
set laststatus=2                "fix status bar
set guifont=Inconsolata-g\ for\ Powerline
set number

" this makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" highlight funky characters and whatnot
set list
set listchars=tab:▸\ ,trail:ـ,extends:➧,eol:¬

" stop kicking me into this mode you fucking apes
set noexrc
set noex
set nosecure

" minimum width
set winwidth=100

" Put contents of unnamed register in OS X clipboard
set clipboard=unnamed

" remap ESC to jk
inoremap jk <esc>

"Clear current search highlight by hitting g + /
nmap <silent> g/ :nohlsearch<CR>


" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.

if has('persistent_undo')
  "silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       " Don't wrap lines
set linebreak    " Wrap lines at convenient points

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

let mapleader=","
let g:mapleader=","

" =============== mouse =====================
set mouse=n

" ================= perl ====================

" Go away perl
let g:loaded_perl_provider = 0

" =============== python ====================

let g:python_host_prog = $HOME . '/.pyenv/versions/py2neovim/bin/python'
let g:python3_host_prog = $HOME . '/.pyenv/versions/py3neovim/bin/python'

" =============== node.js ===================

let g:latest_node_path = $HOME . '/.nodenv/versions/15.7.0/bin/node'
" let g:node_host_prog = g:latest_node_path

" ============== yank ======================

" highlights yanked text for a little extra visual feedback
" so we don't need to rely on visual mode as much, try yip or y4y
augroup highlight_yank
  if has("nvim-0.5")
    autocmd!
    autocmd TextYankPost * silent! lua require('vim.highlight').on_yank()
  endif
augroup END

" ================ Editing ==========================

" color column
set colorcolumn=81

" Open splits to the right or below; more natural than the default
set splitright
set splitbelow

" Create window splits easier. The default
" way is Ctrl-w,v and Ctrl-w,s. I remap
" this to vv and ss
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

"make Y consistent with C and D
nnoremap Y y$
function! YRRunAfterMaps()
  nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

" remap : to ;
nnoremap ; :

" background out of insert mode
inoremap <C-Z> <Esc><C-Z>

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" Load aliases for :vh -> :vertical h
if exists('s:loaded_vimafter')
  silent doautocmd VimAfter VimEnter *
else
  let s:loaded_vimafter = 1
  augroup VimAfter
    autocmd!
    autocmd VimEnter * source ~/.config/nvim/aliases.vim
  augroup END
endif

" wildignore
set wildignore+=node_modules/*,bower_components/*,vendor/bundle/*,tmp/*

" function to source a file if it exists
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

" =============== Cursor shapes =====================

" TODO this doesn't work in neovim
let &t_SI = "\<esc>[5 q" " I beam cursor for insert mode
let &t_EI = "\<esc>[2 q" " block cursor for normal mode
let &t_SR = "\<esc>[3 q" " underline cursor for replace mode

" ╭────────────────────────────────────────────────────────────────────╮
" │                               Plugins                              │
" ╰────────────────────────────────────────────────────────────────────╯

call plug#begin('~/.local/nvim/plugins')

" Core
Plug 'Konfekt/vim-alias'
Plug 'liuchengxu/vim-which-key'       " context menu when hitting leader key(s)

" LSP
Plug 'neovim/nvim-lspconfig'             " out of the box LSP configs for common langs
Plug 'nvim-lua/lsp-status.nvim'          " provides statusline information for LSP
Plug 'onsails/lspkind-nvim'              " add vscode-style icons to completion menu
Plug 'ray-x/lsp_signature.nvim'          " floating signature 'as you type'
Plug 'folke/trouble.nvim'                " diagnostic collector
Plug 'folke/lsp-colors.nvim'             " replace missing colors
Plug 'kosayoda/nvim-lightbulb'           " show possible code actions as lightbulb icons in the gutter
Plug 'weilbith/nvim-code-action-menu'    " add popup menu for running code actions

" Completion
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'lukas-reineke/cmp-under-comparator'

" Syntax checking
Plug 'lukas-reineke/lsp-format.nvim'      " LSP format on save, with multiple sequential LSPs + async
Plug 'jose-elias-alvarez/null-ls.nvim'    " LSP for formatting/diagnostics
Plug 'folke/trouble.nvim'                 " pretty list for diagnostics, errors, etc

call plug#end()

" Load packer
lua require('plugins')

" ================== Trouble ====================

nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xx <cmd>TroubleToggle<cr>
" nnoremap gR <cmd>TroubleToggle lsp_references<cr>

" ==================== LSP ======================

set completeopt=menu,menuone,noselect

" 300ms before CursorHold events fire (like hover text on errors)
set updatetime=300

call luaeval('require("lspservers")')

" Update code action lightbulbs on cursor rest
autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()

nnoremap <silent><space>la :CodeActionMenu<CR>
nnoremap <silent> <space>l0  <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <space>ld  <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <space>li  :LspInfo<CR>
nnoremap <silent> <space>lh  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <space>lk  <cmd>lua vim.diagnostic.open_float({scope="line"})<CR>
nnoremap <silent> <space>lD  <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <space>ln  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <space>lr  <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <space>lt  <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <space>lw  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" gutter space for lsp info on left
set signcolumn=yes

" =================== Trouble ===================

lua << EOF
  require("trouble").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  })
EOF

" Vim Script
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>

" =================== Diagnostics =======================

nnoremap <silent> gj :lua vim.diagnostic.goto_next()<cr>
nnoremap <silent> gk :lua vim.diagnostic.goto_prev()<cr>

" Load lua/init.lua
lua require("init")
