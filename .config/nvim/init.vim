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
    \ ['nvim-lua/plenary.nvim', {}],
    \ ['MunifTanjim/nui.nvim', {}],
    \ ['nvim-tree/nvim-web-devicons', {}],
    \ ['nvim-neo-tree/neo-tree.nvim', {'branch': 'v3.x'}],
    \ ['ncm2/float-preview.nvim', {}],
    \ ['nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}],
    \ ['nvim-treesitter/nvim-treesitter-context', {}],
    \ ['nvim-treesitter/nvim-treesitter-textobjects', {}],
    \ ['williamboman/mason.nvim', {}],
    \ ['williamboman/mason-lspconfig.nvim', {}],
    \ ['neovim/nvim-lspconfig', {}],
    \ ['nvimtools/none-ls.nvim', {}],
    \ ['hrsh7th/nvim-cmp', {}],
    \ ['hrsh7th/cmp-nvim-lsp', {}],
    \ ['MysticalDevil/inlay-hints.nvim', {}],
    \ ['j-hui/fidget.nvim', {}],
    \ ['nvim-lualine/lualine.nvim', {}],
    \ ['mfussenegger/nvim-jdtls', {}],
\ ]

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

" ====================================== NEOVIM SPECIFICS ======================================
lua << EOF

---------------- File browser -----------------------
local neotreestatus, neotree = pcall(require, 'neo-tree')
if (neotreestatus) then
  local renderer = require "neo-tree.ui.renderer"
  local MIN_DEPTH = 2

  local function open_dir(state, dir_node)
    local fs = require "neo-tree.sources.filesystem"
    fs.toggle_directory(state, dir_node, nil, true, false)
  end
  local function recursive_open(state, node, max_depth)
    local max_depth_reached = 1
    local stack = { node }
    while next(stack) ~= nil do
      node = table.remove(stack)
      if node.type == "directory" and not node:is_expanded() then
        open_dir(state, node)
      end

      local depth = node:get_depth()
      max_depth_reached = math.max(depth, max_depth_reached)

      if not max_depth or depth < max_depth - 1 then
        local children = state.tree:get_nodes(node:get_id())
        for _, v in ipairs(children) do
          table.insert(stack, v)
        end
      end
    end

    return max_depth_reached
  end
  local function neotree_zo(state, open_all)
    local node = state.tree:get_node()

    if open_all then
      recursive_open(state, node)
    else
      recursive_open(state, node, node:get_depth() + vim.v.count1)
    end

    renderer.redraw(state)
  end
  local function neotree_zO(state)
    neotree_zo(state, true)
  end
  local function recursive_close(state, node, max_depth)
    if max_depth == nil or max_depth <= MIN_DEPTH then
      max_depth = MIN_DEPTH
    end

    local last = node
    while node and node:get_depth() >= max_depth do
      if node:has_children() and node:is_expanded() then
        node:collapse()
      end
      last = node
      node = state.tree:get_node(node:get_parent_id())
    end

    return last
  end
  local function neotree_zc(state, close_all)
    local node = state.tree:get_node()
    if not node then
      return
      end

    local max_depth
    if not close_all then
      max_depth = node:get_depth() - vim.v.count1
      if node:has_children() and node:is_expanded() then
        max_depth = max_depth + 1
      end
    end

    local last = recursive_close(state, node, max_depth)
    renderer.redraw(state)
    renderer.focus_node(state, last:get_id())
  end

  require("neo-tree").setup({
      use_default_mappings = false,
      auto_clean_after_session_restore = true,
      window = {mappings = {
              ["?"] = "show_help",
              ["<cr>"] = "open",
              ["<esc>"] = "cancel",
              ["\\h"] = "show_file_details",
              ["s"] = {"show_help", nowait=false, config = {title = "Sort by", prefix_key = "s"}},
              ["sc"] = { "order_by_created", nowait = false },
              ["sd"] = { "order_by_diagnostics", nowait = false },
              ["sg"] = { "order_by_git_status", nowait = false },
              ["sm"] = { "order_by_modified", nowait = false },
              ["sn"] = { "order_by_name", nowait = false },
              ["ss"] = { "order_by_size", nowait = false },
              ["st"] = { "order_by_type", nowait = false },
      }},
      filesystem = {
          window = {mappings = {
              ["H"] = "toggle_hidden",
              ["c"] = "rename",
              ["d"] = "delete",
              ["o"] = "add",
              ["y"] = "copy_to_clipboard",
              ["x"] = "cut_to_clipboard",
              ["p"] = "paste_from_clipboard",
              ["zo"] = neotree_zo,
              ["zc"] = neotree_zc,
              ["zO"] = neotree_zO,
              ["zC"] = "close_all_subnodes",
          }},
          filtered_items = { visible = true },
          bind_to_cwd = false
      },
      buffers = {
        window = {mappings = {
              ["bd"] = "buffer_delete",
              ["<C-n>"] = "next_buffer",
              ["<C-p>"] = "previous_buffer",
        }},
        show_unloaded = true,
        bind_to_cwd = false,
      },
      commands = {
        next_buffer = function(state)
          vim.cmd('let oldSearch = @/')
          vim.cmd('norm 0')
          vim.cmd('execute "normal! /#\\<CR>"')
          vim.cmd('norm n')
          vim.cmd('let @/ = oldSearch')
          vim.cmd('noh')
        end,
        previous_buffer = function(state)
          vim.cmd('let oldSearch = @/')
          vim.cmd('norm $')
          vim.cmd('execute "normal! ?#\\<CR>"')
          vim.cmd('norm n')
          vim.cmd('let @/ = oldSearch')
          vim.cmd('noh')
        end,
      }
  })
end

---------------- Tree Sitter ------------------------
local status, ts = pcall(require, 'nvim-treesitter.configs')
local statuscontext, tscontext = pcall(require, 'treesitter-context')
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
    tscontext.setup { mode='topline' }
end

---------------- LSP --------------------------------

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
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
      ensure_installed = {'lua_ls', 'rust_analyzer', 'jdtls'},
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
local statusline,line = pcall(require, 'lualine')
if(statusline) then
    line.setup({})
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
    let cur = expand('%:p')
    if stridx(cur, getcwd()) >= 0 && filereadable(cur)
      exe "norm \<CMD>Neotree filesystem reveal current\<CR>"
    elseif filereadable(cur)
      exe "norm \<CMD>Neotree filesystem dir=%:p:h reveal=true current\<CR>"
    else
      exe "norm \<CMD>Neotree filesystem reveal=false current\<CR>"
    endif
endfunction

function! ListBuffers() abort
    let alt = expand('#:p')
    if stridx(alt, getcwd()) >= 0 && filereadable(alt)
      execute "normal! :Neotree buffers reveal_file=#:p float\<CR>"
    else
      execute "normal! :Neotree buffers reveal=false float\<CR>"
    endif
endfunction

