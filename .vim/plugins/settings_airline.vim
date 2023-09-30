"https://github.com/jabrouwer82/configurations/blob/ab816a9b08b394b7cd114a912d4e04c926b46345/.vimrc
" After 300 millis of no edits, a swap file will be written.
" After 300 millis, the CursorHold event fires.
set updatetime=300

" Airline:
" Use my custom airline theme.
"let g:airline_theme = 'tomorrow'
"let g:airline_theme = 'luna'
"let g:airline_theme = 'gruvbox'
let g:airline_theme = 'dark'
"let g:airline_theme = 'light'
"let g:airline_theme = 'powerlineish'
"let g:airline_theme = 'papercolor'
" Use powerline symbols.

let g:airline_powerline_fonts = 0
" Create the symbols dict.
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" Use a better symbol for dirty branches.
let g:airline_symbols.dirty = '  '
" Don't show the 'spell' section in the status bar.
let g:airline_detect_spell=0
" Override some mode display values.
if !exists('g:airline_mode_map')
    let g:airline_mode_map = {}
endif

if g:unicode
    let g:airline_powerline_fonts = 1
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.spell = '₷'
    let g:airline_symbols.paste = 'Þ'
    let g:airline_symbols.readonly = '⊘'
    let g:airline_symbols.whitespace = '✹'
    let g:airline_symbols.notexists = ' Ɇ'
    let g:airline_symbols.dirty = ' ×'
else
    let g:airline_symbols_ascii = 1
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = 'λ'
    let g:airline_symbols.spell = 'ς'
    let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.readonly = 'ο'
    let g:airline_symbols.whitespace = '!'
    let g:airline_symbols.notexists = ' ε'
    let g:airline_symbols.dirty = ' ~'
endif

if hostname() == "BHI4PCH7D3"
else
    " This chunk puts a clock and battery meter in the top right of the airline tabline.
    " Normal
    let g:airline_mode_map['n'] = 'N '
    " Insert
    let g:airline_mode_map['i'] = 'I '
    " Visual
    let g:airline_mode_map['v'] = 'V'
    " Visual Line
    let g:airline_mode_map['V'] = 'VL'
    " Visual Block
    let g:airline_mode_map[''] = 'VB'
endif

" Enables detection of whitespace errors.
let g:airline#extensions#whitespace#enabled = 0
" Show the keymap in use (I'm pretty sure I'm not using keymaps, I'm not sure why I have this enabled)
let g:airline#extensions#keymap#enabled = 1
" Don't show the encoding if it's what it should be.
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
" Enable coc in statusline.
let g:airline#extensions#coc#enabled = 1

" Enable the tabline.
let g:airline#extensions#tabline#enabled = 1
" Show visible buffers of current tab in tabline.
let g:airline#extensions#tabline#show_splits = 1
" Truncate buffer names in the tabline to just the filename without extension.
let g:airline#extensions#tabline#fnamemod = ':t:r'
" Number tabs by tab number (splits is the default?)
let g:airline#extensions#tabline#tab_nr_type = 1
" Always show tabs in tabline (doesn't work, but I would prefer it)
let g:airline#extensions#tabline#show_tabs = 1
" Don't show the tab count.
let g:airline#extensions#tabline#show_tab_count = 0
" Don't show close button for tabs.
let g:airline#extensions#tabline#show_close_button = 1
" Switch buffers and tabs in the tabline, only works for ctrlspace, but hopefully that changes.
let g:airline#extensions#tabline#switch_buffers_and_tabs = 0



" Replaces the "tabs" label in the tabline with the abbreviated pwd.
augroup TablineCwd
    au!
    au DirChanged,VimEnter * let g:airline#extensions#tabline#tabs_label = pathshorten(fnamemodify(getcwd(), ":~"))
augroup end


function! CheckBatteryPercent()
    if g:is_win
        let g:battery_percent = "??"
    elseif g:is_mac
        let g:battery_percent = trim(system('sh -c ''pmset -g batt | grep -Eo "\d+%" | cut -d% -f1'' '))
    elseif g:is_linux
        let g:battery_percent = system('sh -c ''if [[ -f /sys/class/power_supply/BAT0/capacity ]]; then cat /sys/class/power_supply/BAT0/capacity; else echo "∞"; fi'' ')[:-2]
    endif
endfunction

"{{{ Simple Branch Template Example
if g:is_win
elseif g:is_mac
elseif g:is_linux


    if hostname() == "BHI4PCH7D3"
    else
        " This chunk puts a clock and battery meter in the top right of the airline tabline.
        let g:battery_percent = "--"
        call CheckBatteryPercent()


        if exists('g:tabline_timer')
            call timer_stop(g:tabline_timer)
        endif
        let g:tabline_timer = timer_start(&updatetime, 'TablineUpdate', { 'repeat': -1 })

        if exists('g:battery_timer')
            call timer_stop(g:battery_timer)
        endif
        let g:battery_timer = timer_start(&updatetime, 'UpdateBattery')
    endif
endif




function! UpdateBattery(timer)

    call CheckBatteryPercent()

    let l:show_alert = 0
    if g:battery_percent < 0
        " This handles when the battery function didn't work correctly.
        let g:battery_timer = timer_start(5*1000, 'UpdateBattery')
    elseif g:battery_percent < 2
        let l:show_alert = 1
        let g:battery_timer = timer_start(10*1000, 'UpdateBattery')
    elseif g:battery_percent < 10
        let g:battery_timer = timer_start(60*1000, 'UpdateBattery')
    elseif g:battery_percent < 33
        let g:battery_timer = timer_start(5*60*1000, 'UpdateBattery')
    elseif g:battery_percent < 66
        let g:battery_timer = timer_start(10*60*1000, 'UpdateBattery')
    elseif g:battery_percent < 100
        let g:battery_timer = timer_start(20*60*1000, 'UpdateBattery')
    elseif g:battery_percent == 100
        let g:battery_timer = timer_start(30*60*1000, 'UpdateBattery')
    endif

    if exists('g:battery_alert')
        call popup_close(g:battery_alert)
        unlet g:battery_alert
    endif

    if l:show_alert
        let g:battery_alert = popup_create('BATTERY VERY LOW', {
                    \   'highlight': 'ErrorMsg',
                    \   'border': [],
                    \   'padding': [0,1,0,1],
                    \   'close': 'click',
                    \   'borderchars': ['━', '┃', '━', '┃', '┏', '┓', '┛', '┗']
                    \ })
    endif
endfunction

function! TablineUpdate(timer)
    let g:airline#extensions#tabline#buffers_label = strftime('%m/%d %T') . ' |' . g:battery_percent . '%%|'
    call airline#util#doautocmd('BufMRUChange')
    call airline#extensions#tabline#redraw()
endfunction

