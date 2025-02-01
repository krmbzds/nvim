local M = {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "InsertEnter", "TextChanged", "TextChangedI", "BufWritePre" },
  opts = {},
}

function M.config()
  local status_ok, conform = pcall(require, "conform")
  if not status_ok then
    return
  end

  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      ruby = { "standardrb" },
      yaml = { "yamlfmt" },
    },
  })
end

return M
