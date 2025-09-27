" Vim Plugins Configuration
" This file contains all plugin definitions and settings

" Plugin Manager - vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Essential Plugins
Plug 'tpope/vim-sensible'           " Sensible defaults
Plug 'tpope/vim-commentary'         " Comment/uncomment lines
Plug 'tpope/vim-surround'          " Surround text with quotes, brackets, etc.
Plug 'tpope/vim-repeat'            " Repeat plugin commands with .

" File Navigation
Plug 'preservim/nerdtree'          " File tree explorer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'            " Fuzzy finder
Plug 'airblade/vim-rooter'         " Auto change directory to project root

" Git Integration
Plug 'tpope/vim-fugitive'          " Git commands in vim
Plug 'airblade/vim-gitgutter'      " Git diff indicators

" Status Line
Plug 'vim-airline/vim-airline'      " Status line
Plug 'vim-airline/vim-airline-themes'

" Syntax Highlighting & Language Support
Plug 'sheerun/vim-polyglot'        " Language pack
Plug 'dense-analysis/ale'          " Linting and fixing

" Code Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Themes
Plug 'morhetz/gruvbox'             " Gruvbox theme
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'arcticicestudio/nord-vim'

" Utility
Plug 'jiangmiao/auto-pairs'        " Auto close brackets
Plug 'preservim/vim-indent-guides' " Indent visualization
Plug 'Yggdroot/indentLine'         " Indent lines
Plug 'mattn/emmet-vim'             " HTML/CSS expansion

call plug#end()

" Plugin Configurations

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']
let g:NERDTreeShowHidden = 1

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'gruvbox'

" ALE
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tslint'],
\   'go': ['golint', 'go vet'],
\   'rust': ['cargo'],
\}

let g:ale_fixers = {
\   'python': ['autopep8', 'black'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'json': ['prettier'],
\   'yaml': ['prettier'],
\}

let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1

" CoC
" Use tab for trigger completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Gruvbox theme configuration
autocmd vimenter * ++nested colorscheme gruvbox
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_improved_strings = 1
let g:gruvbox_improved_warnings = 1

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┊'
let g:indentLine_faster = 1