set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" ====================================== LOAD FUNCTIONS ======================================
source ~/.config/vim/functions.vim

" ====================================== SET PLUGINS ======================================
if !exists("added_plugins")
    let added_plugins = []
endif
let added_plugins = added_plugins + [
    \ ['nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}],
    \ ['nvim-treesitter/nvim-treesitter-context', {}],
    \ ['nvim-treesitter/nvim-treesitter-textobjects', {}],
    \ ['ncm2/float-preview.nvim', {}],
\ ]

" ====================================== LOAD VIMRC ======================================
source ~/.vimrc

" ====================================== CHANGE SETTINGS ======================================
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

inoremap a a<C-X><C-O>
inoremap b b<C-X><C-O>
inoremap c c<C-X><C-O>
inoremap d d<C-X><C-O>
inoremap e e<C-X><C-O>
inoremap f f<C-X><C-O>
inoremap g g<C-X><C-O>
inoremap h h<C-X><C-O>
inoremap i i<C-X><C-O>
inoremap j j<C-X><C-O>
inoremap k k<C-X><C-O>
inoremap l l<C-X><C-O>
inoremap m m<C-X><C-O>
inoremap n n<C-X><C-O>
inoremap o o<C-X><C-O>
inoremap p p<C-X><C-O>
inoremap q q<C-X><C-O>
inoremap r r<C-X><C-O>
inoremap s s<C-X><C-O>
inoremap t t<C-X><C-O>
inoremap u u<C-X><C-O>
inoremap v v<C-X><C-O>
inoremap w w<C-X><C-O>
inoremap x x<C-X><C-O>
inoremap y y<C-X><C-O>
inoremap z z<C-X><C-O>
inoremap . .<C-X><C-O>

" ====================================== NEOVIM SPECIFICS ======================================
lua << EOF

---------------- Tree Sitter ------------------------
local status, ts = pcall(require, 'nvim-treesitter.configs')
local statuscontext, tscontext = pcall(require, 'treesitter-context')
if (status) then
    ts.setup {
      ensure_installed = "all",
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "<Plug>ExpandSelection",
          node_decremental = "<Plug>ShrinkSelection",
        },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["<Plug>MoveDown"] = "@block.outer",
          },
          goto_next_end = {
          },
          goto_previous_start = {
            ["<Plug>MoveUp"] = "@block.outer",
          },
          goto_previous_end = {
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<Plug>SwapWithNextParameter"] = "@parameter.inner",
          },
          swap_previous = {
            ["<Plug>SwapWithPreviousParameter"] = "@parameter.inner",
          },
        },
      },
    }
    tscontext.setup { mode='topline' }
end

---------------- LSP --------------------------------

vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"rust"},
    callback = function(event)
      vim.lsp.start({
        name = 'rust-analyzer',
        cmd = {'rust-analyzer'},
        root_dir = vim.fs.dirname(vim.fs.find({'Cargo.lock', 'Cargo.toml'}, { upward = true })[1]),
      })
    end
})

EOF

" ==================================== ADD FUNCTIONALITY ====================================
function! QuickAction() abort
    lua vim.lsp.buf.code_action({range})
endfunction

function! Hover() abort
    lua vim.lsp.buf.hover()
endfunction

function! SignatureHelp() abort
    lua vim.lsp.buf.signature_help()
endfunction

function! Error() abort
    lua vim.diagnostic.open_float()
endfunction

function! Definition() abort
    lua vim.lsp.buf.definition()
endfunction

function! Declaration() abort
    lua vim.lsp.buf.declaration()
endfunction

function! References() abort
    lua vim.lsp.buf.references()
endfunction

function! Implementations() abort
    lua vim.lsp.buf.implementation()
endfunction

function! ChangeSymbolName() abort
    lua vim.lsp.buf.rename()
endfunction

function! AutoFormat() abort
    lua vim.lsp.buf.format({range})
endfunction

function! DisplayErrors() abort
    lua vim.diagnostic.setloclist()
endfunction

function! StartTerminal() abort
    exe "norm :terminal\<CR>:startinsert\<CR>"
endfunction

function! ExpandSelection() abort
    exe "norm \<Plug>ExpandSelection"
endfunction

function! ShrinkSelection() abort
    exe "norm \<Plug>ShrinkSelection"
endfunction

function! MoveUp() abort
    let l:oldPosition = getcurpos()
    exe "norm \<Plug>MoveUp"
    if(getcurpos() == l:oldPosition)
        normal 10k
    endif
endfunction

function! MoveDown() abort
    let l:oldPosition = getcurpos()
    exe "norm \<Plug>MoveDown"
    if(getcurpos() == l:oldPosition)
        normal 10j
    endif
endfunction

function! SwapWithNextParameter() abort
    exe "norm \<Plug>SwapWithNextParameter"
endfunction

function! SwapWithPreviousParameter() abort
    exe "norm \<Plug>SwapWithPreviousParameter"
endfunction
