local M = {
  "chrisgrieser/nvim-origami",
  lazy = true,
  event = "BufReadPost", -- later or on keypress would prevent saving folds
  dependencies = {
    "kevinhwang91/nvim-ufo",
  },
  opts = true, -- needed even when using default config
}

function M.config()
  local status_ok, origami = pcall(require, "origami")
  if not status_ok then
    return
  end

  origami.setup({
    keepFoldsAcrossSessions = true,
    pauseFoldsOnSearch = true,
    foldKeymaps = {
      setup = true,
    },
  })
end

return M
