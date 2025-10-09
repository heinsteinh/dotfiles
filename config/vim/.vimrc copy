" ~/.vimrc - Vim Configuration with vim-plug
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugin section
call plug#begin('~/.vim/plugged')

" Essential plugins
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Enhanced search plugins
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'easymotion/vim-easymotion'
Plug 'brooth/far.vim'
Plug 'ctrlpvim/ctrlp.vim'

" Additional useful plugins
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale'
Plug 'Yggdroot/indentLine'
Plug 'ntpeters/vim-better-whitespace'

" Color schemes
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'arcticicestudio/nord-vim'

call plug#end()

" ============================================================================
" Basic Vim Settings
" ============================================================================
set nocompatible
set encoding=utf-8
set number
set relativenumber
set cursorline
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.pyc,*.class,*.git,*.svn,*.hg,*~,*.swp,*.swo,*.tmp,*.bak
set mouse=a
if has('macunix')
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif
set updatetime=250
set timeoutlen=500
set splitbelow
set splitright
set hidden
set backup
set writebackup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile
set path+=**
set tags=./tags,tags;$HOME

" Create directories if they don't exist
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p", 0700)
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p", 0700)
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p", 0700)
endif

" Indentation
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent
set smartindent

" ============================================================================
" Color Scheme
" ============================================================================
syntax enable
set termguicolors
set background=dark
let g:gruvbox_contrast_dark = "hard"
colorscheme gruvbox

" ============================================================================
" Plugin Configuration
" ============================================================================

" NERDTree
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore=['\.pyc$', '\~$', '\.swp$', '\.git$']
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeQuitOnOpen=1

" vim-devicons
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dark'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" FZF Enhanced Configuration
let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8, 'yoffset': 0.5, 'xoffset': 0.5 } }
let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
let g:fzf_tags_command = 'ctags -R'
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" FZF Colors to match gruvbox
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Custom FZF commands
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'cat {}']}, <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" Git Gutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '~'

" ALE (Linting)
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'javascript': ['eslint'],
\   'bash': ['shellcheck'],
\   'vim': ['vint'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['autopep8', 'isort'],
\   'javascript': ['prettier', 'eslint'],
\}
let g:ale_fix_on_save = 1

" IndentLine
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1

" Better Whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" Incsearch - Enhanced search highlighting
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
let g:incsearch#auto_nohlsearch = 1

" EasyMotion - Fast navigation
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0
let g:EasyMotion_use_smartsign_us = 1

" CtrlP - Additional file finder
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['.git', '.hg', '.svn', 'package.json', 'Makefile']
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$|node_modules|dist|build',
  \ 'file': '\v\.(exe|so|dll|pyc|class)$'
  \ }
let g:ctrlp_use_caching = 1
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

" Far.vim - Find and Replace
let g:far#enable_undo = 1
let g:far#default_file_mask = '%'

" ============================================================================
" Key Mappings
" ============================================================================
let mapleader = " "

" General mappings
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>h :noh<CR>

" Buffer navigation
nnoremap <C-h> :bprevious<CR>
nnoremap <C-l> :bnext<CR>
nnoremap <leader>bd :bdelete<CR>

" Window navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" FZF Enhanced
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>rg :Rg<CR>
nnoremap <leader>gg :GGrep<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>hc :History:<CR>
nnoremap <leader>hs :History/<CR>
nnoremap <leader>/ :Lines<CR>
nnoremap <leader>bl :BLines<CR>
nnoremap <leader>ag :Ag<CR>

" EasyMotion
nmap <Leader>s <Plug>(easymotion-overwin-f)
nmap <Leader>j <Plug>(easymotion-overwin-line)
nmap <Leader>k <Plug>(easymotion-overwin-line)
map <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" Search enhancements
nnoremap <leader>* *<C-O>:%s///gn<CR>
nnoremap <leader># #<C-O>:%s///gn<CR>
nnoremap <leader>/ :noh<CR>

" Enhanced search and replace
nnoremap <leader>sr :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <leader>ss :Farr<CR>
vnoremap <leader>sr "hy:%s/\V<C-r>h//gc<left><left><left>

" CtrlP mappings
nnoremap <leader>p :CtrlP<CR>
nnoremap <leader>pb :CtrlPBuffer<CR>
nnoremap <leader>pm :CtrlPMRU<CR>
nnoremap <leader>pt :CtrlPTag<CR>

" Git (Fugitive)
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Git blame<CR>

" Quick edit vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Toggle relative numbers
nnoremap <leader>rn :set relativenumber!<CR>

" Clear search highlighting
nnoremap <Esc><Esc> :nohlsearch<CR>

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" ============================================================================
" Auto Commands
" ============================================================================
augroup vimrc_autocmds
  autocmd!

  " Remove trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e

  " Restore cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Auto-close NERDTree if it's the only window left
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

  " Highlight current line only in active window
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

augroup END

" ============================================================================
" File Type Specific Settings
" ============================================================================
augroup filetype_settings
  autocmd!

  " Python
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab

  " JavaScript/TypeScript
  autocmd FileType javascript,typescript setlocal tabstop=2 shiftwidth=2 expandtab

  " HTML/CSS
  autocmd FileType html,css setlocal tabstop=2 shiftwidth=2 expandtab

  " YAML
  autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab

  " Markdown
  autocmd FileType markdown setlocal wrap linebreak

augroup END

" ============================================================================
" Status Line (if airline is not loaded)
" ============================================================================
if !exists('g:loaded_airline')
  set laststatus=2
  set statusline=%f\ %m%r%h%w\ [%Y]\ [%{&ff}]\ %=[%l,%c]\ %p%%
endif
