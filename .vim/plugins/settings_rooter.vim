" lcd does cd for window only; tcd does cd fon tab only
"let g:rooter_cd_cmd = 'tcd'

" follow symlinks
let g:rooter_resolve_links = 1

" pattern for identifying a directory; = prefix means dir instead of file
let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.vc','.svn', 'Makefile', '=src']

