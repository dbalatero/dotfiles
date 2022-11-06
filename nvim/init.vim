" use vim settings, rather then vi settings (much better!).
" this must be first, because it changes other options as a side effect.
set nocompatible

" The most important config, remap ESC to jk
inoremap jk <esc>

" ================ general config ====================

" Leader key
let mapleader=","
let g:mapleader=","

set autoread                    " reload files changed outside vim
set backspace=indent,eol,start  " allow backspace in insert mode
set clipboard=unnamed           " Put contents of unnamed register in macOS clipboard
set gcr=a:blinkon0              " disable cursor blink
set history=1000                " store lots of :cmdline history
set laststatus=2                " fix status bar
set mouse=n                     " allow mouse
set number                      " show numbers
set ruler                       " show ruler
set showcmd                     " show incomplete cmds down the bottom
set showmode                    " show current mode down the bottom
set undolevels=1000             " undo levels
set visualbell                  " no sounds

" This makes vim act like all other editors, buffers can exist in the
" background without being in a window.
set hidden

" Fix utf8 support
scriptencoding utf-8
set encoding=utf-8

" Allow ctrl+z backgrounding in of insert mode
inoremap <C-Z> <Esc><C-Z>

" ================ Editing ==========================

" color column
set colorcolumn=81

"make Y consistent with C and D
nnoremap Y y$
function! YRRunAfterMaps()
  nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

" remap : to ;
nnoremap ; :

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" ╭──────────────────────────────────────────────────────────╮
" │ It's Lua config time                                     │
" ╰──────────────────────────────────────────────────────────╯

lua require("init")
