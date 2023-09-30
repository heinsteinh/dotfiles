" backupFiles.vim
" redirect where all the backup files get stored
" Paul Rohwer August 21, 2020
"
"
" Windows only.

"set nobackup       "no backup files
"set nowritebackup  "only in case you don't want a backup file while editing
"set noswapfile     "no swap files


" Persist undo changes to disk
set undofile
" Number of undos to save.
set undolevels=10000
" If the files is less then 10000 lines, this will store the file for undo when reloading (autoread, :e, etc).
set undoreload=10000

let s:MSWIN = has("win16") || has("win32")   || has("win64")    || has("win95")
if s:MSWIN
    set backup
    set backupext=.bak
    set backupdir=C:\Temp\vim\backup\\
    set backupskip=C:\Temp\vim\backup_skip\*
    set directory=C:\Temp\vim\swp\\
    set writebackup
    set undodir=C:\Temp\vim\undodir\\
else
    set backup
    set backupext=.bak
    set backupdir=~/tmp/vim/backup//
    set backupskip=~/tmp/vim/backup_skip/*
    set directory=~/tmp/vim/swp//
    set writebackup
    set undodir=~/tmp/vim/undodir//
endif


" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif
if !isdirectory(expand(&backupskip))
    call mkdir(expand(&backupskip), "p")
endif

let s:viminfo_dir = expand('$HOME/$VIMFILE_DIR/files/info')
if !isdirectory(expand(s:viminfo_dir))
    call mkdir(expand(s:viminfo_dir), "p")
endif

" " Restore buffer list, marks are remembered for 9999 files, memory registers up to 512Kb are remembered.
set viminfo=%,'9999,s512,n$HOME/$VIMFILE_DIR/files/info/viminfo

let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
endif

" vim: tabstop=2 shiftwidth=2 foldmethod=marker expandtab
