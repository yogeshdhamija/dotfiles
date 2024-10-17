set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" ====================================== LOAD FUNCTIONS ======================================
source ~/.config/vim/functions.vim

" ====================================== SET PLUGINS ======================================
if !exists("disabled_plugins")
    let disabled_plugins = []
endif
let disabled_plugins = disabled_plugins + ["justinmk/vim-dirvish"]
if !exists("added_plugins")
    let added_plugins = []
endif
let added_plugins = added_plugins + [
    \ ['nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}],
    \ ['nvim-treesitter/nvim-treesitter-context', {}],
    \ ['nvim-treesitter/nvim-treesitter-textobjects', {}],
    \ ['ncm2/float-preview.nvim', {}],
    \ ['stevearc/oil.nvim', {}],
    \ ['nvim-tree/nvim-web-devicons', {}],
\ ]

" ====================================== LOAD VIMRC ======================================
source ~/.vimrc

" ====================================== CHANGE SETTINGS ======================================
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.-1-

set termguicolors

" ====================================== NEOVIM SPECIFICS ======================================
lua << EOF

---------------- File browser -----------------------
local statusf, f = pcall(require, 'oil')
if(statusf) then
    f.setup({
        cleanup_delay_ms = false,
        view_options = {
            show_hidden = true
        },
    })
end

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

function! SwapWithNextParameter() abort
    exe "norm \<Plug>SwapWithNextParameter"
endfunction

function! SwapWithPreviousParameter() abort
    exe "norm \<Plug>SwapWithPreviousParameter"
endfunction

function! DirectoryBrowser() abort
    exe "norm \<CMD>Oil\<CR>"
endfunction

