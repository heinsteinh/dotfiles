
au BufEnter *.h  let b:fswitchdst = "c,cpp,cc,m"
au BufEnter *.cpp let b:fswitchdst = "h,hpp"
au BufEnter *.h let b:fswitchdst = 'c,cpp,m,cc' | let b:fswitchlocs = 'reg:|include.*|src/**|'

" mappings
nnoremap <silent> <C-d>o :FSHere<cr>
nnoremap <silent> <C-d>h :FSSplitLeft<cr>
nnoremap <silent> <C-d>j :FSSplitBelow<cr>
nnoremap <silent> <C-d>k :FSSplitAbove<cr>
nnoremap <silent> <C-d>l :FSSplitRight<cr>



" **************************
" C/C++ switcher ...
" **************************
nnoremap <buffer> <silent> <c-z> :FSHere<cr>
" switch to the file and load it into the current window
nnoremap <silent> <leader>of :FSHere<cr>
" in current window
nnoremap <silent> <leader>oo :FSHere<cr>
" in a new tab
nnoremap <silent> <leader>ot :call FSwitch('%', 'tabedit')<cr>
" in a new tab opened before this one
nnoremap <silent> <leader>oT :call FSwitch('%', "<c-r>=tabpagenr()-1<cr>tabedit")<cr>
" switch to the file and load it into the window on the right
nnoremap <silent> <leader>ol :FSRight<cr>
" switch to the file and load it into a new window split on the right
nnoremap <silent> <leader>oL :FSSplitRight<cr>
" switch to the file and load it into the window on the left
nnoremap <silent> <leader>oh :FSLeft<cr>
" switch to the file and load it into a new window split on the left
nnoremap <silent> <leader>oH :FSSplitLeft<cr>
" switch to the file and load it into the window above
nnoremap <silent> <leader>ok :FSAbove<cr>
" switch to the file and load it into a new window split above
nnoremap <silent> <leader>oK :FSSplitAbove<cr>
" switch to the file and load it into the window below
nnoremap <silent> <leader>oj :FSBelow<cr>
" switch to the file and load it into a new window split below
nnoremap <silent> <leader>oJ :FSSplitBelow<cr>


