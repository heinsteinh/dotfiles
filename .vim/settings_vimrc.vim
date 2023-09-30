set nocompatible        " Use Vim settings, rather than Vi settings
set langmenu=en
set encoding=utf-8

set nobackup
set nowritebackup
set noswapfile

set softtabstop=2 " Indent by 2 spaces when hitting tab
set shiftwidth=4 " Indent by 4 spaces when auto-indenting
set tabstop=4 " Show existing tab with 4 spaces width
syntax on " Enable syntax highlighting
filetype indent on " Enable indenting for files
set autoindent " Enable auto indenting
set number " Enable line numbers


"colorscheme neodark
"colorscheme onedark
set laststatus=2 "show status line
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
set wildmenu " Display command line'scomplete options as a menu.
"set wildmode=list:longest,full               " list all options, match to the longest
set wildmode=longest,full               " list all options, match to the longest
set number
set relativenumber

set textwidth=0           " Don't wrap words by default
set textwidth=80          " This wraps a line with a break when you reach 80 chars

"- Allow backspacing over indention, line breaks and insertion start.
set backspace=indent,eol,start
"- Set bigger history of executed commands.
set history=1000
"- Show incomplete commands at the bottom.
set showcmd
"- Show current mode at the bottom.
set showmode

" Vim will automatically save files when moving between buffers.
" This is pretty safe because I persist edit history, so I can undo changes if a buffer gets closed.
set autowrite
set autowriteall

" Automatically reread a file if some other process writes to it.
" Useful for editing files in a full IDE or other vim sessions simultaneously.
set autoread

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview


" Highlights a cross over the cursor.
" Some highlighting gets a little strange due to my theme.
set cursorline
"set cursorcolumn

" Always display the sign column, used by coc, ale, and gitgutter to display changes, errors, and warning.
"set signcolumn=yes

set title
" Allow hidden buffers, don't limit to 1 file per window/split
set hidden

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab

" Displays tabs, nbsps, and trailing spaces with printable characters.
"set list listchars=tab:▸\ ,nbsp:·,trail:·
"set list listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮


" Visualize tabs and newlines
"set list
"set listchars=space:.,eol:¬,trail:.,tab:>.
set listchars=eol:↵,tab:➝\ ,trail:~,extends:>,precedes:<,space:·
nnoremap <silent> <leader>ll :set nolist!<CR>

" Shows a fancy arrow on wrapped lines.
set showbreak=↪\

set showmatch
" Tenths of a second to show the matching paren, when 'showmatch' is set.
set matchtime=1
" Make < and > as well as match pairs.
set matchpairs+=<:>

" clear search
map <leader><space> :let @/=''<cr> "

" After 300 millis of no edits, a swap file will be written.
" After 300 millis, the CursorHold event fires.
set updatetime=300
" Blocks "hit enter" prompts on completion menu actions.
"set shortmess+=c
" Adds a second line to the cmd bar.
set cmdheight=1

set switchbuf=useopen " reveal already opened files from the quickfix window
" instead of opening new buffers
"let g:rainbow_active = 1

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/
" Proper search
set incsearch
set ignorecase
set smartcase
" Highlights search matches.
set hlsearch

" Better splits (new windows appear below and to the right)
set splitbelow
set splitright

set termguicolors

let $LANG='en'
set langmenu=en
set mouse=a

set whichwrap+=<,>,[,]

" set listchars=tab:>-,trail:·
" set list

"- Disable beep on error.
set noerrorbells
"- Flash the screen instead of beeping on errors.
set visualbell

" Selection {{{
" Change selected letters when write
set selectmode=mouse,key

" Select with SHIFT + ARROW for Vim-noobs
set keymodel=startsel,stopsel

" Enable select with mouse in insert mode
"set selection=exclusive
set selection=inclusive

" Can move cursor past end of line, where there are no characters, in visualblock mode
set virtualedit=block


"Set it to unnamedplus for yank and paste commands to work with the + register by default:
"You can also tell Vim to use both at once:
"set clipboard=unnamed,unnamedplus " Copy into system (*, +) register.

" Visual selection automatically copied to clipboard
"set go+=a
if g:is_win
    set clipboard=unnamed " Copy into system (*) register.
    set go+=a
elseif g:is_mac
elseif g:is_linux
    set clipboard=unnamedplus " Copy into system (+) register.
    set go+=P
endif

"set mousemodel=popup
"}}}

" Folding rules {{{
set foldenable                  " enable folding

set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set foldcolumn=1
set foldlevel=100         " start out with everything folded
"set foldmethod=marker           " detect triple-{ style fold markers
set foldlevelstart=99           " start out with everything unfolded


"}}}

