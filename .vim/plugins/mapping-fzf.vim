" Mappings
noremap <Leader>ff :Files<CR>
noremap <Leader>fg :GFiles<CR>
noremap <Leader>fs :GFiles?<CR>
noremap <Leader>fb :Buffers<CR>
noremap <Leader>fc :Colors<CR>
noremap <Leader>ft :Tags<CR>

" Custom statusline
function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()

" Help
" :Files [PATH]	Files (runs $FZF_DEFAULT_COMMAND if defined)
" :GFiles [OPTS]	Git files (git ls-files)
" :GFiles?	Git files (git status)
" :Buffers	Open buffers
" :Colors	Color schemes
" :Ag [PATTERN]	ag search result (ALT-A to select all, ALT-D to deselect all)
" :Rg [PATTERN]	rg search result (ALT-A to select all, ALT-D to deselect all)
" :Lines [QUERY]	Lines in loaded buffers
" :BLines [QUERY]	Lines in the current buffer
" :Tags [QUERY]	Tags in the project (ctags -R)
" :BTags [QUERY]	Tags in the current buffer
" :Marks	Marks
" :Windows	Windows
" :Locate PATTERN	locate command output
" :History	v:oldfiles and open buffers
" :History:	Command history
" :History/	Search history
" :Snippets	Snippets (UltiSnips)
" :Commits	Git commits (requires fugitive.vim)
" :BCommits	Git commits for the current buffer; visual-select lines to track changes in the range
" :Commands	Commands
" :Maps	Normal mode mappings
" :Helptags	Help tags 1
" :Filetypes	File types
