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
if(has('nvim'))
    let g:peekaboo_window="call NvimOnlyCreateCenteredFloatingWindow()"
endif
let g:terminal_command_motion_prompt_matcher = '^.*\n❯\s*'
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

nnoremap <silent> \ :<c-u>WhichKey '\'<CR>

" Colors
    silent! colorscheme structured-colors
    set number
    set scl=auto
    set foldlevelstart=99
    set foldmethod=indent
    tabdo windo set foldtext=CustomFoldText()
    tabdo windo set fillchars=fold:\ 
    set laststatus=2
    set list lcs=tab:\|\ ,trail:•
    set noshowmode
    set cmdheight=0
    set statusline=\|%{mode(1)}\|\ %f\ %h%w%m%r%=%-14.(%l,%c%V%)\ %P
