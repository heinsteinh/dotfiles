
"https://github.com/4Bruno/LessonsLearned/blob/a9443b9a3613f8491d802a580d19e721e10c6ce1/vim/.vimrc
if g:is_win
    " 15.d Clang Complete -->
    let g:clang_library_path='C:\Program Files\LLVM\bin\libclang.dll'
    let g:clang_user_options = '-target=x86_64-w64-windows-gnu'
    let g:clang_complete_auto = 1

    if hostname() == "BHI4PCH7D3"
        let g:clang_library_path='C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\Llvm\x64\bin'
    else
        let g:clang_library_path='C:\Program Files\LLVM\bin\libclang.dll'
    endif
else

    " clang_complete configuration
    "let g:clang_library_path='/usr/lib/llvm-3.8/lib'
endif

" if has('win32') || g:shell ==# 'msys'
"     let s:libclang = GetPath($PROGRAMFILES, 'LLVM/lib/libclang.lib')
" elseif g:shell ==# 'cygwin'
"     let s:libclang = '/usr/lib/libclang.dll.a'
" else
"     let s:libclang = '/usr/lib/libclang.so'
" endif

" let g:clang_hl_errors=1
" let g:clang_periodic_quickfix=1
" let g:clang_snippets=1
" let g:clang_snippets_engine='ultisnips'
" let g:clang_trailing_placeholder=1
" let g:clang_close_preview=1
" let g:clang_complete_patterns=1
" let g:clang_complete_macros=1


" Disable function highlighting (affects both C and C++ files)
let g:cpp_function_highlight = 1
" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1
" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1
" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1


