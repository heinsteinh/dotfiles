" tagbar
"
"
if g:is_win
    let g:tagbar_ctags_bin = 'C:\DevPath\ctags\ctags.exe'
elseif g:is_linux
endif

let tagbar_right=1
let tagbar_width=32

let g:tagbar_left=0
let g:tagbar_autofocus=1
let g:tagbar_autoclose=1
let g:tagbar_sort=0
let g:tagbar_compact=1
let g:tagbar_indent=4


" tagbar configuration
"autocmd VimEnter * nested TagbarOpen


if !exists('g:tagbar_iconchars')
    if has('multi_byte') && has('unix') && &encoding == 'utf-8' &&
     \ (empty(&termencoding) || &termencoding == 'utf-8')
        let g:tagbar_iconchars = ['▶', '▼']
    else
        let g:tagbar_iconchars = ['+', '-']
    endif
endif

let g:tagbar_type_cpp = {
            \ 'kinds' : [
                \ 'd:macros:1:0',
                \ 'g:enums:1:0',
                \ 'e:enumerators:1:0',
                \ 't:typedefs:1:0',
                \ 's:structs:1:0',
                \ 'u:unions:1:0',
                \ 'v:variables:1:0',
                \ 'm:members:0:0',
                \ 'p:prototypes',
                \ 'f:functions',
                \ 'n:namespaces',
                \ 'c:classes',
                \ ],
                \ }

let g:tagbar_type_c = {
            \ 'kinds' : [
                \ 'd:macros:1:0',
                \ 'g:enums:1:0',
                \ 'e:enumerators:1:0',
                \ 't:typedefs:1:0',
                \ 's:structs:1:0',
                \ 'u:unions:1:0',
                \ 'v:variables:1:0',
                \ 'm:members:0:0',
                \ 'p:prototypes',
                \ 'f:functions',
                \ ],
                \ }

let g:tagbar_type_cpp = {
    \ 'kinds' : [
         \ 'c:classes:0:1',
         \ 'd:macros:0:1',
         \ 'e:enumerators:0:0', 
         \ 'f:functions:0:1',
         \ 'g:enumeration:0:1',
         \ 'l:local:0:1',
         \ 'm:members:0:1',
         \ 'n:namespaces:0:1',
         \ 'p:functions_prototypes:0:1',
         \ 's:structs:0:1',
         \ 't:typedefs:0:1',
         \ 'u:unions:0:1',
         \ 'v:global:0:1',
         \ 'x:external:0:1'
     \ ],
     \ 'sro'        : '::',
     \ 'kind2scope' : {
         \ 'g' : 'enum',
         \ 'n' : 'namespace',
         \ 'c' : 'class',
         \ 's' : 'struct',
         \ 'u' : 'union'
     \ },
     \ 'scope2kind' : {
         \ 'enum'      : 'g',
         \ 'namespace' : 'n',
         \ 'class'     : 'c',
         \ 'struct'    : 's',
         \ 'union'     : 'u'
     \ }
     \ }



if executable('markdown2ctags')
    let g:tagbar_type_markdown = {
        \ 'ctagstype': 'markdown',
        \ 'ctagsbin' : 'markdown2ctags',
        \ 'ctagsargs' : '-f - --sort=yes',
        \ 'kinds' : [
            \ 's:sections',
            \ 'i:images'
        \ ],
        \ 'sro' : '|',
        \ 'kind2scope' : {
            \ 's' : 'section',
        \ },
        \ 'sort': 0,
    \ }
endif

if g:is_win 
    let s:vim_tags ='C:\Temp\vim\ctags\\'
else 
    let s:vim_tags = expand('~/tmp/vim/ctags')
endif

if !isdirectory(s:vim_tags)              " 检测 ~/.cache/tags 不存在就新建
    silent! call mkdir(s:vim_tags, 'p')
endif

let g:gutentags_cache_dir = s:vim_tags
let g:gutentags_ctags_tagfile = '.tags' " 所生成的数据文件的名称
set tags=./.tags;,.tags " 设置 tags：当前文件所在目录往上向根目录搜索直到碰到 .tags 文件 或者 Vim 当前目录包含 .tags 文件

" gutentags
let g:gutentags_project_root = ['pom.xml','.root', '.vc', '.svn', '.git', '.hg', '.project']

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = []
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']



let g:gutentags_modules = []            " 默认禁用自动生成
if executable('ctags')                 " 如果有 ctags 可执行就允许动态生成 ctags 文件
	let g:gutentags_modules += ['ctags']
endif
if executable('gtags') && executable('gtags-cscope') 
	let g:gutentags_modules += ['gtags_cscope']
endif
let g:gutentags_auto_add_gtags_cscope = 0 " 


set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class

"set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib "stuff to ignore when tab completing
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz    " MacOSX/Linux
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android

" Sort by file order
"let g:tagbar_sort = 0
nmap <F2> :TagbarToggle<CR>
