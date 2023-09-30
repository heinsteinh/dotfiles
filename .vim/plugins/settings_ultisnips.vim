
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UltiSnip
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"


"let g:UltiSnipsJumpBackwardTrigger = "<Left>"
"let g:UltiSnipsJumpForwardTrigger = "<Right>"


" UltiSnips settings {{{
let g:snips_author = 'F. Wheezy'
" Trigger configuration. Do not use <tab> if you use YouCompleteMe.
let g:UltiSnipsExpandTrigger = '<C-Space>'
let g:UltiSnipsJumpForwardTrigger = '<C-Space>'
let g:UltiSnipsJumpBackwardTrigger = '<C-b>'
let g:UltiSnipsListSnippets = '<C-l>'
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsEnableSnipMate = 0
" let g:UltiSnipsSnippetDirectories = [
"             \ fnamemodify($MYVIMRC, ':h') .'/UltiSnips']

let g:ultisnips_python_style = "google"
let g:ultisnips_python_quoting_style = "single"
let g:ultisnips_python_triple_quoting_style = "double"
let g:UltiSnipsSnippetDirectories=['$HOME/$VIMFILE_DIR/snippets']
let g:UltiSnipsSnippetsDir = '$HOME/$VIMFILE_DIR/snippets'


" }}}
"
