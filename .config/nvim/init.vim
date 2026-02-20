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
let dependencies = [
    \ ['nvim-lua/plenary.nvim', {}],
\ ]
let file_browser = [
    \ ['stevearc/oil.nvim', {}],
\ ]
let treesitter = [
    \ ['nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}],
    \ ['nvim-treesitter/nvim-treesitter-context', {}],
    \ ['nvim-treesitter/nvim-treesitter-textobjects', {'branch':'main'}],
\ ]
let lsp = [
    \ ['williamboman/mason.nvim', {}],
    \ ['williamboman/mason-lspconfig.nvim', {}],
    \ ['neovim/nvim-lspconfig', {}],
    \ ['nvimtools/none-ls.nvim', {}],
    \ ['hrsh7th/nvim-cmp', {}],
    \ ['hrsh7th/cmp-nvim-lsp', {}],
    \ ['ncm2/float-preview.nvim', {}],
    \ ['MysticalDevil/inlay-hints.nvim', {}],
    \ ['j-hui/fidget.nvim', {}],
\ ]
let language = [
    \ ['mfussenegger/nvim-jdtls', {}],
\ ]
let interface_stuff = [
    \ ['nvim-lualine/lualine.nvim', {}],
    \ ['lukas-reineke/indent-blankline.nvim', {}],
    \ ['ellisonleao/gruvbox.nvim', {}],
    \ ['shaunsingh/nord.nvim', {}],
\ ]
let debugging = [
    \ ['mfussenegger/nvim-dap', {}],
    \ ['nvim-neotest/nvim-nio', {}],
    \ ['rcarriga/nvim-dap-ui', {}],
    \ ['jay-babu/mason-nvim-dap.nvim', {}],
    \ ['theHamsta/nvim-dap-virtual-text', {}],
    \ ['LiadOz/nvim-dap-repl-highlights', {}],
\ ]
let other_stuff = [
    \ ['gsuuon/model.nvim', {}],
    \ ['samjwill/nvim-unception', {}],
\ ]
let added_plugins = added_plugins + dependencies + file_browser + treesitter + lsp + language + interface_stuff + debugging + other_stuff

" ====================================== LOAD VIMRC ======================================
source ~/.vimrc

" ====================================== CHANGE SETTINGS ======================================
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.-1-

set termguicolors
set noshowmode

set scrollback=100000
let g:unception_open_buffer_in_new_tab=1

augroup FiletypeMchat
  autocmd!
  autocmd FileType mchat nnoremap <buffer> \m <cmd>Mchat<CR>
  autocmd FileType mchat inoremap <buffer> \m <cmd>Mchat<CR><cmd>stopinsert<CR>
augroup END

set background=dark
hi! link SignColumn Normal
hi! link TreesitterContext Normal

" ====================================== NEOVIM SPECIFICS ======================================
lua << EOF

---------------- File browser -----------------------
local oilstatus, oil = pcall(require, 'oil')
if (oilstatus) then
  oil.setup{
    watch_for_changes=true,
    view_options = {
      show_hidden = true,
    }
  }
end

---------------- Tree Sitter ------------------------
local status, ts = pcall(require, 'nvim-treesitter.configs')
local statuscontext, tscontext = pcall(require, 'treesitter-context')
local daprhstatus, daprh = pcall(require, 'nvim-dap-repl-highlights')
if (daprhstatus) then
  daprh.setup()
end
if (status) then
    ts.setup {
      ensure_installed = "all",
      ignore_install = {},
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
    tscontext.setup({
      mode='topline',
      multiwindow = true
    })
    vim.cmd("highlight TreesitterContextBottom gui=underline guisp=Grey")
end

---------------- LSP --------------------------------

local statuslspconfig, lspconfig = pcall(require, 'lspconfig')
local statuscmplsp, cmplsp = pcall(require, 'cmp_nvim_lsp')
local statusmasonl, masonl = pcall(require, 'mason-lspconfig')
local statusmason, mason = pcall(require, 'mason')
if(statuslspconfig and statuscmplsp and statusmasonl and statusmason) then
    local lspconfig_defaults = lspconfig.util.default_config
    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lspconfig_defaults.capabilities,
        cmplsp.default_capabilities()
    )

    mason.setup({})
    masonl.setup({
      ensure_installed = {},
      automatic_installation = true,
      handlers = {
        function(server_name) -- default for all servers, except for named ones
          lspconfig[server_name].setup({})
        end,
        jdtls = function() end -- don't use lspconfig for java, use nvim-jdtls (config in ~/.config/nvim/ftplugin/java.lua)
      },
    })
end


local statuscmp, cmp = pcall(require, 'cmp')
if(statuscmp) then
    cmp.setup({
      sources = {
        {name = 'nvim_lsp'},
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({}),
    })
end


local statusinlay,inlay = pcall(require, 'inlay-hints')
if(statusinlay) then
    inlay.setup({})
end
local statusfidget,fidget = pcall(require, 'fidget')
if(statusfidget) then
    fidget.setup({})
end


---------------- Debugger ---------------------------
local dapuistatus, dapui = pcall(require, 'dapui')
local dapstatus, dap = pcall(require, 'dap')
local masondapstatus, masondap = pcall(require, 'mason-nvim-dap')
local dapvtstatus, dapvt = pcall(require, 'nvim-dap-virtual-text')
if (dapuistatus and dapstatus and masondapstatus and dapvtstatus) then
  masondap.setup({
    ensure_installed = {},
    automatic_installation = true,
    handlers = {}
  })
  dapui.setup({
    mappings = {
      edit = "c",
      expand = { "zo", "zc" },
      open = "<CR>",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
  })
  dapvt.setup()
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end

  vim.fn.sign_define('DapBreakpoint', {text='⬤', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapBreakpointCondition', {text='¿', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapStopped', {text='➤', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapBreakpointRejected', {text='🚫', texthl='', linehl='', numhl=''})
  
  
  vim.cmd("au FileType dap-repl lua require('dap.ext.autocompl').attach()")

  ---------------------- Debugger Configurations -----------------------------------
	dap.configurations.java = {
		{
			type = 'java',
			request = 'attach',
			name = "Debug (Attach) - Remote",
			hostName = "127.0.0.1",
			port = 9998,
		},
	}
end

---------------- Other stuff ---------------------------
local statusline,line = pcall(require, 'lualine')
if(statusline) then
    line.setup({
      options = { theme = 'codedark' },
    })
end
local statusibl,ibl = pcall(require, 'ibl')
if(statusibl) then
  ibl.setup({
    indent = {
      char = '╎'
    }
  })
  vim.o.listchars = 'tab:| ,trail:•'
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

function! SwapWithNextParameter() abort
    exe "norm \<Plug>SwapWithNextParameter"
endfunction

function! SwapWithPreviousParameter() abort
    exe "norm \<Plug>SwapWithPreviousParameter"
endfunction

function! DirectoryBrowser() abort
  execute "normal! :Oil\<CR>"
endfunction

function! CloseWindowsWithFileType(filetype)
  " Get the current window number to return to it later.
  let l:current_win = winnr()

  " Loop through all windows.
  let l:win_count = winnr('$')
  for l:i in range(1, l:win_count)
    " Switch to window i
    exe l:i . 'wincmd w'

    " Check the filetype of the buffer in that window.
    if &filetype == a:filetype
      " Close the window if filetype matches.
      close
      " Adjust the window count since one window is closed.
      let l:win_count -= 1

      " Decrement 'i' since windows have shifted.
      let l:i -= 1
    endif
  endfor

  " Return to the original window
  exe l:current_win . 'wincmd w'
endfunction

function! InlineAssistThroughAiMagic() abort

  " If window of type mchat already exists, go there and paste contents (if called in visual mode)
  for winnr in range(1, winnr('$'))
    let bufnr = winbufnr(winnr)
    if getbufvar(bufnr, '&filetype') ==# 'mchat'
      let l:in_visual_mode = mode() ==# 'v' || mode() ==# "V"
      if l:in_visual_mode
        normal! y
      endif
      execute winnr . "wincmd w"
      normal Go
      stopinsert
      if l:in_visual_mode
        normal! p
      endif
      return
    endif
  endfor

  " If buffer of type mchat already exists, open it and paste contents (if called in visual mode)
  for l:buf in range(1, bufnr('$'))
    if bufexists(l:buf) && getbufvar(l:buf, '&filetype') ==# 'mchat'
      let l:in_visual_mode = mode() ==# 'v' || mode() ==# "V"
      if l:in_visual_mode
        normal! y
      endif
      vsplit
      execute 'buffer' l:buf
      normal Go
      stopinsert
      if l:in_visual_mode
        normal! p
      endif
      return
    endif
  endfor

  " Else, call :Mchat command (which also pastes contents if called in visual mode)
  execute "normal! :Mchat openai\<CR>"
  execute "normal! :set wrap\<CR>"
endfunction

function! ToggleBreakpoint() abort
  execute "normal! :DapToggleBreakpoint\<CR>"
endfunction
function! ToggleDebuggerUi() abort
  lua require('dapui').toggle()
endfunction
function! StartDebugger() abort
  execute "normal! :DapContinue\<CR>"
endfunction

call SourceFileIfExists(".vim/vimrc.local")
