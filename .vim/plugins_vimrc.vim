
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'


"Plugin 'bfrg/vim-cpp-modern'
"Plugin 'octol/vim-cpp-enhanced-highlight'
" Provides a command to close a buffer but keep its window.
Plugin 'qpkorr/vim-bufkill'

" fzf fuzzy stuff happen here!
Plugin 'mileszs/ack.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf'
Plugin 'tracyone/fzf-funky',{'on': 'FzfFunky'}

" Automatically change directory to project root
Plugin 'airblade/vim-rooter'

" Syntax highlight
Plugin 'sheerun/vim-polyglot'
" Code comments
Plugin 'tpope/vim-commentary'

"Status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"vim simple status line
"Plugin 'itchyny/lightline.vim'

" UI
Plugin 'preservim/nerdtree'

"Provides auto-balancing and some expansions for parens, quotes, etc.
Plugin 'delimitMate.vim'

"Plugin 'markonm/traces.vim' " Preview for substitute commands.



" Show hex codes as colours
Plugin 'chrisbra/Colorizer'

" Gruvbox Community theme.  !!!!Danger for fzf make it Hang!!!
Plugin 'morhetz/gruvbox'
Plugin 'bluz71/vim-nightfly-guicolors'
let g:color_coded_enabled = 1
let g:color_coded_filetypes = ['c', 'cpp', 'objc']

Plugin 'frazrepo/vim-rainbow'
Plugin 'ryanoasis/vim-devicons'
Plugin 'ryanoasis/vim-webdevicons'

"Nice to have colorscheme
Plugin 'rafi/awesome-vim-colorschemes'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-colorscheme-switcher'
Plugin 'junegunn/seoul256.vim'
Plugin 'navarasu/onedark.nvim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'sainnhe/everforest'

"set background=dark
"set t_Co=256
"let g:gruvbox_bold='1'
"let g:gruvbox_italic='1'
"let g:gruvbox_transparent_bg='1'
"let g:gruvbox_italicize_comments='1'
"autocmd vimenter * ++nested colorscheme gruvbox

