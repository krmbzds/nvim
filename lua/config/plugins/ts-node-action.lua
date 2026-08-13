local M = {
  "CKolkey/ts-node-action",
  lazy = true,
  dependencies = { "nvim-treesitter" },
}

function M.config()
  local status_ok, ts_node_action = pcall(require, "ts-node-action")
  if not status_ok then
    vim.notify("ts-node-action failed to load: " .. tostring(ts_node_action), vim.log.levels.ERROR)
    return
  end

  ts_node_action.setup({})
end

return M
