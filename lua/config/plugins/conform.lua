local M = {
  "stevearc/conform.nvim",
  lazy = false,
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

    notify_on_error = true,
  })

  vim.keymap.set("n", "<leader>lf", function()
    require("conform").format({ async = true })
  end, { desc = "Format" })
end

return M
