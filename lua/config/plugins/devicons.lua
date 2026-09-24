local M = {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
}

function M.config()
  require("nvim-web-devicons").setup({
    override = {
      css = { icon = "󰌜", color = "#663399", name = "Css" },
      yml = { icon = "󱁼", color = "#BD93F9", name = "Yml" },
      yaml = { icon = "󱁼", color = "#BD93F9", name = "Yaml" },
    },
  })
end

return M
