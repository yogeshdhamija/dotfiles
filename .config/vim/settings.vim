source ~/.config/vim/functions.vim

set mouse=a
set ignorecase
set linebreak
set hlsearch
set autoread
set splitbelow
set splitright
let g:easy_align_ignore_groups=[]
set tabstop=4
set shiftwidth=4
set expandtab
set undofile
set nomodeline
set hidden
set updatetime=300
if(!has('nvim'))
    set re=0
endif
if(has('nvim'))
    set undodir=~/.nvim/undodir
else
    set undodir=~/.vim/undodir
endif
if executable('rg')
    set grepprg=rg\ --follow\ --vimgrep\ --no-heading
elseif executable('ag')
    set grepprg=ag\ --follow\ --vimgrep\ --noheading
else
    set grepprg=grep\ -nR
endif
augroup jump_to_last_position_on_open
    autocmd!
    au BufReadPost * 
        \ if line("'\"") > 1 && line("'\"") <= line("$")
            \ | exe "normal! g`\"" 
        \ | endif
augroup END
let g:dirvish_mode = 2
let g:dirvish_relative_paths = 1
if DetectWsl()
    call SetClipboardForWslTerminal()
endif
if !has('nvim')
    if exists('+termwinkey')
        set termwinkey=<C-\-n>
    else
        set termkey=<C-\-n>
    endif
endif
autocmd CursorHold * silent! call CocActionAsync('highlight')
if(has('nvim'))
    let g:peekaboo_window="call NvimOnlyCreateCenteredFloatingWindow()"
endif
let g:terminal_command_motion_prompt_matcher = '^'.$USER.' in .* %\s*'
let g:indentLine_setColors = 0
let g:fzf_preview_window = ['up:50%', 'ctrl-/']

let g:SignatureMap = {
    \ 'Leader'             :  "m",
    \ 'PlaceNextMark'      :  "m,",
    \ 'ToggleMarkAtLine'   :  "m.",
    \ 'PurgeMarksAtLine'   :  "m-",
    \ 'DeleteMark'         :  "dm",
    \ 'PurgeMarks'         :  "m<Space>",
    \ 'PurgeMarkers'       :  "m<BS>",
    \ 'GotoNextLineAlpha'  :  "']",
    \ 'GotoPrevLineAlpha'  :  "'[",
    \ 'GotoNextSpotAlpha'  :  "",
    \ 'GotoPrevSpotAlpha'  :  "",
    \ 'GotoNextLineByPos'  :  "]'",
    \ 'GotoPrevLineByPos'  :  "['",
    \ 'GotoNextSpotByPos'  :  "]`",
    \ 'GotoPrevSpotByPos'  :  "[`",
    \ 'GotoNextMarker'     :  "]-",
    \ 'GotoPrevMarker'     :  "[-",
    \ 'GotoNextMarkerAny'  :  "]=",
    \ 'GotoPrevMarkerAny'  :  "[=",
    \ 'ListBufferMarks'    :  "m/",
    \ 'ListBufferMarkers'  :  "m?"
\ }

let g:which_key_flatten = 0
let g:which_key_map = {}
silent! call which_key#register('\', "g:which_key_map")
let g:which_key_map.q = 'Quick action'
let g:which_key_map.c = 'Clear screen'
let g:which_key_map.o = 'Open file'
let g:which_key_map.b = 'switch Buffer'
let g:which_key_map.w = 'switch Window'
let g:which_key_map.a = 'show Actions'
let g:which_key_map.h = 'show Help in hover'
let g:which_key_map.e = 'show Error'
let g:which_key_map.f = 'Find in directory'
let g:which_key_map.d = {
    \ 'name': '+show_files_in_Directory',
    \ 'd': 'here',
    \ 'h': 'left',
    \ 'j': 'below',
    \ 'k': 'above',
    \ 'l': 'right',
\ }
let g:which_key_map.t = {
    \ 'name': '+Terminal',
    \ 't': 'here',
    \ 'h': 'left',
    \ 'j': 'below',
    \ 'k': 'above',
    \ 'l': 'right',
\ }
let g:which_key_map.g = {
    \ 'name': '+Go_to...',
    \ 'd': {'name': '+Definition', 'd': 'here', 'h': 'left', 'j': 'below', 'k': 'above', 'l': 'right'},
    \ 'i': {'name': '+Implementation', 'i': 'here', 'h': 'left', 'j': 'below', 'k': 'above', 'l': 'right'},
    \ 'r': {'name': '+References', 'r': 'here', 'h': 'left', 'j': 'below', 'k': 'above', 'l': 'right'},
\ }

call SetColors()
