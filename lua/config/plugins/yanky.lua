local api = vim.api
local M = {
  "gbprod/yanky.nvim",
}

function M.config()
  local status_ok, yanky = pcall(require, "yanky")
  if not status_ok then
    return
  end

  yanky.setup({})

  api.nvim_create_user_command("YankHistory", function()
    local status_telescope_ok, telescope = pcall(require, "telescope")
    if status_telescope_ok then
      telescope.load_extension("yank_history")
      telescope.extensions.yank_history.yank_history()
    else
      vim.notify("Telescope not found!", vim.log.levels.WARN)
    end
  end, {})
end

return M
