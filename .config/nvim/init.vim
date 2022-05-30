"general
set clipboard+=unnamedplus
set cursorline
set expandtab
set ic 
set nu
set shiftwidth=2
set smartcase
set smartindent
set splitbelow splitright
set tabstop=2

if has('nvim') | let &viminfo .= '.nvim' | endif

let mapleader=" "

"buffer navigation
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-g> :GFiles<CR>
nnoremap <silent> <C-o> :Buffers<CR>
nnoremap <C-f> :Rg!

"remap ESC to jj 
:imap jj <Esc>

"spell check
nnoremap <silent> <F7> :set spell!<cr>
inoremap <silent> <F7> <C-O>:set spell!<cr>

"split find
map <Leader>vf :vsplit<CR><C-p>
map <Leader>hf :split<CR><C-p>
map <Leader>vr :vsplit<CR><C-f><space>
map <Leader>hr :split<CR><C-f><space>

"split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"split orientation
map <Leader>tk <C-w>t<C-w>H
map <Leader>th <C-w>t<C-w>K

"split sizing
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

"plugins
call plug#begin('~/.config/nvim/.vim/plugged')
Plug 'EdenEast/nightfox.nvim'
Plug 'junegunn/fzf.vim'
call plug#end()

"appearance
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
colorscheme nightfox

"vim background transparency
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE
