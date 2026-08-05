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
    \ ['samjwill/nvim-unception', {}],
\ ]
let added_plugins = added_plugins + dependencies + file_browser + treesitter + lsp + language + interface_stuff + debugging + other_stuff

" ====================================== LOAD VIMRC ======================================
source ~/.vimrc

" ====================================== CHANGE SETTINGS ======================================

" This doesnt work as of 2026-03-07. Will retry someday.
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

silent! aunmenu PopUp.How-to\ disable\ mouse
silent! aunmenu PopUp.-1-

set termguicolors
set noshowmode

set scrollback=100000
" Guarded so an --cmd from the $EDITOR wrapper wins; init.vim is sourced after it.
if !exists('g:unception_open_buffer_in_new_tab')
    let g:unception_open_buffer_in_new_tab=1
endif

set background=dark
hi! link SignColumn Normal
hi! link TreesitterContext Normal

nnoremap \f <cmd>GrugFar<CR>
vnoremap \f <Esc><cmd>'<,'>GrugFar<CR>

" ====================================== NEOVIM SPECIFICS ======================================
lua << EOF



local farstatus, far = pcall(require, 'grug-far')
if (farstatus) then
 -- Only true while the <enter> mapping below runs. See the comment on that mapping.
 local force_new_target = false
 far.setup{
    windowCreationCommand = '',
    openTargetWindow = {
      preferredLocation = 'right',
      exclude = { function() return force_new_target end },
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
      gotoLocation = { n = '' },
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
      nextInput = { n = '' },
      prevInput = { n = '' },
    },
 }

  -- goto_location opens into some window other than its own, reusing an existing one at
  -- preferredLocation if it finds a candidate. Excluding everything for the duration of the call
  -- forces it to build a throwaway window instead of hijacking one that already has a buffer in it;
  -- we then pull the result back into the grug-far window and close the throwaway. The exclude is
  -- scoped to this mapping so <localleader>n/p keep reusing windows as usual. The m' is what
  -- makes <C-O> land back on the search results: jumplists are per-window, not per-buffer.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'grug-far',
    callback = function(ev)
      vim.keymap.set('n', '<enter>', function()
        local instance = require('grug-far').get_instance(ev.buf)
        if not instance then return end

        local farwin = vim.api.nvim_get_current_win()
        vim.cmd("normal! m'")

        force_new_target = true
        local ok = pcall(instance.goto_location, instance)
        force_new_target = false
        if not ok then return end

        local win = vim.api.nvim_get_current_win()
        if win == farwin then return end
        local buf = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(win)

        vim.api.nvim_win_close(win, false)
        vim.api.nvim_set_current_win(farwin)
        vim.api.nvim_win_set_buf(farwin, buf)
        pcall(vim.api.nvim_win_set_cursor, farwin, cursor)
      end, { buffer = ev.buf, desc = 'Goto location (current window)' })
    end,
  })
end



---------------- File browser -----------------------
pcall(function() require('mini.icons').setup() end)
local oilstatus, oil = pcall(require, 'oil')
if (oilstatus) then
  function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require("oil").get_current_dir(bufnr)
    if dir then
      return vim.fn.fnamemodify(dir, ":~")
    else
      -- If there is no current directory (e.g. over ssh), just show the buffer name
      return vim.api.nvim_buf_get_name(0)
      end
      end
  -- Absolute path of the entry under the cursor, for :CP. Empty string when the
  --   buffer has no local path to offer (e.g. oil-ssh:// over a remote).
  function _G.get_oil_cursor_path()
    local dir = require("oil").get_current_dir(0)
    if not dir then
      return ""
    end
    local entry = require("oil").get_cursor_entry()
    if not entry then
      -- Cursor is past the last entry: fall back to the directory being shown.
      return dir
    end
    local path = (dir:gsub("/$", "")) .. "/" .. entry.name
    -- Trailing slash comes from the entry's own type, so it is still correct for
    --   a directory typed into the buffer that has not been written to disk yet.
    if entry.type == "directory" then
      path = path .. "/"
    end
    return path
  end
  local detail = true
  oil.setup{
    watch_for_changes=true,
    columns = {"permissions", "size", "mtime", "icon" },
    delete_to_trash = true,
    cleanup_delay_ms = false,
    view_options = {
      show_hidden = true,
    },
    win_options = {
      signcolumn = "auto:2",
        winbar = "%!v:lua.get_oil_winbar()",
      cursorline = true,
      cursorlineopt = "both",
    },
    keymaps = {
      -- Keep ` for the marks helper instead of oil's :cd
      ["`"] = false,
      -- No accidental cwd changes (:tcd)
      ["g~"] = false,
      -- Open in a vertical split with t instead of <C-s>
      ["<C-s>"] = false,
      ["t"] = { "actions.select", opts = { vertical = true }, mode = "n" },
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

function! CopyPath(absolute) abort
  if &filetype ==# 'oil'
    call CopyPathToRegisters(v:lua.get_oil_cursor_path(), a:absolute)
  else
    call CopyPathToRegisters(expand('%:p'), a:absolute)
  endif
endfunction

function! CloseWindowsWithFileType(filetype)
  let l:current_win = winnr()
  let l:win_count = winnr('$')
  for l:i in range(1, l:win_count)
    exe l:i . 'wincmd w'
    if &filetype == a:filetype
      close
      let l:win_count -= 1
      let l:i -= 1
    endif
  endfor
  exe l:current_win . 'wincmd w'
endfunction


function! SendToNearest(Matches, Create, text) abort
    let l:found = 0
    let l:curbuf = bufnr('%')

    " Move cursor to matching window (if any) (mru)
    for l:winnr in sort(range(1, winnr('$')), function('s:CompareWindowUse'))
        let l:bufnr = winbufnr(l:winnr)
        if l:bufnr != l:curbuf && a:Matches(l:bufnr)
            execute l:winnr . "wincmd w"
            let l:found = 1
            break
        endif
    endfor

    " Else, switch current window to matching buffer (if any) (mru)
    if(!l:found)
        let l:infos = sort(getbufinfo(),
                    \ { x, y -> y.lastused != x.lastused
                    \           ? y.lastused - x.lastused
                    \           : y.bufnr - x.bufnr })
        for l:buffer_nr in map(l:infos, 'v:val.bufnr')
            if l:buffer_nr != l:curbuf && a:Matches(l:buffer_nr)
                execute 'buffer' l:buffer_nr
                let l:found = 1
                break
            endif
        endfor
    endif

    " Else, start a new buffer in current window
    if(!l:found)
        call a:Create()
    endif

	" Paste text
    let l:orig_z = @z
    let @z = empty(a:text) ? '' : a:text
    stopinsert
    normal! "zp
    let @z = l:orig_z
    normal! i
endfunction

function! RunInNearestTerminal(cmd) range abort
    call SendToNearest(
                \ { bufnr -> getbufvar(bufnr, '&buftype') ==# 'terminal'
                \            && getbufvar(bufnr, '&filetype') !=# 'mchat' },
                \ function('StartTerminal'),
                \ a:cmd)
endfunction

function! OpenNearestGenAiModelChat(text) range abort
  call SendToNearest(
        \ { bufnr -> getbufvar(bufnr, '&filetype') ==# 'mchat' },
        \ { -> execute(['terminal claude', 'setlocal filetype=mchat']) },
        \ a:text)
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

call SourceProjectFileIfExists(".vim/vimrc.local")
