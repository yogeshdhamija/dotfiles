-- A yank from a terminal joins the rows the terminal wrapped, so a long line pastes as one line.
--   Nvim stores each terminal row as its own buffer line and doesn't expose which rows are
--   wrapped (libvterm tracks it, Nvim keeps it to itself). A wrapped row always fills the
--   terminal's full width, so a full-width row is taken as wrapped. That misses two cases:
--   - A line printed exactly full width on purpose (e.g. a ──── rule) gets joined to the next.
--   - Scrollback printed while the terminal was another width isn't joined: Nvim doesn't
--     reflow scrollback, so those rows are as wide as the terminal was then.
--   Programs that wrap their own text, like Claude Code, print real newlines, which look the same
--   as any other line break. So \m chats are left alone: their full-width rows are box borders
--   more often than wrapped text. Blockwise yanks keep their rows too.

local group = vim.api.nvim_create_augroup('terminal-yank', { clear = true })

-- Nvim (as of 0.12, undocumented) sizes the terminal to the widest window showing it, less
--   that window's number/sign/fold columns.
local function terminal_width(buf)
  local width = 0
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    width = math.max(width, vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff)
  end
  return width
end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function(ev)
    local event = vim.v.event
    local contents = event.regcontents
    if vim.bo[ev.buf].buftype ~= 'terminal' or vim.b[ev.buf].gen_ai_model_chat
        or event.regtype:sub(1, 1) == '\22' or #contents < 2 then
      return
    end

    -- regcontents[i] is from buffer line first + i - 1, whole or in part
    local first = vim.api.nvim_buf_get_mark(ev.buf, '[')[1]
    local rows = vim.api.nvim_buf_get_lines(ev.buf, first - 1, first - 1 + #contents, false)
    local width = terminal_width(ev.buf)
    local joined = { contents[1] }
    for i = 2, #contents do
      if vim.fn.strdisplaywidth(rows[i - 1] or '') == width then
        joined[#joined] = joined[#joined] .. contents[i]
      else
        joined[#joined + 1] = contents[i]
      end
    end
    if #joined == #contents then return end

    -- '"' is whichever register the yank filled ("0 for a plain y), so it fixes p too
    vim.fn.setreg(event.regname == '' and '"' or event.regname, joined, event.regtype)
  end,
})
