local M = {
  "tzachar/highlight-undo.nvim",
  lazy = true,
  keys = {
    { "u", desc = "Undo" },
    { "<C-R>", desc = "Redo" },
    { "<C-Z>", "<Cmd>normal u<CR>", mode = "i", desc = "Undo" },
  },
}

function M.config()
  local status_ok, highlight_undo = pcall(require, "highlight-undo")
  if not status_ok then
    return
  end

  highlight_undo.setup({
    duration = 300,
    undo = {
      hlgroup = "Search",
      mode = "n",
      lhs = "u",
      map = "undo",
      opts = {},
    },
    redo = {
      hlgroup = "Search",
      mode = "n",
      lhs = "<C-r>",
      map = "redo",
      opts = {},
    },
    highlight_for_count = true,
  })
end

return M
