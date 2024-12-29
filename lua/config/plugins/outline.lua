local M = {
  "hedyhli/outline.nvim",
  cmd = { "Outline", "OutlineOpen" },
  event = "VeryLazy",
  dependencies = {
    "msr1k/outline-asciidoc-provider.nvim",
  },
}

function M.config()
  local status_ok, outline = pcall(require, "outline")
  if not status_ok then
    return
  end

  outline.setup({
    outline_window = {
      auto_jump = true,
    },

    symbol_folding = {
      autofold_depth = 0,
      auto_unfold = {
        hovered = true,
        only = true,
      },
    },

    providers = {
      priority = { "lsp", "asciidoc", "markdown", "norg" },
      lsp = {
        blacklist_clients = {},
      },
      markdown = {
        filetypes = { "markdown" },
      },
    },
  })
end

return M
