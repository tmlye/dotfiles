" General
" =======

set packpath=~/.config/nvim
set termguicolors
set clipboard=unnamedplus
set number                  " Show linenumbers
set hidden                  " Buffers can exist in the background
set showmatch               " Briefly jump to matching bracket
set matchtime=2             " Time match is shown in 0.1s
" path, filetype, readonly flag, buffers, line pos, percentage
au VimEnter *
  \ let &statusline='%<%F %Y%r %3*'
    \ .bufferline#get_status_string()
     \ .'%{bufferline#refresh_status()}%*%=%l,%-5.0c%p%%'
let g:bufferline_echo = 0

" Check if files were changed outside of vim on buffer switches
au FocusGained,BufEnter * :checktime

" Syntax
" ======

colorscheme getfresh    " Place your schemes in .vim/colors

" Search
" ======

set ignorecase          " Case insensitive search, unless uppercase letter used
set smartcase

" History, Undo
" ============

set noswapfile          " Don't use swap files
set undofile            " Keeps undo history after save/close
set undodir=~/.nvim_undo

" Indentation, Whitespace, Linewrapping
" =====================================

set expandtab           " Inserts spaces instead of tabs
set smartindent         " More syntax aware autoindent
set tabstop=4           " One tab = 4 spaces, see :help tabstop
set shiftwidth=4        " Number of spaces for autoindent

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·
augroup trailing        " Don't show trailing spaces in insert mode
  autocmd!
  autocmd InsertEnter * :set listchars-=trail:·
  autocmd InsertLeave * :set listchars+=trail:·
augroup end

set wrap                " Linewrapping
let &showbreak='+++ '   " String to indicate wrapped line
set cpoptions+=n        " Show above string between line numbers

" Folding
" =======

" Safe and reload folds
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" Scrolling
" =========

set scrolloff=10        " Lines around cursor kept on screen
set sidescrolloff=10    " Same for sidescrolling
set sidescroll=5        " Columns to scroll when cursor off screen

" Filetype correction
" ===================

au BufRead,BufNewFile *.jade setfiletype jade
let g:tex_flavor='latex'

" UI
" ==

set guicursor=          " Use standard cursor in insert mode

" Mappings
" ========

let mapleader=' '

" Allow sudo filesaving
cmap w!! %!sudo tee > /dev/null %

" Move across wrapped lines better
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Split window navigation
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
imap <c-j> <c-o><c-j>
imap <c-k> <c-o><c-k>
imap <c-h> <c-o><c-h>
imap <c-l> <c-o><c-l>

" Navigate buffers with alt+N
" Is there a better way to do this?
map <silent> <M-1> :b 1<CR>
map <silent> <M-2> :b 2<CR>
map <silent> <M-3> :b 3<CR>
map <silent> <M-4> :b 4<CR>
map <silent> <M-5> :b 5<CR>
map <silent> <M-6> :b 6<CR>
map <silent> <M-7> :b 7<CR>
map <silent> <M-8> :b 8<CR>
map <silent> <M-9> :b 9<CR>

" Clear highlighting after jump
noremap <silent> gd gd:noh<CR>

" Manual highlight clearing
nnoremap <silent> <c-g> :noh<CR>

" Remove trailing whitespace
nnoremap <silent> <leader>s :%s/\s\+$//e<CR>:noh<CR>

" quicker saving
nnoremap <Leader>w :w<CR>

" Contact lookup for editing mail
imap <c-f> <ESC>:r!muttvcardsearch <cword><CR><ESC>

" Open a terminal in the current buffer's file's directory
map <silent> <leader>t :lcd %:h<CR>:vertical terminal <CR>

" Copy to wayland clipboard
vnoremap <silent> <leader>y :'<,'>w !wl-copy<CR><CR>

" open current file in nerdtree
nmap <leader>m :NERDTreeFind<CR>
