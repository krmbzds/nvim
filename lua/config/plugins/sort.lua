local M = {
  "sQVe/sort.nvim",
  lazy = true,
  cmd = { "Sort" },
}

function M.config()
  local status_ok, sort = pcall(require, "sort")
  if not status_ok then
    vim.notify("sort failed to load: " .. tostring(sort), vim.log.levels.ERROR)
    return
  end

  sort.setup({})
end

return M
