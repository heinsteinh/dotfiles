let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/.vim/*', '~/work/*', '~/Documents/*', '~/Projects/*', 'W:\', ]

"let g:ycm_key_list_stop_completion = [ '<C-y>', '<Enter>' ]
" Mapping to close the completion menu (default <C-y>)
let g:ycm_key_list_stop_completion = ['<C-x>', '<CR>']

let g:ycm_key_list_select_completion = ['<C-n>', '<M-j>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<M-k>']

" Set filetypes where YCM will be turned on
let g:ycm_filetype_whitelist = { 'cpp':1, 'h':2, 'hpp':3, 'c':4, 'cxx':5 }

" Close preview window after completing the insertion
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

"let g:ycm_confirm_extra_conf = 0                 " Don't confirm python conf
let g:ycm_always_populate_location_list = 1      " Always populae diagnostics list
let g:ycm_enable_diagnostic_signs = 1            " Enable line highligting diagnostics
let g:ycm_open_loclist_on_ycm_diags = 1          " Open location list to view diagnostics

let g:ycm_max_num_candidates = 20                " Max number of completion suggestions 
let g:ycm_max_num_identifier_candidates = 10     " Max number of identifier-based suggestions
let g:ycm_auto_trigger = 1                       " Enable completion menu
let g:ycm_show_diagnostic_ui = 1                 " Show diagnostic display features
let g:ycm_error_symbol = '>>'                    " The error symbol in Vim gutter
let g:ycm_enable_diagnostic_signs = 1            " Display icons in Vim's gutter, error, warnings
let g:ycm_enable_diagnostic_highlighting = 1     " Highlight regions of diagnostic text
let g:ycm_echo_current_diagnostic = 1            " Echo line's diagnostic that cursor is on
let g:ycm_filetype_blacklist={
            \ 'tagbar' : 1,
            \ 'qf' : 1,
            \ 'notes' : 1,
            \ 'markdown' : 1,
            \ 'unite' : 1,
            \ 'text' : 1,
            \ 'vimwiki' : 1,
            \ 'pandoc' : 1,
            \ 'infolog' : 1,
            \ 'mail' : 1,
            \ 'tex' : 1
            \}
" make YCM compatible with UltiSnips (using supertab)
"let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"let g:SuperTabDefaultCompletionType = '<C-n>

let g:ycm_log_level = 'debug'
let g:ycm_extra_conf_vim_data = [
            \'g:my_project_root'
            \]

if executable('clangd')
    let g:ycm_clangd_binary_path = 'clangd'
endif


" ==============================================================================
" YouCompleteMe
" ==============================================================================
nnoremap <Leader>jj :YcmCompleter GoToDefinition <cr>zt
nnoremap <Leader>jJ :YcmCompleter GoToDefinition <cr> :-tabnew<cr><C-O><C-O>:tabnext<cr>
nnoremap <Leader>jd :YcmCompleter GoToDeclaration <cr>zt
nnoremap <Leader>jk :YcmCompleter GetType <cr>
nnoremap <Leader>jf :YcmCompleter FixIt <cr>

 " common YCM mappings

nnoremap <buffer> <Leader>dg :YcmDiags<CR>
nnoremap <buffer> <Leader>fi :YcmCompleter FixIt<CR>
nnoremap <buffer> <Leader>gt :YcmCompleter GetType<CR>
nnoremap <buffer> <Leader>gd :YcmCompleter GoTo<CR>
nnoremap <buffer> <Leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <buffer> <Leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <buffer> <Leader>gi :YcmCompleter GoToImplementation<CR>
nnoremap <buffer> <Leader>re :YcmCompleter GoToReferences<CR>
nnoremap <buffer> <Leader>rf :YcmCompleter RefactorRename<Space>
nnoremap <buffer> <Leader>im :YcmCompleter OrganizeImports<CR>
