local M = {
  "stevearc/dressing.nvim",
  lazy = true,
  event = "VeryLazy",
}

function M.config()
  local status_ok, dressing = pcall(require, "dressing")
  if not status_ok then
    vim.notify("dressing failed to load: " .. tostring(dressing), vim.log.levels.ERROR)
    return
  end

  dressing.setup({
    input = {
      mappings = {
        n = {
          ["<Esc>"] = "Close",
          ["<CR>"] = "Confirm",
        },
        i = {
          ["<C-c>"] = "Close",
          ["<CR>"] = "Confirm",
          ["<C-p>"] = "HistoryPrev",
          ["<C-n>"] = "HistoryNext",
        },
      },
    },
  })
end

return M
