local M = {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}

function M.config()
  require("nvim-ts-autotag").setup({
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  })
end

return M
