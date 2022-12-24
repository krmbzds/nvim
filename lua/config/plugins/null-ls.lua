local M = {
  "jose-elias-alvarez/null-ls.nvim",
}

function M.config()
  local null_ls_ok, null_ls = pcall(require, "null-ls")
  if not null_ls_ok then
    return
  end

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics

  null_ls.setup({
    debug = false,
    sources = {
      diagnostics.shellcheck,
      diagnostics.vale,
      formatting.erb_lint,
      formatting.jq,
      formatting.prettierd.with({
        env = {
          PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/prettier/config.json"),
        },
      }),
      formatting.standardrb,
      formatting.stylua,
    },
  })
end

return M
