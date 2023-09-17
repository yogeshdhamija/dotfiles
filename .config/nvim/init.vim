set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" ====================================== LOAD FUNCTIONS ======================================
source ~/.config/vim/functions.vim

" ====================================== SET PLUGINS ======================================
if !exists("added_plugins")
    let added_plugins = []
endif
let added_plugins = added_plugins + [
    \ ['VonHeikemen/lsp-zero.nvim', {}],
    \ ['neovim/nvim-lspconfig', {}],
    \ ['williamboman/mason.nvim', {}],
    \ ['williamboman/mason-lspconfig.nvim', {}],
    \ ['hrsh7th/cmp-nvim-lsp', {}],
    \ ['hrsh7th/cmp-buffer', {}],
    \ ['hrsh7th/cmp-path', {}],
    \ ['hrsh7th/cmp-cmdline', {}],
    \ ['hrsh7th/nvim-cmp', {}],
    \ ['saadparwaiz1/cmp_luasnip', {}],
    \ ['hrsh7th/cmp-nvim-lua', {}],
    \ ['L3MON4D3/LuaSnip', {}],
    \ ['j-hui/fidget.nvim', {}],
    \ ['nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}],
    \ ['nvim-treesitter/nvim-treesitter-context', {}],
    \ ['nvim-treesitter/nvim-treesitter-textobjects', {}],
\ ]

" ====================================== LOAD VIMRC ======================================
source ~/.vimrc

" ====================================== CHANGE SETTINGS ======================================
set scl=auto:9
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" ====================================== NEOVIM SPECIFICS ======================================
lua << EOF

---------------- LSP ------------------------
local lspstatus, lsp = pcall(require, 'lsp-zero')
local cmpstatus, cmp = pcall(require, 'cmp')
if(cmpstatus and lspstatus) then

    lsp.preset('recommended')

    lsp.set_preferences({
      set_lsp_keymaps = false,
      configure_diagnostics = false
    })

    lsp.setup_nvim_cmp({
        completion = {
            completeopt = 'menu,menuone,noinsert,noselect',
        },
        mapping = {
            ['<C-n>'] = function() cmp.select_next_item() end,
            ['<C-p>'] = function() cmp.select_prev_item() end,
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }
    })

    lsp.setup()

    local status, fidget = pcall(require,"fidget")
    if (status) then
        fidget.setup{}
    end
    local status, lines = pcall(require,"lsp_lines")
    if(status) then
        lines.setup()
    end
end

---------------- Tree Sitter ------------------------
local status, ts = pcall(require, 'nvim-treesitter.configs')
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
end

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
