set nocompatible        " Use Vim settings, rather than Vi settings
set langmenu=en
set encoding=utf-8

set nobackup
set nowritebackup
set noswapfile


" " Use commas as leaders
let mapleader = ','
" let maplocalleader = ','
" let g:mapleader = ','

"let mapleader = "\<Space>"
"let maplocalleader =  "\<Space>"
"let g:mapleader = "\<Space>"
"let g:maplocalleader = ','


"{{{ OS Variable initialization and Config Dir
let g:is_win   = has('win32') || has('win64')
let g:is_mac   = has('mac') || system('uname') =~? '^darwin'
let g:is_linux = !g:is_mac && has('unix')
"}}}


"{{{ Simple Branch Template Example
if g:is_win
elseif g:is_mac
elseif g:is_linux
endif

if g:is_win
elseif g:is_linux
endif

let g:unicode = g:is_linux && has("gui_running")


if g:is_win
    :let $VIMFILE_DIR = 'vimfiles'
else
    :let $VIMFILE_DIR = '.vim'
endif

"echo "Current Hostname :: "
"echo hostname()
"echo $HOME
"echo $VIMFILE_DIR


if g:is_win

    "set filetype=dos
    "set ffs=dos,unix,mac
    set path=.,C:\DevPath\ag\
elseif g:is_linux

    "set filetype=unix
    "set ffs=unix
    set path=.,/usr/include/,/usr/include/c++/4.7/ "c++ is in /usr/include/c++/
    " Allows you to enter sudo pass and save the file
    " " when you forgot to open your file with sudo
    cmap w!! %!sudo tee > /dev/null %
endif



"{{{ Plugin Installation Section
filetype off                  " required
if executable('git') &&  empty(glob("$HOME/$VIMFILE_DIR/bundle/Vundle.vim"))
    silent execute '!git clone https://github.com/VundleVim/Vundle.vim.git  $HOME/$VIMFILE_DI/bundle/Vundle.vim'

    let s:setupvundle=1
endif

if !empty(glob("$HOME/$VIMFILE_DIR/bundle/Vundle.vim"))

    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')

    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'


    source $HOME/$VIMFILE_DIR/plugins_vimrc.vim


    " All of your Plugins must be added before the following line
    call vundle#end()            " required
    filetype plugin indent on    " required
    " To ignore plugin indent changes, instead use:

    " This automatically installs plugins on first time vundle setup
    " to install plugins manually run $vim +PluginInstall +qa
    if exists('s:setupvundle') && s:setupvundle
        unlet s:setupvundle
        PluginInstall
        quitall " Close the bundle install window.
    endif

endif



" Golden Ratio:
" This should disable the plugin, use :GoldenRatioToggle to reenable.
"let g:loaded_golden_ratio=1

" show errors in different Colors
highlight Errors ctermbg=green guibg=darkred

"}}}



"{{{ Settings Section
source $HOME/$VIMFILE_DIR/settings_vimrc.vim



"{{{ Source architecture config dependency
if g:is_win
    if filereadable(expand('$HOME/$VIMFILE_DIR/vimrc.win'))
        "echo "sourcing win dir
        source $HOME/$VIMFILE_DIR/vimrc.win
    endif
elseif g:is_mac
    if filereadable(expand("$HOME/$VIMFILE_DIR/vimrc.mac"))
        source  $HOME/$VIMFILE_DIR/vimrc.mac
    endif
elseif g:is_linux
    if filereadable(expand("$HOME/$VIMFILE_DIR/vimrc.linux"))
        source  $HOME/$VIMFILE_DIR/vimrc.linux
    endif
endif
"}}}
"}}}


set background=dark
"set background=light
"set t_Co=256
"colorscheme desert " Set nice looking colorscheme
"colorscheme herald " Set nice looking colorscheme
"colorscheme oceanic_material
"colorscheme PaperColor
colorscheme OceanicNext
"colorscheme gruvbox
"colorscheme onedark
"colorscheme atom

"let g:gruvbox_bold='1'
"let g:gruvbox_italic='1'
"let g:gruvbox_transparent_bg='1'
"let g:gruvbox_italicize_comments='1'
"autocmd vimenter * ++nested colorscheme gruvbox

"colorscheme neodark
"colorscheme onedark
" Vimscript initialization file
"colorscheme nightfly


