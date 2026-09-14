local M = {
  "kitlangton/navi.nvim",
  lazy = true,
  cmd = { "NaviLoad", "NaviNext", "NaviPrev", "NaviPick", "NaviClear", "NaviTest" },
  keys = {
    { "<leader>rj", "<cmd>NaviNext<cr>", desc = "Next Navi stop" },
    { "<leader>rl", "<cmd>NaviNext<cr>", desc = "Next Navi stop" },
    { "<leader>rk", "<cmd>NaviPrev<cr>", desc = "Previous Navi stop" },
    { "<leader>rh", "<cmd>NaviPrev<cr>", desc = "Previous Navi stop" },
    { "<leader>rp", "<cmd>NaviPick<cr>", desc = "Pick Navi stop" },
    { "<leader>rc", "<cmd>NaviClear<cr>", desc = "Clear Navi tour" },
  },
}

return M
