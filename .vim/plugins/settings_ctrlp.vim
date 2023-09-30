"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---------- Ctrl-P stuff --------------

"  Put ctrl p at the bottom ordererf from top to bottom
let g:ctrlp_match_window='bottom,order:ttb,min:1,max:20,results:20'


if g:is_win

    "Use a custom file listing command:
    let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
    set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

    "echo "Use Windows dir for CtrlP search  " 
    "Use a custom file listing command:   
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
    let g:ctrlp_use_caching=1

else
    if executable ('fd')
        let g:ctrlp_user_command = 'fd --type f --color=never "" %s'
        let g:ctrlp_use_caching = 0

        "echo "Use Linux fd for CtrlP search  " 
    else
        if executable('ag')
            " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
            let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
            " ag is fast enough that CtrlP doesn't need to cache            
            let g:ctrlp_use_caching = 0

           " echo "Use Fast Linux ag  for CtrlP search  " 
        else
            let g:ctrlp_user_command = 'find %s -type f'       " MacOSX/Linux

          "  echo "Use Linux find  for CtrlP search  " 
        endif

        " use rg as our ctrlp finder
        "let g:ctrlp_user_command = 'rg %s --files --hidden --color=never --glob ""'
        let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden -g ""'
        " rg is fast enough we don't need no stinking cache
        let g:ctrlp_use_caching=0

        set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
    endif
endif


let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'


let g:ctrlp_show_hidden = 1
let g:ctrlp_match_window = 'max:25'
let g:ctrlp_max_files = 0 " Set no max file limit
let g:ctrlp_switch_buffer = 'Et'
let g:ctrlp_lazy_update = 0
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_tabpage_position = 'ac'
let g:ctrlp_clear_cache_on_exit = 0     " Hit <F5> to refresh index
let g:ctrlp_extensions = ['mixed', 'changes', 'quickfix']
let g:ctrlp_cmd='CtrlPMixed'
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll)$',
            \ 'link': 'some_bad_symbolic_links',
            \ }

"Ignore files in .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_working_path_mode = 'ra'

if executable('rg')
    set grepprg=rg\ --color=never
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
    let g:ctrlp_use_caching = 0

    let g:ctrlp_use_caching = 1
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_switch_buffer = 'et'
    let g:ackprg = 'rg --vimgrep --no-heading'


    "echo "Yes we can use rg to find in ctrlp !"
else
    let g:ctrlp_clear_cache_on_exit = 0
endif
