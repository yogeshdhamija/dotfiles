set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua << EOF
local servers = { 'tsserver', 'eslint' }

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
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
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

EOF

command! QUICKACTION lua vim.lsp.buf.code_action()
command! -range=% RANGEQUICKACTION lua vim.lsp.buf.range_code_action()
command! HOVER lua vim.lsp.buf.hover()
command! SIGNATUREHELP lua vim.lsp.buf.signature_help()
command! ERROR lua vim.diagnostic.open_float()
command! DEFINITION lua vim.lsp.buf.definition()
command! DECLARATION lua vim.lsp.buf.declaration()
command! REFERENCES lua vim.lsp.buf.references()
command! IMPLEMENTATIONS lua vim.lsp.buf.implementation()
command! CHANGESYMBOLNAME lua vim.lsp.buf.rename()
command! AUTOFORMAT lua vim.lsp.buf.formatting()
command! DISPLAYERRORS lua vim.diagnostic.setloclist()
