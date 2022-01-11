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
let g:peekaboo_window="call CreateCenteredFloatingWindow()"
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
call which_key#register('\', "g:which_key_map")
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
    \ 'name': '+show files in Directory',
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
    \ 'name': '+Go to...',
    \ 'd': {'name': '+Definition', 'd': 'here', 'h': 'left', 'j': 'below', 'k': 'above', 'l': 'right'},
    \ 'i': {'name': '+Implementation', 'i': 'here', 'h': 'left', 'j': 'below', 'k': 'above', 'l': 'right'},
    \ 'r': {'name': '+References', 'r': 'here', 'h': 'left', 'j': 'below', 'k': 'above', 'l': 'right'},
\ }

" Colorscheme
    set background=dark
    silent! colorscheme onedark
    set number
    if(has('nvim'))
        set scl=auto:9
    else
        set scl=auto
    endif
    set foldmethod=indent
    set foldlevelstart=99
    tabdo windo set foldtext=CustomFoldText()
    tabdo windo set fillchars=fold:\ 
    set laststatus=2
    set noshowmode
    highlight MatchParen       ctermbg=234 guibg=#1d2021 ctermfg=14  guifg=#91fff8 term=bold,underline cterm=bold,underline gui=bold,underline
    highlight Visual           ctermbg=219 guibg=#ffafff ctermfg=235 guifg=#282C34
    highlight CocHighlightText ctermbg=238 guibg=#444444
