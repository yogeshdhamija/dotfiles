-- A terminal that ends stays put, read-only, until :bd. Nvim would otherwise wipe it, closing
--   every window showing it, in two ways:
--   1. Its default TermClose handlers: one wipes a :terminal running 'shell' that exits cleanly
--      (e.g. <C-D>), the other prints "[Process exited N]". Both go.
--   2. Any key typed in Terminal mode once it has ended, with no option or hook to stop it. So
--      Terminal mode is left as soon as it's entered there, or when it ends while you're in it.
--      Tracked here rather than with jobwait(), which also counts a still-open nvim_open_term()
--      buffer as ended (its 'channel' is 0), and kept local so nothing else comes to rely on it.
-- Its own message replaces Nvim's, as a virtual line under the last line of output (Nvim has
--   flushed it by TermClose), so it's never yanked or searched.

pcall(vim.api.nvim_clear_autocmds, { group = 'nvim.terminal', event = 'TermClose' })

local ended_terminals = {}  -- buffer number -> true; numbers aren't reused, :bd wipes terminals
local ns = vim.api.nvim_create_namespace('terminal_ended')
local group = vim.api.nvim_create_augroup('terminal-exit', { clear = true })

vim.api.nvim_create_autocmd('TermClose', {
  group = group,
  callback = function(ev)
    if vim.v.event.status == -1 then return end  -- the buffer is being deleted
    ended_terminals[ev.buf] = true
    if ev.buf == vim.api.nvim_get_current_buf() then vim.cmd.stopinsert() end
    local row = vim.api.nvim_buf_line_count(ev.buf)
    while row > 1 and vim.api.nvim_buf_get_lines(ev.buf, row - 1, row, false)[1]:match('^%s*$') do
      row = row - 1
    end
    vim.api.nvim_buf_set_extmark(ev.buf, ns, row - 1, 0, {
      virt_lines = { { { ('-- Terminal ended (exit code %d) --'):format(vim.v.event.status), 'Comment' } } },
    })
  end,
})

vim.api.nvim_create_autocmd('TermEnter', {
  group = group,
  callback = function(ev)
    if ended_terminals[ev.buf] then vim.cmd.stopinsert() end
  end,
})
