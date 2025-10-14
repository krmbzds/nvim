local M = {
  "chrisgrieser/nvim-origami",
  lazy = true,
  event = "BufReadPost", -- later or on keypress would prevent saving folds
  opts = true, -- needed even when using default config
}

function M.config()
  local status_ok, origami = pcall(require, "origami")
  if not status_ok then
    return
  end

  origami.setup({
    useLspFoldsWithTreesitterFallback = true,
    pauseFoldsOnSearch = true,
    foldtext = {
      enabled = true,
      padding = 3,
      lineCount = {
        template = "%d lines", -- `%d` is replaced with the number of folded lines
        hlgroup = "Comment",
      },
      diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
      gitsignsCount = true, -- requires `gitsigns.nvim`
    },
    autoFold = {
      enabled = true,
      kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
    },
    foldKeymaps = {
      setup = true, -- modifies `h`, `l`, and `$`
      hOnlyOpensOnFirstColumn = false,
    },
  })
end

return M
