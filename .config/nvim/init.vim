set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

let added_plugins = [
    \ ['neovim/nvim-lspconfig', {}],
    \ ['hrsh7th/cmp-nvim-lsp', {}],
    \ ['hrsh7th/cmp-buffer', {}],
    \ ['hrsh7th/cmp-path', {}],
    \ ['hrsh7th/cmp-cmdline', {}],
    \ ['hrsh7th/nvim-cmp', {}],
    \ ['j-hui/fidget.nvim', {}],
    \ ['nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}],
    \ ['nvim-treesitter/nvim-treesitter-context', {}],
    \ ['nvim-treesitter/nvim-treesitter-textobjects', {}],
    \ ['yogeshdhamija/chandrian-theme.nvim', {}],
\ ]

source ~/.vimrc

set termguicolors

set scl=auto:9
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

lua << EOF

---------------- Colorscheme ------------------------
local chandrian = require('chandrian');
chandrian.setup {}
chandrian.load()

---------------- LSP ------------------------
local servers = { 'tsserver', 'eslint', 'bashls', 'rust_analyzer' }

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'path', option = {trailing_slash = true} },
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  }, {
    { name = 'vsnip' },
  })
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities
  })
end

require"fidget".setup{}

---------------- Tree Sitter ------------------------
require'nvim-treesitter.configs'.setup {
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

EOF

function! QuickAction() abort
    lua vim.lsp.buf.code_action()
endfunction

function! RangeQuickAction() abort
    exe "norm \<Esc>"
    exe "norm :'\<,'\>lua vim.lsp.buf.range_code_action()\<CR>"
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
    lua vim.lsp.buf.formatting()
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
