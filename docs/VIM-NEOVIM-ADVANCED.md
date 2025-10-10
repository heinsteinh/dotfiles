# Advanced Vim and Neovim Mastery

Comprehensive guide for advanced file manipulation, editing techniques, and LSP workflows in Vim and Neovim. All examples work with your dotfiles configuration.

## Table of Contents

- [File Manipulation](#file-manipulation)
- [Advanced Editing Techniques](#advanced-editing-techniques)
- [Multi-File Operations](#multi-file-operations)
- [Code Refactoring](#code-refactoring)
- [LSP Deep Dive](#lsp-deep-dive)
- [Buffer Management](#buffer-management)
- [Window and Split Management](#window-and-split-management)
- [Project Navigation](#project-navigation)
- [Git Integration](#git-integration)
- [Macros and Automation](#macros-and-automation)
- [Session Management](#session-management)
- [Performance Optimization](#performance-optimization)

## File Manipulation

### Opening Files

#### Basic Opening

```vim
" Open file in current window
:e filename.cpp
:edit filename.cpp

" Open file in new split
:sp filename.cpp       " Horizontal split
:vsp filename.cpp      " Vertical split
:vs filename.cpp       " Short for vertical split

" Open file in new tab
:tabe filename.cpp
:tabnew filename.cpp

" Open file at specific line
:e +42 filename.cpp
:e filename.cpp +42
nvim filename.cpp +42   " From command line
```

#### Fuzzy Finding Files (Telescope/FZF)

```vim
" Neovim with Telescope:
<leader>f        " Find files in project
<leader>rg       " Live grep in files
<leader>b        " Find in open buffers
<leader>/        " Search in current buffer

" Vim with FZF:
<leader>f        " Find files
<leader>rg       " Ripgrep search
Ctrl+T           " FZF file finder
Ctrl+P           " Project files

" Filter results in Telescope/FZF:
" Start typing to filter
" Ctrl+J/K to navigate
" Enter to open
" Ctrl+X to open in split
" Ctrl+V to open in vsplit
" Ctrl+T to open in tab
```

#### Opening Files from Terminal

```bash
# Open multiple files
nvim file1.cpp file2.h file3.cpp

# Open in splits
nvim -o file1.cpp file2.cpp    # Horizontal splits
nvim -O file1.cpp file2.cpp    # Vertical splits

# Open in tabs
nvim -p file1.cpp file2.cpp file3.cpp

# Open at specific line
nvim +42 file.cpp
nvim file.cpp +/search_pattern

# Open with command
nvim -c "syntax on" -c "set number" file.cpp

# Open files from command output
fd -e cpp | fzf | xargs nvim
rg -l "TODO" | xargs nvim
```

### File Operations

#### Saving Files

```vim
" Save current file
:w
:write

" Save as new filename
:w newname.cpp
:saveas newname.cpp   " Save and switch to new file

" Save with sudo (if forgot to open with sudo)
:w !sudo tee %

" Save all open buffers
:wa
:wall

" Save and quit
:wq
:x                    " Only writes if changes made
ZZ                    " Normal mode equivalent
<leader>x             " Custom mapping

" Quit without saving
:q!
:qa!                  " Quit all windows
ZQ                    " Normal mode equivalent
```

#### File Information

```vim
" Show file info
:f
:file
Ctrl+G               " Show file name and position

" Show full path
:echo expand('%:p')

" Show file type
:set filetype?

" Show encoding
:set encoding?
:set fileencoding?

" Show file format
:set fileformat?     " unix, dos, mac

" File statistics
:!wc %               " Word count
:!stat %             " File stats
```

### Arglist Operations

```vim
" Add files to arglist
:args *.cpp
:args **/*.cpp       " Recursive
:args src/**/*.cpp include/**/*.h

" Show arglist
:args

" Navigate arglist
:next                " Next file
:previous            " Previous file
:first               " First file
:last                " Last file

" Execute command on all files in arglist
:argdo %s/old/new/ge | update
:argdo !clang-format -i %

" Example: Format all C++ files
:args src/**/*.cpp
:argdo !clang-format -i %
:argdo %s/\s\+$//e | update    " Remove trailing whitespace
```

## Advanced Editing Techniques

### Text Objects

#### Built-in Text Objects

```vim
" Word objects
iw       " Inner word
aw       " A word (includes surrounding whitespace)
iW       " Inner WORD (space-delimited)
aW       " A WORD

" Sentence and paragraph
is       " Inner sentence
as       " A sentence
ip       " Inner paragraph
ap       " A paragraph

" Quoted strings
i"       " Inner double quotes
a"       " A double quotes (includes quotes)
i'       " Inner single quotes
a'       " A single quotes
i`       " Inner backticks
a`       " A backticks

" Brackets and parentheses
i(       " Inner parentheses
a(       " A parentheses (includes parens)
i[       " Inner brackets
a[       " A brackets
i{       " Inner braces
a{       " A braces
i<       " Inner angle brackets
a<       " A angle brackets

" Tags (HTML/XML)
it       " Inner tag
at       " A tag

" Examples:
di"      " Delete inside double quotes
ci(      " Change inside parentheses
yi{      " Yank inside braces
va}      " Visual select around braces including braces
```

#### Custom Text Objects (with plugins)

```vim
" Argument objects (vim-argreplace or similar)
via      " Inner argument
vaa      " Around argument

" Example in function call:
" foo(arg1, arg2, arg3)
"        ^cursor here
" cia   -> changes arg1
" daa   -> deletes , arg2

" Indent objects (indent-textobject or similar)
vii      " Inner indentation level
vai      " Around indentation level
vaI      " Around indentation level + line above

" Comment objects
ic       " Inner comment
ac       " Around comment

" Function objects
if       " Inner function body
af       " Around function (includes signature)
```

### Surround Operations

With `vim-surround` or `nvim-surround` (installed in dotfiles):

```vim
" Add surroundings
ysiw"    " Surround word with double quotes
yss"     " Surround entire line
ysiw(    " Surround word with ( )
ysiw[    " Surround word with [ ]
ysiw{    " Surround word with { } with spaces
ysiw}    " Surround word with {} without spaces
ysiwt    " Surround with HTML tag (prompts for tag)

" Change surroundings
cs"'     " Change surrounding " to '
cs({     " Change surrounding ( ) to { }
cst"     " Change surrounding tag to "

" Delete surroundings
ds"      " Delete surrounding "
dst      " Delete surrounding tag
ds{      " Delete surrounding {}

" Visual mode surround
V        " Select lines
S"       " Surround selection with "

" Practical examples:
" "hello" -> cs"'  -> 'hello'
" 'hello' -> cs'<q> -> <q>hello</q>
" <q>hello</q> -> dst -> hello
" hello -> ysiw[ -> [ hello ]
" (arg1, arg2) -> cs)] -> [arg1, arg2]

" C++ specific:
" foo -> ysiw( -> foo()
" foo() -> ysiwastd::move<CR> -> std::move(foo())
```

### Visual Block Mode

```vim
" Enter visual block mode
Ctrl+V

" Visual block operations:
" 1. Select block with movement keys
" 2. Perform operation:

I        " Insert before block
A        " Append after block
c        " Change block
d        " Delete block
y        " Yank block
~        " Toggle case
u        " Lowercase
U        " Uppercase

" Practical examples:

" Add comment markers to multiple lines:
Ctrl+V           " Enter visual block
jjj              " Select 4 lines
I//              " Insert // before each line
Esc              " Apply

" Create aligned code:
Ctrl+V           " Visual block
Select column
c                " Change
Type new text
Esc              " Apply to all lines

" Increment numbers:
Ctrl+V           " Visual block
Select numbers
g Ctrl+A         " Increment each number sequentially

" Example - align equals signs:
" Before:
" int x = 5;
" int longer_name = 10;
" int y = 3;

" 1. Ctrl+V, select = column
" 2. :s/=/    =/    (add spaces before =)
```

### Multiple Cursors (Neovim)

```vim
" Using visual block mode as multiple cursors:
Ctrl+V           " Visual block
Select lines
I                " Insert mode for all lines
Type text
Esc              " Apply to all

" Using substitute with confirmation:
:%s/pattern/replacement/gc
" y - yes, n - no, a - all, q - quit, l - last

" Using macros (see Macros section):
qa               " Record macro to a
[operations]
q                " Stop recording
V                " Visual select lines
:normal @a       " Apply macro to all selected lines
```

### Code Folding

```vim
" Manual folding
zf               " Create fold (with motion)
zfap             " Fold around paragraph
zf}              " Fold to end of block
:5,10fold        " Fold lines 5-10

" Fold navigation
zo               " Open fold
zc               " Close fold
za               " Toggle fold
zR               " Open all folds
zM               " Close all folds
zr               " Open one more level
zm               " Close one more level
zj               " Move to next fold
zk               " Move to previous fold

" Fold by syntax (C++)
:set foldmethod=syntax
zfa}             " Fold C++ function body
zfaB             " Fold C++ block

" Fold by indent
:set foldmethod=indent
:set foldlevel=1

" View folds
:set foldcolumn=4    " Show fold column
```

## Multi-File Operations

### Search and Replace Across Files

#### Using arglist

```vim
" Method 1: Arglist
:args src/**/*.cpp
:argdo %s/old_name/new_name/ge | update

" Method 2: Bufdo (all open buffers)
:bufdo %s/old_name/new_name/ge | update

" Method 3: Quickfix list with cdo
:grep -r "old_name" src/
:cdo s/old_name/new_name/ge | update

" Method 4: Telescope (Neovim)
<leader>rg              " Search for old_name
Ctrl+Q                  " Send to quickfix
:cdo s/old_name/new_name/ge | update
```

#### Practical Multi-File Refactoring

```vim
" Rename class across project:
:args src/**/*.cpp include/**/*.h
:argdo %s/\<OldClassName\>/NewClassName/ge | update

" Update include guards:
:args include/**/*.h
:argdo %s/#ifndef \(.*\)/#ifndef MYPROJECT_\1/e | update

" Add namespace to functions:
:args src/**/*.cpp
:argdo %s/^\(void\s\+\w\+\)/namespace myns {\r\1/e | update

" Remove trailing whitespace from all files:
:args **/*.cpp **/*.h
:argdo %s/\s\+$//e | update
```

### Quickfix and Location Lists

```vim
" Open quickfix
:copen
:cw                  " Open if there are errors

" Navigate quickfix
:cn                  " Next error
:cp                  " Previous error
:cfirst              " First error
:clast               " Last error
:cc 3                " Jump to error 3

" Location list (window-specific quickfix)
:lopen
:ln
:lp
:lfirst
:llast

" Populate quickfix from grep:
:grep -r "pattern" src/
:copen

" Populate from make/compiler:
:make
:copen

" Execute command on quickfix:
:cdo s/old/new/g | update
:cfdo %s/old/new/g | update    " Once per file
```

### Working with Multiple Buffers

```vim
" List buffers
:ls
:buffers

" Switch buffers
:b 3                 " Buffer number 3
:b partial_name      " Tab-complete works
:bn                  " Next buffer
:bp                  " Previous buffer
:bf                  " First buffer
:bl                  " Last buffer
Ctrl+6               " Alternate buffer (last used)
Ctrl+H               " Previous buffer (custom mapping)
Ctrl+L               " Next buffer (custom mapping)

" Close buffers
:bd                  " Delete current buffer
:bd 3                " Delete buffer 3
:3bd                 " Delete buffer 3
:bd partial_name     " Delete by name
:bufdo bd            " Delete all buffers

" Buffer commands on multiple buffers
:bufdo e             " Reload all buffers
:bufdo %s/old/new/ge | update
```

## Code Refactoring

### LSP-Based Refactoring

```vim
" Rename symbol (all references)
<leader>rn           " LSP rename
" Prompts for new name, updates all files

" Code actions
<leader>ca           " Show available code actions
" Examples:
" - Add missing import
" - Generate constructor
" - Implement interface
" - Extract function
" - Inline variable

" Organize imports
<leader>ca           " Select "Organize imports"

" Quick fix
[d                   " Go to previous diagnostic
]d                   " Go to next diagnostic
<leader>ca           " Apply quick fix at cursor
```

### Manual Refactoring Patterns

#### Extract Function

```vim
" 1. Visual select code block
V
jjjj

" 2. Cut to register
d

" 3. Create function signature above
O
void extractedFunction() {
Esc

" 4. Paste code
p

" 5. Close function
}
Esc

" 6. Call function where code was
i
extractedFunction();
Esc
```

#### Rename Variable

```vim
" Method 1: LSP rename (best for functions/classes)
<leader>rn

" Method 2: Substitute in function
" Place cursor on variable
:g/^}/,/^{/s/\<oldName\>/newName/gc

" Method 3: Visual select function and substitute
V
Select function
:s/\<oldName\>/newName/g

" Method 4: Whole file
:%s/\<oldName\>/newName/gc
```

#### Extract Variable

```vim
" 1. Visual select expression
v
Select expression

" 2. Yank
y

" 3. Go to line above
O

" 4. Type variable declaration
auto variableName =
Ctrl+R "      " Paste yanked text
;
Esc

" 5. Replace original with variable name
/<Ctrl+R">   " Search for expression
cgn
variableName
Esc
```

## LSP Deep Dive

### Navigation

```vim
" Go to definition
gd                   " Go to definition
gD                   " Go to declaration
gi                   " Go to implementation
gr                   " Find references
gf                   " Go to file under cursor

" Back and forth
Ctrl+O               " Jump back
Ctrl+I               " Jump forward
Ctrl+T               " Jump back (tag stack)

" Symbol jumping
<leader>ls           " Document symbols (Telescope)
<leader>lw           " Workspace symbols (Telescope)

" Example workflow:
" 1. Find function call: /functionName
" 2. Go to definition: gd
" 3. Read implementation
" 4. Jump back: Ctrl+O
" 5. Find all usages: gr
```

### Hover and Documentation

```vim
" Hover documentation
K                    " Show hover info at cursor

" Signature help
<C-k>                " Show signature help (in insert mode)

" Example in C++:
" std::make_unique<MyClass>(arg1, arg2)
"                           ^cursor here
" Ctrl+K shows parameter info
```

### Diagnostics

```vim
" Navigate diagnostics
[d                   " Previous diagnostic
]d                   " Next diagnostic
<leader>e            " Show diagnostic float
<leader>q            " Show diagnostic list

" View all diagnostics
<leader>ld           " Document diagnostics (Telescope)
<leader>lD           " Workspace diagnostics (Telescope)

" Example C++ error workflow:
" 1. Build shows errors
" 2. Open file: nvim src/myfile.cpp
" 3. Navigate to first error: ]d
" 4. Read diagnostic: <leader>e
" 5. Apply fix: <leader>ca
" 6. Next error: ]d
```

### Code Actions

```vim
" Show code actions at cursor
<leader>ca

" Common code actions:
" - Add include
" - Generate missing member
" - Extract to function
" - Inline variable
" - Implement interface
" - Override method
" - Add parameter
" - Remove unused
" - Sort includes

" Example workflow:
" 1. See red squiggle under code
" 2. <leader>ca to see available actions
" 3. Select action with j/k
" 4. Press Enter to apply
```

### Formatting

```vim
" Format current buffer
<leader>cf           " Format with LSP

" Format selection
V
Select lines
<leader>cf

" Format on save (add to config):
" autocmd BufWritePre *.cpp,*.h lua vim.lsp.buf.format()

" Format with external tool:
:%!clang-format      " Format with clang-format
:'<,'>!clang-format  " Format selection
```

### Workspace Management

```vim
" Add workspace folder
:lua vim.lsp.buf.add_workspace_folder()

" Remove workspace folder
:lua vim.lsp.buf.remove_workspace_folder()

" List workspace folders
:lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))

" Useful for monorepos:
" cd ~/project
" nvim .
" :lua vim.lsp.buf.add_workspace_folder('/home/user/project/module1')
" :lua vim.lsp.buf.add_workspace_folder('/home/user/project/module2')
```

### LSP Troubleshooting

```vim
" Check LSP status
:LspInfo

" View LSP logs
:LspLog

" Restart LSP
:LspRestart

" Stop LSP
:LspStop

" Check LSP client
:lua print(vim.inspect(vim.lsp.get_active_clients()))

" Enable verbose logging (in init.lua):
" vim.lsp.set_log_level("debug")
```

## Buffer Management

### Buffer Lifecycle

```vim
" Create new buffer
:enew                " New empty buffer
:new                 " New buffer in split
:vnew                " New buffer in vertical split

" Hide buffer (keep in memory)
:hide                " Hide current buffer
:hide edit other.txt " Hide current, edit new

" Delete buffer
:bd                  " Delete current buffer (fails if unsaved)
:bd!                 " Force delete
:bw                  " Wipeout (completely remove)

" Delete multiple buffers
:bd 1 2 3           " Delete buffers 1, 2, 3
:%bd                " Delete all buffers
:%bd|e#|bd#         " Delete all except current
```

### Buffer Navigation Patterns

```vim
" Quick buffer switching
:b filename<Tab>     " Tab-complete buffer name
:b#                  " Alternate buffer
Ctrl+6               " Same as :b#
Ctrl+H               " Previous buffer (custom)
Ctrl+L               " Next buffer (custom)

" Buffer by number
:b1                  " Go to buffer 1
:b2                  " Go to buffer 2

" Telescope buffer picker (Neovim)
<leader>b            " Fuzzy find buffers
" Type to filter, Enter to open

" List and choose
:ls                  " List buffers
:b <number>          " Jump to buffer
```

### Buffer Organization

```vim
" Group related buffers
" Use buffer names as markers:
:file src_main       " Rename current buffer
:ls                  " Now shows as "src_main"

" Keep buffers organized:
" - Use :bd regularly for files you're done with
" - Use tabs for different contexts
" - Use arglist for batch operations
```

## Window and Split Management

### Creating Splits

```vim
" Horizontal split
:split               " Split with same file
:sp                  " Short form
:split filename      " Split with different file
Ctrl+W s             " Split current window

" Vertical split
:vsplit              " Vertical split with same file
:vs                  " Short form
:vsplit filename     " Vertical split with different file
Ctrl+W v             " Vertical split current window

" New empty splits
:new                 " New horizontal split
:vnew                " New vertical split

" Split with specific size
:10split             " 10 lines high
:vertical 50split    " 50 columns wide
```

### Navigating Splits

```vim
" Move between windows
Ctrl+W h             " Move to left window
Ctrl+W j             " Move to window below
Ctrl+W k             " Move to window above
Ctrl+W l             " Move to right window
Ctrl+W w             " Cycle through windows
Ctrl+W p             " Go to previous window

" Alternative (custom mappings in dotfiles)
Ctrl+H               " Move to left window
Ctrl+J               " Move to window below
Ctrl+K               " Move to window above
Ctrl+L               " Move to right window
```

### Resizing Splits

```vim
" Resize horizontally
Ctrl+W +             " Increase height
Ctrl+W -             " Decrease height
:resize +5           " Increase by 5 lines
:resize -5           " Decrease by 5 lines
:resize 20           " Set to 20 lines

" Resize vertically
Ctrl+W >             " Increase width
Ctrl+W <             " Decrease width
:vertical resize +10 " Increase by 10 columns
:vertical resize -10 " Decrease by 10 columns

" Equal sizes
Ctrl+W =             " Make all windows equal size

" Maximize
Ctrl+W _             " Maximize height
Ctrl+W |             " Maximize width
```

### Moving and Rearranging Splits

```vim
" Move window
Ctrl+W H             " Move window to far left
Ctrl+W J             " Move window to bottom
Ctrl+W K             " Move window to top
Ctrl+W L             " Move window to far right
Ctrl+W r             " Rotate windows
Ctrl+W x             " Exchange with next window
Ctrl+W T             " Move to new tab

" Example: Convert horizontal to vertical split
Ctrl+W K             " Make current window horizontal full width
" Then split vertically again
```

### Closing Splits

```vim
:q                   " Close current window
:only                " Close all windows except current
:close               " Close current window (like :q)
Ctrl+W q             " Close current window
Ctrl+W o             " Close all windows except current
:qa                  " Close all windows and quit
```

### Tab Management

```vim
" Create tabs
:tabnew              " New empty tab
:tabe filename       " Open file in new tab
:tab split           " Open current buffer in new tab

" Navigate tabs
gt                   " Next tab
gT                   " Previous tab
3gt                  " Go to tab 3
:tabn                " Next tab
:tabp                " Previous tab
:tabfirst            " First tab
:tablast             " Last tab

" Move tabs
:tabm 0              " Move to first position
:tabm                " Move to last position
:tabm +1             " Move one position right

" Close tabs
:tabc                " Close current tab
:tabo                " Close all other tabs
:qa                  " Close all tabs and quit

" List tabs
:tabs                " Show all tabs
```

### Practical Window Workflows

```vim
" Three-way diff
:e file1.cpp
:vs file2.cpp
:vs file3.cpp
:windo diffthis

" Header/source side-by-side
:e main.cpp
:vs main.h
" Navigate with Ctrl+W h/l

" Code + terminal
:e main.cpp
:split
:terminal
" Resize terminal: Ctrl+W + / Ctrl+W -

" Multi-file editing
:e file1.cpp
:vs file2.cpp
:split file3.cpp
" Layout:
" +---------+---------+
" | file3   | file2   |
" +---------+         |
" | file1   |         |
" +---------+---------+
```

## Project Navigation

### File Explorer

```vim
" Neovim Neo-tree (dotfiles configured)
<leader>n            " Toggle Neo-tree
<leader>nf           " Reveal current file in tree

" Neo-tree keybindings:
a                    " Add file/directory
d                    " Delete
r                    " Rename
c                    " Copy
x                    " Cut
p                    " Paste
R                    " Refresh
H                    " Toggle hidden files
/                    " Filter
?                    " Show help

" Vim NERDTree (dotfiles configured)
<leader>n            " Toggle NERDTree
<leader>nf           " Find current file in tree

" NERDTree keybindings:
m                    " Menu (add, delete, rename, etc.)
o                    " Open file
s                    " Open in vertical split
i                    " Open in horizontal split
t                    " Open in new tab
p                    " Go to parent
P                    " Go to root
K                    " Jump to first child
J                    " Jump to last child
C                    " Make node the root
u                    " Go up a directory
r                    " Refresh
I                    " Toggle hidden files
?                    " Help
```

### Telescope (Neovim)

```vim
" File pickers
<leader>f            " Find files
<leader>rg           " Live grep
<leader>b            " Buffers
<leader>/            " Search in current buffer

" LSP pickers
<leader>ls           " Document symbols
<leader>lw           " Workspace symbols
<leader>ld           " Document diagnostics
<leader>lD           " Workspace diagnostics

" Git pickers
<leader>gs           " Git status
<leader>gc           " Git commits
<leader>gb           " Git branches

" Other pickers
<leader>h            " Command history
<leader>m            " Marks
<leader>r            " Registers
<leader>t            " Tags

" Telescope keybindings (in picker):
Ctrl+J/K             " Next/previous result
Ctrl+Q               " Send to quickfix list
Ctrl+U               " Scroll preview up
Ctrl+D               " Scroll preview down
Tab                  " Toggle selection
```

### Jump List and Change List

```vim
" Jump list (between different files/locations)
Ctrl+O               " Jump to older position
Ctrl+I               " Jump to newer position
:jumps               " Show jump list

" Change list (within file)
g;                   " Jump to older change
g,                   " Jump to newer change
:changes             " Show change list

" Marks
ma                   " Set mark 'a' at cursor
'a                   " Jump to mark 'a'
`a                   " Jump to exact position of mark 'a'
:marks               " List all marks
'A                   " Jump to mark 'A' (global, across files)
```

### Tag Navigation

```vim
" Generate tags
" In terminal:
ctags -R .

" Tag commands
Ctrl+]               " Jump to tag under cursor
g Ctrl+]             " List multiple tag matches
:tag functionName    " Jump to tag
:ts                  " List tags
:tn                  " Next tag
:tp                  " Previous tag
Ctrl+T               " Jump back in tag stack
:tags                " Show tag stack

" Tag search
:tag /pattern        " Search tags by pattern
:tselect /pattern    " List matching tags
```

## Git Integration

### Vim-Fugitive

```vim
" Git status
:Git                 " Open git status
:G                   " Short form
<leader>gs           " Custom mapping

" In git status window:
s                    " Stage file
u                    " Unstage file
=                    " Toggle inline diff
dd                   " Diff file
cc                   " Commit
ca                   " Amend commit

" Git commands
:Git add %           " Stage current file
:Git add .           " Stage all
:Git commit          " Commit (opens commit message buffer)
:Git commit -m "msg" " Commit with message
:Git push            " Push
:Git pull            " Pull
:Git fetch           " Fetch
:Git log             " Log
:Git blame           " Blame current file

" Git diff
:Gdiff               " Diff current file
:Gdiffsplit          " Diff in split
:Gdiffsplit HEAD~1   " Diff with previous commit

" Conflict resolution
:Gdiff               " Opens 3-way diff
:diffget //2         " Get from left (target branch)
:diffget //3         " Get from right (merge branch)
]c                   " Jump to next conflict
[c                   " Jump to previous conflict
```

### Gitsigns (Neovim)

```vim
" Hunk navigation
]h                   " Next hunk
[h                   " Previous hunk

" Hunk operations
<leader>hs           " Stage hunk
<leader>hr           " Reset hunk
<leader>hu           " Undo stage hunk
<leader>hp           " Preview hunk
<leader>hb           " Blame line
<leader>hd           " Diff this file

" Text objects
ih                   " Inner hunk
ah                   " Around hunk

" Example: Stage current hunk
<leader>hs

" Example: Reset changes in visual selection
V
Select lines
<leader>hr
```

### Git Workflow in Vim/Neovim

```vim
" 1. Check status
<leader>gs

" 2. Stage files
" In git status window: s on each file
" Or: :Git add %

" 3. Review changes
" In git status window: = on each file

" 4. Commit
cc               " In git status window
" Or: :Git commit

" 5. Push
:Git push

" Complete workflow in one session:
:Git             " Check status
s                " Stage files
=                " Review changes
cc               " Commit
:Git push        " Push
```

## Macros and Automation

### Recording Macros

```vim
" Record macro
qa               " Start recording to register 'a'
[perform actions]
q                " Stop recording

" Play macro
@a               " Play macro from register 'a'
@@               " Repeat last played macro
10@a             " Play macro 10 times

" View macro contents
:reg a           " Show contents of register 'a'

" Edit macro
:let @a='<Ctrl+R>a'    " Put macro in command line
" Edit the text
" Press Enter
```

### Practical Macro Examples

#### Example 1: Format C++ Function Parameters

```vim
" Before:
void function(int a,int b,int c);

" Goal: Add spaces after commas
" After:
void function(int a, int b, int c);

" Macro:
qa               " Start recording
f,               " Find next comma
a                " Enter insert mode after comma
<Space>          " Add space
<Esc>            " Back to normal mode
q                " Stop recording

" Play: @@  (repeat for each comma)
```

#### Example 2: Convert to Vector Initialization

```vim
" Before:
item1
item2
item3

" Goal:
{"item1", "item2", "item3"}

" Macro:
qa               " Start recording
I"               " Insert " at beginning
<Esc>            " Normal mode
A",              " Append ", at end
<Esc>            " Normal mode
j                " Next line
q                " Stop recording

" Apply to all lines:
V                " Visual select all lines
:normal @a       " Apply macro to all
" Then manually add { and }
```

#### Example 3: Add Getter/Setter for Class Members

```vim
" Before:
int m_value;

" Goal:
int getValue() const { return m_value; }
void setValue(int value) { m_value = value; }

" Macro for getter:
qa                        " Start recording
yy                        " Yank line
p                         " Paste below
0w                        " Go to type
"tyw                      " Yank type to register t
^df_                      " Delete to underscore
i                         " Insert mode
get<Esc>                  " Add 'get'
~                         " Capitalize first letter
A() const { return m_<Esc> " Add return
p                         " Paste member name
A; }<Esc>                 " Close function
q                         " Stop recording
```

### Apply Macro to Multiple Lines

```vim
" Method 1: Visual selection
V                " Visual line select
jjj              " Select lines
:normal @a       " Apply macro 'a' to all lines

" Method 2: Range
:5,10normal @a   " Apply macro to lines 5-10

" Method 3: Pattern matching
:g/pattern/normal @a   " Apply macro to lines matching pattern

" Method 4: Repeat with count
10@a             " Play macro 10 times
```

### Recursive Macros

```vim
" Macro that calls itself
qa               " Start recording
[actions]
@a               " Call macro 'a' (itself)
q                " Stop recording

" Clear register first to avoid infinite loop:
:let @a=''

" Example: Process until end of file
qa               " Record
dd               " Delete line
@a               " Recursive call
q                " Stop

" Execute (will run until end of file):
@a
" (Will show error at end, but that's okay)
```

### Save and Load Macros

```vim
" Save macro to file
:redir >> ~/macros.txt
:reg a
:redir END

" Load macro from file
:let @a='<paste macro text here>'

" Or put in vimrc:
let @a='0f,a <Esc>j'

" Share macros between sessions in dotfiles:
" Add to ~/.config/nvim/init.lua or ~/.vimrc:
" vim.cmd([[let @a='0f,a <Esc>j']])
```

## Session Management

### Manual Session Management

```vim
" Save session
:mksession ~/session.vim
:mks ~/session.vim              " Short form

" Save session (overwrite)
:mksession! ~/session.vim

" Load session
:source ~/session.vim
nvim -S ~/session.vim           " From command line

" Session options (what to save)
:set sessionoptions?
" Set in config:
set sessionoptions=buffers,curdir,folds,help,tabpages,winsize,winpos,terminal
```

### Project-Specific Sessions

```bash
# Create session per project
cd ~/project1
nvim
# Do work
:mksession! .session.vim
:qa

# Restore later
cd ~/project1
nvim -S .session.vim

# Or auto-restore
nvim
:source .session.vim
```

### Auto-Save Session

```vim
" Add to config (~/.config/nvim/init.lua or ~/.vimrc):

" Vim:
autocmd VimLeave * mksession! ~/.vim/session.vim

" Neovim (Lua):
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  command = "mksession! ~/.config/nvim/session.vim"
})

" Auto-load session on start:
autocmd VimEnter * if filereadable('Session.vim') | source Session.vim | endif
```

### Session Management Plugin

The dotfiles can be enhanced with session managers:

```vim
" Add to Lazy.nvim config:
{
  'rmagatti/auto-session',
  config = function()
    require('auto-session').setup {
      log_level = 'info',
      auto_session_enable_last_session = true,
      auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
    }
  end
}
```

## Performance Optimization

### Startup Time Profiling

```bash
# Profile startup
nvim --startuptime startup.log
less startup.log

# Sort by time
nvim --startuptime startup.log +q
sort -k2 -nr startup.log | head -20

# Compare with minimal config
nvim --noplugin --startuptime minimal.log
diff startup.log minimal.log
```

### Disable Features Temporarily

```vim
" Disable syntax highlighting for large files
:syntax off

" Disable LSP for current buffer
:LspStop

" Disable plugins
nvim --noplugin

" Minimal config
nvim -u NONE
```

### Optimize for Large Files

```vim
" Add to config for files > 1MB:
autocmd BufReadPre * if getfsize(expand("%")) > 1000000 | syntax off | endif

" Disable features for large files:
let g:large_file = 1000000 " 1MB
autocmd BufReadPre * if getfsize(expand("%")) > g:large_file |
  \ setlocal eventignore+=FileType |
  \ setlocal noswapfile |
  \ setlocal bufhidden=unload |
  \ setlocal undolevels=-1
\ | endif
```

### Performance Tips

```vim
" Use lazy loading for plugins (already configured in dotfiles)
" Disable unused plugins
" Use treesitter for syntax highlighting (faster than regex)
" Limit LSP workspace folders
" Reduce updatetime for better responsiveness
set updatetime=250

" Use swap files on SSD or ramdisk
set directory=/tmp//

" Limit undo levels for massive files
set undolevels=100    " Default is 1000
```

## Quick Reference Card

### Essential Mappings (Dotfiles Configured)

```
Leader key: <Space>

Files & Navigation:
<leader>f         Find files
<leader>rg        Live grep
<leader>b         Buffers
<leader>n         Toggle file tree
Ctrl+O/I          Jump back/forward

LSP:
gd                Go to definition
gr                Find references
K                 Hover documentation
<leader>rn        Rename symbol
<leader>ca        Code actions
[d / ]d           Previous/next diagnostic

Git:
<leader>gs        Git status
<leader>gc        Git commit
<leader>gd        Git diff
[h / ]h           Previous/next hunk

Windows:
Ctrl+H/J/K/L      Navigate windows
<leader>|         Vertical split
<leader>-         Horizontal split

Editing:
ci"               Change inside quotes
da(               Delete around parens
ysiw"             Surround word with "
gcc               Comment line
gc                Comment selection
```

## Additional Resources

- [Vim Documentation](https://vimhelp.org/)
- [Neovim Documentation](https://neovim.io/doc/)
- [Practical Vim](https://pragprog.com/titles/dnvim2/practical-vim-second-edition/)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [LSP Configuration](https://github.com/neovim/nvim-lspconfig)

## Next Steps

- Practice one technique daily until it becomes muscle memory
- Create personal cheat sheet of most-used commands
- Customize keybindings in `~/.config/nvim/init.lua`
- Review [CPP-DEVELOPMENT.md](CPP-DEVELOPMENT.md) for C++ specific workflows
- Check [DEVELOPER-WORKFLOWS.md](DEVELOPER-WORKFLOWS.md) for integrated workflows
