"{{{ Copy/Paste
""https://github.com/jwbat/dotfiles/blob/4fc36a3eda20ed4467b21dd863507fa2c31b80d5/.vimrc#L131
"Good Register paste example in this link

let g:uname = system("uname")

" =clipboard
" Copy and paste to system clipboard
vnoremap <C-c> "+y
vnoremap <C-x> "+c


" Copy entire file to clipboard
nnoremap Y :%y+<cr>

" remap movement keys so that up-down work over visual lines rather than
" actual lines
noremap j gj
noremap k gk

"remap jk/kj to escape
inoremap jk <Esc>
inoremap kj <Esc>


" quick scroll down/up
nnoremap J Lzz
vnoremap J Lzz
nnoremap K Hzz
vnoremap K Hzz


" Map 0 to first non-blank character
nnoremap 0 ^

" Move to the end of the line
nnoremap L $zL
vnoremap L $
nnoremap H 0zH
vnoremap H 0


" center window when moving to next search match
nnoremap n  nzzzv
nnoremap N  Nzzzv
nnoremap *  *zz
nnoremap #  #zz
nnoremap g* g*zz
nnoremap g# g#zz


" Copy number of lines and paste below
nnoremap <leader>cp :<c-u>exe 'normal! y' . (v:count == 0 ? 1 : v:count) . 'j' . (v:count == 0 ? 1 : v:count) . 'jo<C-v><Esc>p'<cr>


" noh - no highlight
map <esc> :noh <CR>

" Backspace in normal mode
nnoremap <bs> d0<Left>
" CTRL-D to delete line
inoremap <C-D> <Esc>dd<Insert>
nnoremap <C-D> dd
" CTRL-Z to undo
inoremap <C-Z> <Esc>u<Insert>
nnoremap <C-Z> u
" CTRL-Y to redo
inoremap <C-Y> <Esc><C-R><Insert>
nnoremap <C-Y> <C-R>
" CTRL-S to save
inoremap <C-S> <Esc>:w<Enter><Insert>
nnoremap <C-S> :w<Enter>

" [COMMAND+INSERT+VISUAL] CTRL-S Save file
nnoremap <C-s> :w!<CR>
inoremap <C-s> <esc>:w!<CR>gi
vnoremap <C-s> <esc>:w!<CR>gv=gv





"Vimrc quick edit
nnoremap <Leader>pv :split $MYVIMRC<CR>
nnoremap <Leader>vv :vsplit $MYVIMRC<CR>
nnoremap <Leader>rv :source $MYVIMRC<CR>
nnoremap <Leader>r  :source $MYVIMRC<CR>:echo "Reloaded: " . $MYVIMRC<CR>
nnoremap <Leader>tv :tabnew $MYVIMRC<CR>
nnoremap <Leader>ev :edit $MYVIMRC<CR>


imap <leader>rt <esc>:call RemoveTabs()<cr>
nmap <leader>rt :call RemoveTabs()<cr>
vmap <leader>rt <esc>:call RemoveTabs()<cr>

" }}}


