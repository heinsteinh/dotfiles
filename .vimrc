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


" Useful mappings
"{{{ Mappings Movement
nnoremap <leader>nt :exec ":vsp $HOME/notes/" . strftime('%m-%d-%y') . ".md"<CR>

" Double tap s to save the buffer contents,more convienent than keep the pressure on the modifier keys to be CUA compatible.
nnoremap <silent>ss :update<CR>

"Map \e to edit a file from the directory of the current buffer
nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/"<CR>

"}}}


    set t_Co=256
    set nocursorline

    if g:is_win
    elseif g:is_linux
        set term=xterm-256color
    endif



" Terminal configurations {{{
if exists(':terminal')

    if !exists('g:terminal_ansi_colors')
        let g:terminal_ansi_colors = [
                    \'#21222C',
                    \'#FF5555',
                    \'#69FF94',
                    \'#FFFFA5',
                    \'#D6ACFF',
                    \'#FF92DF',
                    \'#A4FFFF',
                    \'#FFFFFF',
                    \'#636363',
                    \'#F1FA8C',
                    \'#BD93F9',
                    \'#FF79C6',
                    \'#8BE9FD',
                    \'#F8F8F2',
                    \'#6272A4',
                    \'#FF6E6E'
                    \]
    endif

    " Function to set terminal colors
    fun! s:setTerminalColors()
        if exists('g:terminal_ansi_colors')
            for i in range(len(g:terminal_ansi_colors))
                exe 'let g:terminal_color_' . i . ' = g:terminal_ansi_colors[' . i . ']'
            endfor
            unlet! g:terminal_ansi_colors
        endif
    endfunction

    augroup TerminalAugroup
        autocmd!

        " Start terminal in insert mode
        autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

        " Call terminal colors function only after colorscheme changed
        autocmd Colorscheme * call <sid>setTerminalColors()
    augroup END

    tnoremap <Esc> <C-\><C-n>

    " To force using 256 colors
    set t_Co=256
endif

" }}}


source $HOME/$VIMFILE_DIR/plugins/settings_nerdtree.vim
source $HOME/$VIMFILE_DIR/plugins/settings_rooter.vim
source $HOME/$VIMFILE_DIR/plugins/settings_tagbar.vim
source $HOME/$VIMFILE_DIR/plugins/settings_ultisnips.vim
source $HOME/$VIMFILE_DIR/plugins/settings_airline.vim
source $HOME/$VIMFILE_DIR/plugins/settings_ycm.vim
source $HOME/$VIMFILE_DIR/plugins/settings_rainbow.vim
source $HOME/$VIMFILE_DIR/plugins/settings_startify.vim
source $HOME/$VIMFILE_DIR/plugins/settings_ctrlp.vim

source $HOME/$VIMFILE_DIR/plugins/backupFiles.vim
source $HOME/$VIMFILE_DIR/plugins/color-devicons.vim
source $HOME/$VIMFILE_DIR/plugins/backupFiles.vim
source $HOME/$VIMFILE_DIR/plugins/automkdir.vim
source $HOME/$VIMFILE_DIR/plugins/diminactive.vim
source $HOME/$VIMFILE_DIR/plugins/settings_fzf.vim




"" Cursor style {{{
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (Eu)
"}}}


"{{{ AutoCommand
if has ('autocmd') " Remain compatible with earlier versaons
    " automatically rebalance windows on vim resize
    "autocmd VimResized * :wincmd =

    " autowrite[all] only saves in certain situations, leaving a window is another situation that I think should autosave.
    augroup AutoWrite
        au!
        au WinLeave * silent! update
    augroup end

    " Center the cursor when switching to a buffer.
    augroup BufCursorCenter
        au!
        au BufWinEnter * normal zz
    augroup end

    " Save the reltime that vim starts.
    augroup StartTime
        au!
        au VimEnter * let g:start_time=reltime()
    augroup end

    " Disables the swap file for unmodified buffers.
    augroup SwpControl
        au!
        autocmd BufWritePost,BufReadPost,BufLeave *
                    \ if isdirectory(expand("<amatch>:h")) | let &l:swapfile = &modified | endif
    augroup end

    " Automatically write any updates in the current file when focus is lost.
    augroup focuslost
        au!
        au FocusLost * silent! update
    augroup end

    let g:large_fsize = 10
    augroup LargeFile
        au!
        autocmd BufReadPre *
                    \ let f=getfsize(expand("<afile>")) / 1024 / 1024 | if f > g:large_fsize || f == -2 | call LargeFile() | endif
    augroup end

    " Make terminal-mode not wrap lines, because it does it wrong: https://github.com/vim/vim/issues/2865
    " Also disable spell checking because it highlights stupid stuff like powerline glyphs.
    " Disabled - Suspend job output when leaving the buffer or window, so that the window fades correctly.
    augroup termft
        au!
        au BufEnter,BufWinEnter *
                    \ if &buftype=='terminal'
                    \ |   setlocal nowrap
                    \ |   setlocal nospell
                    \ | endif
        " au FocusLost,WinLeave *
        "   \ if &buftype=='terminal' && mode() == 't'
        "   \ |   call feedkeys("\<C-\>\<C-N>", 'x')
        "   " \ |   call term_setsize('', term_getsize('')[0], term_getsize('')[1]+6)
        "   \ | endif
    augroup end

    " Allow escape in fzf windows.
    augroup fzfft
        au!
        au FileType fzf tmap <buffer> <Esc> <Esc>
    augroup end

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler (happens when dropping a file on gvim) and
    " for a commit message (it's likely a different one than last time).
    augroup autocursorpos
        au!
        autocmd BufReadPost *
                    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                    \ |   exe "normal! g`\""
                    \ | endif
    augroup end


    "autocmd BufEnter * silent! lcd %:p:h
    "autocmd BufEnter .vimrc,*.vim,*.cpp,*.c,*.java,*.py :TagbarOpen
    "autocmd BufEnter *.cpp,*.c,*.java,*.py :TagbarOpen

    "autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

    " Automatic rename of tmux window
    " if exists('$TMUX') && !exists('$NORENAME)
    if exists('$TMUX')
        " if &term =~ "screen"
        augroup vimrc-screen
            autocmd!
            autocmd BufEnter * call system("tmux rename-window " . "'[" . expand("%:t") . "]'")
            autocmd VimLeave * call system("tmux set-window automatic-rename on")
            autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
        augroup END
    end



    " Code folding for VimScript files
    " Not sure why the foldmethod isn't set to marker
    augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
        autocmd FileType vim setlocal foldmarker={{{,}}}
        autocmd FileType go setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
    augroup END


    " " Special tab-spacing for C files
    " augroup filetype_c
    " 	autocmd!
    " 	autocmd FileType c setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
    " 	autocmd FileType c setlocal foldmethod=marker
    " 	autocmd FileType c setlocal foldmarker={,}
    " augroup END
    "
endif " has autocmd


