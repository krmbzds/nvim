local M = {
  "OXY2DEV/markview.nvim",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
}

function M.config()
  local status_ok, markview = pcall(require, "markview")
  if not status_ok then
    return
  end

  markview.setup()
end

return M
