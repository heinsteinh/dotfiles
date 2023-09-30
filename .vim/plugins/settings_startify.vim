" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" Read ~/.NERDTreeBookmarks file and takes its second column
function! s:nerdtreeBookmarks()
    let bookmarks = systemlist("cut -d' ' -f 2- $HOME/.NERDTreeBookmarks")
    let bookmarks = bookmarks[0:-2] " Slices an empty last line
    return map(bookmarks, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_session_dir = '$HOME/$VIMFILE_DIR/sessions'
"let g:startify_session_dir=expand("$USERPROFILE").'\vimfiles\startify-sessions'
let g:startify_lists = [
            \ { 'type': 'files',     'header': ['   Files']            },
            \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ { 'type': function('s:gitUntracked'),      'header': [' Git Utracked']},
            \ { 'type': function('s:gitModified'),       'header': [' Git Modified']},
            \ { 'type': function('s:nerdtreeBookmarks'), 'header': [' NERDTreeBookmarks']},
            \ ]

let g:startify_bookmarks = [
            \ { 'c': '~/.config/herbstlufwm/autostart' },
            \ { 'i': '~/.vimrc' },
            \ { 'z': '~/.zshrc' },
            \ '~/Blog',
            \ '~/Code',
            \ '~/Project',
            \ ]

"let g:startify_bookmarks = systemlist("cut -sd' ' -f 2- ~/.NERDTreeBookmarks")

"let g:startify_session_autoload = 1
"let g:startify_session_delete_buffers = 1
"let g:startify_change_to_vcs_root = 1


""Let Startify take care of buffers
let g:startify_session_delete_buffers = 1

""Similar to Vim-rooter
let g:startify_change_to_vcs_root = 1

""If you want Unicode
let g:startify_fortune_use_unicode = 1

""Automatically Update Sessions
let g:startify_session_persistence = 1

""Get rid of empy buffer and quit
let g:startify_enable_special = 0


" let g:startify_custom_header = [
"             \ '   _  __     _         __  ___         __     ___ ',
"             \ '  / |/ /  __(_)_ _    /  |/  /__ _____/ /    |_  |',
"             \ ' /    / |/ / /  ` \  / /|_/ / _ `/ __/ _ \  / __/ ',
"             \ '/_/|_/|___/_/_/_/_/ /_/  /_/\_,_/\__/_//_/ /____/ ',
"             \]


let g:ascii = [
            \ '        __',
            \ '.--.--.|==|.--------.',
            \ '|  |  ||  ||  .  .  |',
            \ ' \___/ |__|.__|__|__.',
            \]
