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

" Essential plugins (some with lazy-loading)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() }, 'on': ['Files','Rg','Ag','GGrep','Buffers','Tags','Lines','BLines','History','Marks'] }
Plug 'junegunn/fzf.vim', { 'on': ['Files','Rg','Ag','GGrep','Buffers','Tags','Lines','BLines','History','Marks'] }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle','NERDTreeFind'] }
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive', { 'on': ['Git','Gdiff','Gblame','Gread','Gwrite','Ggrep','Glog'] }
Plug 'airblade/vim-gitgutter'

" Enhanced search plugins
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'easymotion/vim-easymotion'
Plug 'brooth/far.vim'
" Removed ctrlp (replaced by fzf pickers for performance)

" Additional useful plugins
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale', { 'for': ['python','javascript','typescript','bash','vim','yaml','markdown'] }
Plug 'Yggdroot/indentLine', { 'for': ['python','javascript','typescript','yaml','json','lua','vim'] }
Plug 'ntpeters/vim-better-whitespace'

" Markdown Preview: Pandoc-based (configured later in file)

" Color schemes
Plug 'joshdick/onedark.vim'
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

" Atom Dark theme (onedark.vim)
let g:onedark_terminal_italics = 1
"colorscheme onedark

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
let g:airline_theme = 'onedark'
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

" FZF Colors to match Atom Dark (onedark)
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
" Use built-in :Files and :Rg from fzf.vim for proper lazy-loading
" Keep GGrep with an ensure-load to use fzf# functions safely
function! s:FzfEnsureLoaded()
  if exists('*plug#load')
    try
      silent! call plug#load('fzf', 'fzf.vim')
    catch
    endtry
  endif
endfunction

command! -bang -nargs=* GGrep
  \ call s:FzfEnsureLoaded() |
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" Git Gutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '~'

" Markdown Preview configuration
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 1
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_theme = 'dark'

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

" (CtrlP configuration removed; using fzf for file navigation)

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
" Helper to ensure fzf.vim is loaded when using mappings
nnoremap <silent> <leader>f :silent! call <SID>FzfMap('Files')<CR>
nnoremap <silent> <leader>b :silent! call <SID>FzfMap('Buffers')<CR>
nnoremap <silent> <leader>rg :silent! call <SID>FzfMap('Rg')<CR>
nnoremap <silent> <leader>gg :silent! call <SID>FzfMap('GGrep')<CR>
nnoremap <silent> <leader>t :silent! call <SID>FzfMap('Tags')<CR>
nnoremap <silent> <leader>m :silent! call <SID>FzfMap('Marks')<CR>
nnoremap <silent> <leader>h :silent! call <SID>FzfMap('History')<CR>
" Removed invalid History variants; use :History for command/history instead
nnoremap <silent> <leader>/ :silent! call <SID>FzfMap('Lines')<CR>
nnoremap <silent> <leader>bl :silent! call <SID>FzfMap('BLines')<CR>
nnoremap <silent> <leader>ag :silent! call <SID>FzfMap('Ag')<CR>

function! s:FzfMap(cmd)
  if exists('*plug#load')
    silent! call plug#load('fzf', 'fzf.vim')
  endif
  execute a:cmd
endfunction

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

" Repurposed former CtrlP mappings to FZF equivalents
nnoremap <leader>p :silent! call <SID>FzfMap('Files')<CR>
nnoremap <leader>pb :silent! call <SID>FzfMap('Buffers')<CR>
nnoremap <leader>pm :silent! call <SID>FzfMap('History')<CR>
nnoremap <leader>pt :silent! call <SID>FzfMap('Tags')<CR>

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

  " Markdown editing niceties
  autocmd FileType markdown setlocal conceallevel=2
  autocmd FileType markdown setlocal spell
  autocmd FileType markdown setlocal colorcolumn=
  autocmd FileType markdown setlocal wrap linebreak

  " Markdown Preview keymaps
  autocmd FileType markdown nnoremap <buffer> <leader>mp :MarkdownPreview<CR>
  autocmd FileType markdown nnoremap <buffer> <leader>ms :MarkdownPreviewStop<CR>
  autocmd FileType markdown nnoremap <buffer> <leader>mt :MarkdownPreviewToggle<CR>

augroup END

" ----------------------------------------------------------------------------
" Markdown Preview with Pandoc
" ----------------------------------------------------------------------------
" Use /tmp for better browser access (some browsers can't read from hidden dirs)
let g:markdown_preview_dir = '/tmp/vim-markdown-preview-' . $USER
let g:markdown_preview_auto_update = 1

" Create preview directory with world-readable permissions
if !isdirectory(g:markdown_preview_dir)
  call mkdir(g:markdown_preview_dir, 'p', 0755)
  call system('chmod 755 ' . shellescape(g:markdown_preview_dir))
endif

function! s:MarkdownPreview()
  if !executable('pandoc')
    echohl ErrorMsg
    echom 'ERROR: pandoc is not installed!'
    echom 'Install with: sudo apt install pandoc (Ubuntu/Debian)'
    echohl None
    return
  endif

  " Generate unique HTML filename based on source file
  let l:source_file = expand('%:p')
  if empty(l:source_file)
    echohl ErrorMsg | echom 'ERROR: Save the file first!' | echohl None
    return
  endif

  let l:html_file = g:markdown_preview_dir . '/' . expand('%:t:r') . '.html'
  let b:markdown_preview_file = l:html_file

  " Build pandoc command with GitHub-flavored markdown and styling
  let l:pandoc_cmd = 'pandoc'
  let l:pandoc_cmd .= ' --from=gfm'
  let l:pandoc_cmd .= ' --to=html5'
  let l:pandoc_cmd .= ' --standalone'
  let l:pandoc_cmd .= ' --embed-resources'
  let l:pandoc_cmd .= ' --highlight-style=tango'
  let l:pandoc_cmd .= ' --metadata lang=en'
  let l:pandoc_cmd .= ' --metadata pagetitle=' . shellescape(expand('%:t'))
  let l:pandoc_cmd .= ' --css=' . shellescape(s:GetMarkdownCSS())
  let l:pandoc_cmd .= ' -o ' . shellescape(l:html_file)
  let l:pandoc_cmd .= ' ' . shellescape(l:source_file)

  " Run pandoc conversion
  let l:output = system(l:pandoc_cmd)
  if v:shell_error != 0
    echohl ErrorMsg
    echom 'ERROR: Pandoc conversion failed!'
    echom l:output
    echohl None
    return
  endif

  " Make file readable (ensure world-readable for browser access)
  call system('chmod 644 ' . shellescape(l:html_file))

  " Open in browser
  call s:OpenInBrowser(l:html_file)

  " Set up auto-update on save
  if g:markdown_preview_auto_update
    augroup MarkdownPreviewAuto
      autocmd! BufWritePost <buffer>
      autocmd BufWritePost <buffer> silent! call s:MarkdownPreviewUpdate()
    augroup END
  endif

  echom 'Markdown preview opened: ' . l:html_file
endfunction

function! s:MarkdownPreviewUpdate()
  if !exists('b:markdown_preview_file')
    return
  endif

  let l:source_file = expand('%:p')
  let l:html_file = b:markdown_preview_file

  " Build pandoc command
  let l:pandoc_cmd = 'pandoc'
  let l:pandoc_cmd .= ' --from=gfm'
  let l:pandoc_cmd .= ' --to=html5'
  let l:pandoc_cmd .= ' --standalone'
  let l:pandoc_cmd .= ' --embed-resources'
  let l:pandoc_cmd .= ' --highlight-style=tango'
  let l:pandoc_cmd .= ' --metadata lang=en'
  let l:pandoc_cmd .= ' --metadata pagetitle=' . shellescape(expand('%:t'))
  let l:pandoc_cmd .= ' --css=' . shellescape(s:GetMarkdownCSS())
  let l:pandoc_cmd .= ' -o ' . shellescape(l:html_file)
  let l:pandoc_cmd .= ' ' . shellescape(l:source_file)

  " Run pandoc silently
  call system(l:pandoc_cmd)
  if v:shell_error == 0
    echom 'Markdown preview updated'
  endif
endfunction

function! s:MarkdownPreviewStop()
  if exists('b:markdown_preview_file')
    augroup MarkdownPreviewAuto
      autocmd! BufWritePost <buffer>
    augroup END
    unlet b:markdown_preview_file
    echom 'Markdown preview auto-update stopped'
  else
    echom 'No active markdown preview for this buffer'
  endif
endfunction

function! s:MarkdownPreviewToggle()
  if exists('b:markdown_preview_file')
    call s:MarkdownPreviewStop()
  else
    call s:MarkdownPreview()
  endif
endfunction

function! s:OpenInBrowser(file)
  let l:file_url = 'file://' . a:file

  if has('unix')
    if executable('xdg-open')
      call system('xdg-open ' . shellescape(a:file) . ' >/dev/null 2>&1 &')
    elseif executable('firefox')
      call system('firefox ' . shellescape(a:file) . ' >/dev/null 2>&1 &')
    elseif executable('chromium-browser')
      call system('chromium-browser ' . shellescape(a:file) . ' >/dev/null 2>&1 &')
    elseif executable('google-chrome')
      call system('google-chrome ' . shellescape(a:file) . ' >/dev/null 2>&1 &')
    else
      echohl WarningMsg
      echom 'No browser found. Open manually: ' . a:file
      echohl None
    endif
  elseif has('mac')
    call system('open ' . shellescape(a:file))
  elseif has('win32')
    call system('start ' . shellescape(a:file))
  else
    echom 'Open in browser: ' . a:file
  endif
endfunction

function! s:GetMarkdownCSS()
  let l:css_file = g:markdown_preview_dir . '/style.css'

  " Create CSS file if it doesn't exist
  if !filereadable(l:css_file)
    let l:css_content = [
      \ 'body {',
      \ '  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;',
      \ '  font-size: 16px;',
      \ '  line-height: 1.6;',
      \ '  color: #333;',
      \ '  background-color: #fff;',
      \ '  max-width: 900px;',
      \ '  margin: 0 auto;',
      \ '  padding: 2rem;',
      \ '}',
      \ 'code {',
      \ '  background-color: #f6f8fa;',
      \ '  padding: 0.2em 0.4em;',
      \ '  border-radius: 3px;',
      \ '  font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;',
      \ '  font-size: 85%;',
      \ '}',
      \ 'pre {',
      \ '  background-color: #f6f8fa;',
      \ '  padding: 1rem;',
      \ '  border-radius: 6px;',
      \ '  overflow-x: auto;',
      \ '}',
      \ 'pre code {',
      \ '  background-color: transparent;',
      \ '  padding: 0;',
      \ '}',
      \ 'h1, h2, h3, h4, h5, h6 {',
      \ '  margin-top: 1.5em;',
      \ '  margin-bottom: 0.5em;',
      \ '  font-weight: 600;',
      \ '  line-height: 1.25;',
      \ '}',
      \ 'h1 { font-size: 2em; border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; }',
      \ 'h2 { font-size: 1.5em; border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; }',
      \ 'h3 { font-size: 1.25em; }',
      \ 'a { color: #0366d6; text-decoration: none; }',
      \ 'a:hover { text-decoration: underline; }',
      \ 'img { max-width: 100%; }',
      \ 'table { border-collapse: collapse; width: 100%; margin: 1em 0; }',
      \ 'table th, table td { border: 1px solid #dfe2e5; padding: 0.6em 1em; }',
      \ 'table th { background-color: #f6f8fa; font-weight: 600; }',
      \ 'blockquote {',
      \ '  margin: 0;',
      \ '  padding: 0 1em;',
      \ '  color: #6a737d;',
      \ '  border-left: 0.25em solid #dfe2e5;',
      \ '}',
      \ '@media (prefers-color-scheme: dark) {',
      \ '  body { background-color: #0d1117; color: #c9d1d9; }',
      \ '  code, pre { background-color: #161b22; }',
      \ '  h1, h2 { border-bottom-color: #21262d; }',
      \ '  table th, table td { border-color: #30363d; }',
      \ '  table th { background-color: #161b22; }',
      \ '  blockquote { color: #8b949e; border-left-color: #30363d; }',
      \ '  a { color: #58a6ff; }',
      \ '}',
      \ ]
    call writefile(l:css_content, l:css_file)
  endif

  return l:css_file
endfunction

" Commands
command! MarkdownPreview call s:MarkdownPreview()
command! MarkdownPreviewStop call s:MarkdownPreviewStop()
command! MarkdownPreviewToggle call s:MarkdownPreviewToggle()

" ============================================================================
" Status Line (if airline is not loaded)
" ============================================================================
if !exists('g:loaded_airline')
  set laststatus=2
  set statusline=%f\ %m%r%h%w\ [%Y]\ [%{&ff}]\ %=[%l,%c]\ %p%%
endif

" ============================================================================
" Startup Profiling & Performance Helpers
" ============================================================================
if !exists('g:vim_start_time')
  let g:vim_start_time = reltime()
endif
augroup startup_timing
  autocmd!
  autocmd VimEnter * if exists('g:vim_start_time') | let s:elapsed = reltimefloat(reltime(g:vim_start_time))*1000 | echom printf('Startup time: %.1f ms', s:elapsed) | endif
augroup END

function! s:StartProfile()
  if exists('g:profiling_active')
    echom 'Profiling already active'
    return
  endif
  let g:profiling_active = 1
  profile start ~/.vim/profile.log
  profile file *
  profile func *
  echom 'Profiling started -> ~/.vim/profile.log'
endfunction

function! s:StopProfile()
  if !exists('g:profiling_active')
    echom 'Profiling not active'
    return
  endif
  profile pause
  unlet g:profiling_active
  echom 'Profiling paused (inspect ~/.vim/profile.log)'
endfunction

command! ProfileStart call s:StartProfile()
command! ProfileStop  call s:StopProfile()

" External full startup timing tip:
"   vim --startuptime /tmp/vim-startup.log +q && less /tmp/vim-startup.log
