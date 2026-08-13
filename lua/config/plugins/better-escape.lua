local M = {
  "max397574/better-escape.nvim",
  event = "InsertCharPre",
}

function M.config()
  local status_ok, better_escape = pcall(require, "better_escape")
  if not status_ok then
    vim.notify("better_escape failed to load: " .. tostring(better_escape), vim.log.levels.ERROR)
    return
  end

  better_escape.setup()
end

return M
