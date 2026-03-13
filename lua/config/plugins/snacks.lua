local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    -- quickfile = { enabled = true },
    -- words = { enabled = true },
    bufdelete = { enabled = true },
    gitbrowse = { enabled = true },
    notifier = { enabled = true, timeout = 2000 },
    terminal = {
      enabled = true,
      win = { style = "terminal", border = "rounded" },
    },
  },
}

return M
