"let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
let g:fzf_layout = { 'down': '~50%' }
" Preview window on the upper side of the window with 40% height,
" hidden by default, ctrl-/ to toggle

"let g:fzf_layout = { 'down': '~30%' }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

if g:is_win
    let g:fzf_history_dir = 'c:/temp/pzf-history'
elseif g:is_linux
    let g:fzf_history_dir = '$HOME/.local/share/fzf-history'
endif


set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

"let g:fzf_tags_command = 'ctags -R'
" Border color
"let g:fzf_layout = { 'window': 'e}
"let g:fzf_layout = { 'window': '10split enew' }
"let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
"let $FZF_DEFAULT_COMMAND="rg --files --hidden"



"" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'


" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
          \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

" The Silver Searcher
if executable('ag')

    nnoremap  <silent><Leader>f :Ag<cr>
    nnoremap  <silent><C-f> :Ag<cr>

    let g:ackprg = 'ag --vimgrep'
    let s:fzf_custom_command = 'ag --hidden -l --nocolor --nogroup '.'
                \ --ignore "*.[odODaA]"
                \ --ignore "*.exe"
                \ --ignore "*.out"
                \ --ignore "*.hex"
                \ --ignore "cscope*"
                \ --ignore "*.so"
                \ --ignore "*.dll"
                \ --ignore ".git"
                \ -g ""'
    let $FZF_DEFAULT_COMMAND=s:fzf_custom_command
    "echo "fzf Using silver search Ag"
endif

" ripgrep
if executable('rg')

    let s:fzf_custom_command = 'rg -H --hidden -l'.'
                \ -g "!*.out" -g "!*.hex" -g "!*.bin"
                \ -g "!*.exe" -g "!*.so" -g "!*.dll"
                \ -g "!cscope*"
                \ -g "!.git/*" -g "!.svn/*" -g "!.hg/*"
                \ ""'
    let $FZF_DEFAULT_COMMAND=s:fzf_custom_command

     set grepprg=ag\ --nogroup\ --nocolor

    "  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    "  set grepprg=rg\ --vimgrep
    nnoremap  <silent><Leader>f :Rg <cr>
    nnoremap  <silent><C-f> :Rg <cr>
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

    "echo "fzf Using ripgrep"
endif


" if executable('rg')
"     set grepprg=rg\ --vimgrep
"     command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "\!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
" elseif executable('ag')
"     set grepprg=ag\ --nogrup\ --nocolor
" endif


"FZF keymaps
" https://github.com/junegunn/fzf.vim#commands
nnoremap <C-f>  :Files<CR>
nnoremap <leader>fb  :Buffers<CR>
"nnoremap <leader>ff  :Files<CR>
"nnoremap <leader>fg  :GFiles<CR>
nnoremap <leader>fg  :Ag<CR>
nnoremap <leader>fr  :Rg<cr>
nnoremap <leader>fl  :Lines<CR>
nnoremap <leader>fh  :History<CR>
nnoremap <leader>;   :History<CR>
nnoremap <leader>fs  :Snippets<CR>
nnoremap <leader>fco :Commits<CR>
nnoremap <leader>fcb :BCommits<CR>
nnoremap <leader>fw  :Windows<CR>
nnoremap <leader>fc  :Commands<cr>
nnoremap <leader>fm  :Maps<cr>

nnoremap <leader>ff  :FzfFunky<cr>
nnoremap <leader>fd  :call <SID>fzfrun_dir()<cr>


function! s:fzfrun_dir_sink(item) abort
    if len(a:item) < 2 | return | endif
    let l:pos = stridx(a:item[1], ' ')
    let l:file_path = a:item[1][pos+1:-1]
    if a:item[0] ==? 'tab'
        " :redraw!
        execute 'cd '. l:file_path
        call s:fzfrun_dir()
    elseif a:item[0] ==? 'shift-tab'
        execute 'cd ..'
        call s:fzfrun_dir()
    else
        execute 'cd '. l:file_path
    endif
endfunction

function! s:fzfrun_dir() abort
    let short = fnamemodify(getcwd(), ':~:.')
    if !has('win32unix')
        let short = pathshorten(short)
    endif
    let slash = (g:is_win && !&shellslash) ? '\' : '/'
    let dir =  empty(short) ? '~'.slash : short . (short =~ escape(slash, '\').'$' ? '' : slash)
    let l:prompts = strwidth(dir) < &columns / 2 - 20 ? dir : '> '
    let l:run_dict = {
                \ 'source': 'find -maxdepth 2 -type d',
                \ 'sink*' : function('<SID>fzfrun_dir_sink'),
                \ 'window':{'width':0.8,'height':0.6},
                \ 'options':'--ansi --expect=tab,shift-tab --delimiter : '. '--prompt '. prompts,
                \ }
    if g:is_win
        call extend(l:run_dict,{'source':'dir /b /a:d'})
    endif
    call fzf#run(l:run_dict)
endfunction


""
" @private
" Get file and devicons
" From: https://github.com/ryanoasis/vim-devicons/issues/106
function! s:FzfFilesWithDevIcons() abort
    if executable('bat')
        let l:fzf_files_options = printf('--preview "bat %s %s | head -%s"',
                    \ '--style=numbers,changes --color always',
                    \ exists('*WebDevIconsGetFileTypeSymbol') ? '{2..-1}' : '{}',
                    \ &lines)
    else
        let l:fzf_files_options = ''
    endif

    function! s:GetFiles()
        let l:files = split(system($FZF_DEFAULT_COMMAND), "\n")
        return <sid>PrependIcon(l:files)
    endfunction

    function! s:PrependIcon(candidates)
        let l:result = []
        for candidate in a:candidates
            let l:fname = fnamemodify(candidate, ':p:t')
            if exists('*WebDevIconsGetFileTypeSymbol')
                let l:icon = WebDevIconsGetFileTypeSymbol(l:fname, isdirectory(l:fname))
                call add(l:result, printf('%s %s', l:icon, candidate))
            else
                call add(l:result, candidate)
            endif
        endfor
        return l:result
    endfunction

    function! s:EditFile(item)
        let l:pos = stridx(a:item, ' ')
        let l:file_path = a:item[pos+1:-1]
        execute 'silent e' l:file_path
    endfunction

    call fzf#run({
                \ 'source': <sid>GetFiles(),
                \ 'sink': function('s:EditFile'),
                \ 'options': '-m ' . l:fzf_files_options,
                \ 'down': '40%' })
endfunction

command! FzfFilesWithDevIcons call <sid>FzfFilesWithDevIcons()
nnoremap <silent> <leader>fff :FzfFilesWithDevIcon<cr>


" similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)

" command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GGrep
            \ call fzf#vim#grep(
            \   'git grep --line-number '.shellescape(<q-args>), 0,
            \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

" augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], [preview window], [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Bat: https://github.com/sharkdp/bat
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
            \ call fzf#vim#ag(<q-args>,
            \                 <bang>0 ? fzf#vim#with_preview('up:60%')
            \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
            \                 <bang>0)



" FZZ mapping
nmap ; :Buffers<CR>
"nmap <Leader>t :Files<CR>
"nmap <Leader>ta :Tags<CR>

" RG SETTINGS
nnoremap <leader>a :Rg<space>
nnoremap <leader>A :exec "Rg ".expand("<cword>")<cr>


autocmd VimEnter * command! -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color  "always" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

