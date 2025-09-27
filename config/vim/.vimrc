\" Enhanced Vim Configuration
\" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

\" Plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
call plug#end()

\" Basic settings
set number
set relativenumber
set expandtab
set shiftwidth=4
set tabstop=4
syntax enable
colorscheme gruvbox
set background=dark

\" Key mappings
let mapleader = ' '
nnoremap <leader>f :Files<CR>
nnoremap <leader>n :NERDTreeToggle<CR>

\" Load local configuration if it exists
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
