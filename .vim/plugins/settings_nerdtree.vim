" nerdtree icons conf
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc','\~$','\.swp', '\.DS_Store', "\idea", '\.temp', '\.git']

let g:NERDTreeHijackNetrw=0
"{{{
" Start NERDTree and leave the cursor in it.
"autocmd VimEnter * NERDTree
let NERDTreeShowHidden=1
let NERDTreeShowBookmarks = 1   " Display bookmarks on startup.

" Basically disable nerdtree markers
let NERDTreeDirArrowExpandable=">"
let NERDTreeDirArrowCollapsible="v"

noremap <leader>ne :NERDTreeFind<cr>
noremap <F7> :NERDTreeToggle %<CR>
noremap <F4> :lcd %:p:h<CR>:NERDTreeCWD<CR>

" don;t show these file types
"let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

" Enable folder icons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

"}}}

"{{{

"------------------------------------------------------------------------------
" Set up netrw instead of Nerdtree (save a plugin)
"------------------------------------------------------------------------------
" Make it look cleaner like NERDTree
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_winsize=25

" Function to toggle explorer on and off
let g:NetrwIsOpen=0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

" Toggle explorer with leader+e (use 'v' and 'o' to open in splits)
noremap <silent> <leader>e  :call ToggleNetrw()<CR>
"}}}
