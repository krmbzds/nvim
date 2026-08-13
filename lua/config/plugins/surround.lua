local M = {
  "kylechui/nvim-surround",
  lazy = true,
  keys = {
    { "s", mode = { "n", "v" } },
    { "ds", mode = "n" },
    { "cs", mode = "n" },
  },
}

function M.config()
  local status_ok, surround = pcall(require, "nvim-surround")
  if not status_ok then
    vim.notify("nvim-surround failed to load: " .. tostring(surround), vim.log.levels.ERROR)
    return
  end

  surround.setup({})
end

return M
