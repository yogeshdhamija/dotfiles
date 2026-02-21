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
    \ ['refractalize/oil-git-status.nvim', {}],
    \ ['nvim-mini/mini.nvim', {}],
\ ]
let treesitter = [
    \ ['nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}],
    \ ['MeanderingProgrammer/treesitter-modules.nvim', {}],
    \ ['nvim-treesitter/nvim-treesitter-context', {}],
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
    \ ['MagicDuck/grug-far.nvim', {}],
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

nnoremap \f <cmd>GrugFar<CR>
vnoremap \f <Esc><cmd>'<,'>GrugFar<CR>

set clipboard+=unnamedplus

" ====================================== NEOVIM SPECIFICS ======================================
lua << EOF



local farstatus, far = pcall(require, 'grug-far')
if (farstatus) then
 far.setup{
    windowCreationCommand = '',
    openTargetWindow = {
      preferredLocation = 'right'
    },
    keymaps = {
      replace = { n = '<localleader>r' },
      qflist = { n = '' },
      syncLocations = { n = '' },
      syncLine = { n = '' },
      close = { n = '' },
      historyOpen = { n = '' },
      historyAdd = { n = '' },
      refresh = { n = '' },
      openLocation = { n = '' },
      openNextLocation = { n = '<down>' },
      openPrevLocation = { n = '<up>' },
      gotoLocation = { n = '<enter>' },
      pickHistoryEntry = { n = '<enter>' },
      abort = { n = '<localleader>c' },
      help = { n = 'g?' },
      toggleShowCommand = { n = '' },
      swapEngine = { n = '' },
      previewLocation = { n = '' },
      swapReplacementInterpreter = { n = '' },
      applyNext = { n = '<localleader>n' },
      applyPrev = { n = '<localleader>p' },
      syncNext = { n = '' },
      syncPrev = { n = '' },
      syncFile = { n = '' },
      nextInput = { n = '<tab>' },
      prevInput = { n = '<s-tab>' },
    },
 }
end



---------------- File browser -----------------------
pcall(function() require('mini.icons').setup() end)
local oilstatus, oil = pcall(require, 'oil')
if (oilstatus) then
  local detail = true
  oil.setup{
    watch_for_changes=true,
    columns = {"permissions", "size", "mtime", "icon" },
    view_options = {
      show_hidden = true,
    },
    win_options = {
      signcolumn = "auto:2"
    },
    keymaps = {
      [ "zc"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({"permissions", "size", "mtime", "icon" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
    },
  }
end
local oilgitstatus, oilgit = pcall(require, 'oil-git-status')
if (oilgitstatus) then
  oilgit.setup()
end

---------------- Tree Sitter ------------------------
local tsstatus, ts = pcall(require, 'nvim-treesitter')
if (tsstatus) then
end
local tsmstatus, tsm = pcall(require, 'treesitter-modules')
if (tsmstatus) then
    tsm.setup {
      ensure_installed = {},
      ignore_install = {},
      sync_install = true,
      auto_install = true,
      highlight = { enable = true, },
      fold = { enable = true, },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "<Plug>ExpandSelection",
          node_decremental = "<Plug>ShrinkSelection",
        },
      },
    }
end
local statuscontext, tscontext = pcall(require, 'treesitter-context')
if (statuscontext) then
    tscontext.setup{
      mode='topline',
      multiwindow = true
    }
    vim.cmd("highlight TreesitterContextBottom gui=underline guisp=Grey")
end
local daprhstatus, daprh = pcall(require, 'nvim-dap-repl-highlights')
if (daprhstatus) then
  daprh.setup()
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
  lua << EOF
    local node = vim.treesitter.get_node()
    -- Look for common container node names across different languages
    local patterns = { "list", "arguments", "parameters", "dictionary", "array", "table", "tuple", "class_body", "constructor" }
    local target = nil
    
    -- Traverse up until we find a node whose parent is a container
    while node do
      local parent = node:parent()
      if not parent then break end
      
      local p_type = parent:type()
      for _, pattern in ipairs(patterns) do
        if p_type:find(pattern) then
          target = node
          break
        end
      end
      if target then break end
      node = parent
    end

    if target then
      local sibling = target:next_named_sibling()
      
      -- Skip over comments if they happen to be in the middle of arguments
      while sibling and sibling:type() == "comment" do
        sibling = sibling:next_named_sibling()
      end

      if sibling then
        local text_target = vim.treesitter.get_node_text(target, 0)
        local text_sibling = vim.treesitter.get_node_text(sibling, 0)
        local sr1, sc1, er1, ec1 = target:range()
        local sr2, sc2, er2, ec2 = sibling:range()

        -- Replace sibling (second node) first to avoid shifting coordinates
        vim.api.nvim_buf_set_text(0, sr2, sc2, er2, ec2, vim.split(text_target, '\n'))
        vim.api.nvim_buf_set_text(0, sr1, sc1, er1, ec1, vim.split(text_sibling, '\n'))
      end
    end
EOF
endfunction

function! SwapWithPreviousParameter() abort
  lua << EOF
    local node = vim.treesitter.get_node()
    local patterns = { "list", "arguments", "parameters", "dictionary", "array", "table", "tuple", "class_body", "constructor" }
    local target = nil
    
    while node do
      local parent = node:parent()
      if not parent then break end
      
      local p_type = parent:type()
      for _, pattern in ipairs(patterns) do
        if p_type:find(pattern) then
          target = node
          break
        end
      end
      if target then break end
      node = parent
    end

    if target then
      local sibling = target:prev_named_sibling()
      
      while sibling and sibling:type() == "comment" do
        sibling = sibling:prev_named_sibling()
      end

      if sibling then
        local text_target = vim.treesitter.get_node_text(target, 0)
        local text_sibling = vim.treesitter.get_node_text(sibling, 0)
        local sr1, sc1, er1, ec1 = target:range()
        local sr2, sc2, er2, ec2 = sibling:range()

        -- `sibling` comes BEFORE `target` in the document.
        -- So `target` is second. Replace `target` first!
        vim.api.nvim_buf_set_text(0, sr1, sc1, er1, ec1, vim.split(text_sibling, '\n'))
        vim.api.nvim_buf_set_text(0, sr2, sc2, er2, ec2, vim.split(text_target, '\n'))
      end
    end
EOF
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
