local M = {
  "EtiamNullam/deferred-clipboard.nvim",
  event = "VeryLazy",
}

function M.config()
  local status_ok, deferred_clipboard = pcall(require, "deferred-clipboard")
  if not status_ok then
    vim.notify("deferred-clipboard failed to load: " .. tostring(deferred_clipboard), vim.log.levels.ERROR)
    return
  end

  deferred_clipboard.setup({ fallback = "unnamedplus", lazy = true })
end

return M
