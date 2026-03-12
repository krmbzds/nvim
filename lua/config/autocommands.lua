local api = vim.api

api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo" },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})

api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "asciidoc", "gitcommit", "markdown" },
  callback = function()
    ---@diagnostic disable
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    ---@diagnostic enable
  end,
})

api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

api.nvim_create_autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd("quit")
  end,
})

api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd("set formatoptions-=cro")
  end,
})

api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Leap
local leap_illuminate = api.nvim_create_augroup("LeapIlluminate", { clear = true })

api.nvim_create_autocmd("User", {
  pattern = "LeapEnter",
  callback = function()
    require("illuminate").pause()
  end,
  group = leap_illuminate,
})

api.nvim_create_autocmd("User", {
  pattern = "LeapLeave",
  callback = function()
    require("illuminate").resume()
  end,
  group = leap_illuminate,
})

-- Go to last cursor position when opening a buffer
api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = api.nvim_buf_get_mark(0, '"')
    local lcount = api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Clear WinBar & WinBarNC background
api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  group = api.nvim_create_augroup("WinBarHlClearBg", { clear = true }),
  callback = CLEAR_WINBAR_BG,
})
