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
set undodir=~/.vim/undodir
set nomodeline
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
set hidden
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
set updatetime=300
autocmd CursorHold * silent! call CocActionAsync('highlight')
let g:peekaboo_window="call CreateCenteredFloatingWindow()"

" Colorscheme
    set background=dark
    silent! colorscheme onedark
    set number
    set scl=yes
    set foldmethod=indent
    set foldlevelstart=99
    tabdo windo set foldtext=CustomFoldText()
    tabdo windo set fillchars=fold:\ 
    set laststatus=2
    highlight MatchParen term=bold,underline cterm=bold,underline ctermbg=234 ctermfg=14 gui=bold,underline guibg=#1d2021 guifg=#91fff8
