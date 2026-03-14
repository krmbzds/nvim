local api = vim.api
local fn = vim.fn

local function empty(s)
  return not s or s == ""
end

local function format(s)
  return fn.shellescape(s, true):sub(2, -2)
end

local function echo(msg)
  api.nvim_echo({ { "grep.app: ", "Error" }, { msg } }, true, {})
end

local function cursorline()
  return format(fn.getline(".")) --- @diagnostic disable-line: param-type-mismatch
end

local function clipboard()
  return format(fn.getreg("+"):gsub("\n", " "))
end

local function set_clipboard(text)
  fn.setreg("+", text)
end

local function input(args)
  fn.inputsave()
  local query = fn.input(args)
  fn.feedkeys(":", "nx")
  fn.inputrestore()
  return query
end

local function open(query)
  local job = require("plenary.job")
  local url = "https://grep.app/search?q="
  job:new({ command = "open", args = { url .. query } }):start()
end

-- stylua: ignore
local function grep_app(s, err)
  if not empty(s) then open(s) else echo(err) end
end

-- Set WinBar & WinBarNC background to Normal background
function CLEAR_WINBAR_BG()
  api.nvim_set_hl(0, "WinBar", { bg = "NONE", ctermbg = "NONE" })
  api.nvim_set_hl(0, "WinBarNC", { bg = "NONE", ctermbg = "NONE" })
end

-- Commands

-- Format
api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

-- Search cursor line
api.nvim_create_user_command("GrepAppCursorLine", function()
  grep_app(cursorline(), "Cursor line empty")
end, { desc = "Search cursor line on grep.app" })

-- Search clipboard content
api.nvim_create_user_command("GrepAppClipboard", function()
  grep_app(clipboard(), "Clipboard empty")
end, { desc = "Search clipboard contents on grep.app" })

-- Search prompt
api.nvim_create_user_command("GrepAppInput", function()
  grep_app(input({ prompt = "grep.app: ", completion = "buffer" }), "Search cancelled")
end, { desc = "Search input on grep.app" })

-- Open commit in browser
api.nvim_create_user_command("GitBrowseCommitOpen", function()
  require("snacks").gitbrowse({ what = "commit" })
end, { desc = "Open commit in browser" })

-- Copy commit URL to clipboard
api.nvim_create_user_command("GitBrowseCommitCopy", function()
  require("snacks").gitbrowse({ what = "commit", open = set_clipboard })
end, { desc = "Copy commit URL" })

-- Copy commit hash of current line under cursor
api.nvim_create_user_command("GitCopyLineCommitHash", function()
  local file = vim.fn.expand("%:p")
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local cmd = string.format('git blame -L %d,%d --porcelain "%s"|head -n1|cut -d" " -f1', line, line, file)
  local hash = vim.fn.system(cmd):gsub("\n", "")
  if hash ~= "" then
    set_clipboard(hash)
  end
end, { desc = "Copy line commit hash" })

-- Open visual selection in browser
api.nvim_create_user_command("GitBrowseOpen", function()
  require("snacks").gitbrowse()
end, { desc = "Open in browser", range = true })

-- Copy visual selection permalink to clipboard
api.nvim_create_user_command("GitBrowseCopy", function()
  require("snacks").gitbrowse({ open = set_clipboard })
end, { desc = "Copy to clipboard", range = true })

-- Global functions
function REPEAT_LAST_MACRO_OR_Q()
  if pcall(function()
    return vim.fn.getreg("@@") == ""
  end) then
    vim.cmd("normal! @q")
  else
    vim.cmd("normal! @@")
  end
end
