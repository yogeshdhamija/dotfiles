set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua << EOF
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local servers = { 'tsserver' }

for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup({
    on_attach = on_attach
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
