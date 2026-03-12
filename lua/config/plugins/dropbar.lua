local M = {
  "Bekaboo/dropbar.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
}

function M.config()
  local dropbar = require("dropbar")
  local ignore = require("config.ignore")
  local icons = require("config.icons")

  dropbar.setup({
    icons = {
      kinds = {
        symbols = icons.kind,
      },
      ui = {
        bar = {
          separator = icons.symbols.separator,
          extends = icons.symbols.ellipsis,
        },
        menu = {
          separator = "",
          indicator = "",
        },
      },
    },
    bar = {
      enable = function(buf, win)
        local api = vim.api
        local ft = vim.bo[buf].filetype
        if vim.tbl_contains(ignore.dropbar_ignore_patterns, ft) then
          return false
        end
        return api.nvim_win_get_config(win).relative == ""
      end,
    },
  })
end

return M
