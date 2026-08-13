local M = {
  url = "https://codeberg.org/fosk/registers.nvim",
  "tversteeg/registers.nvim",
  lazy = true,
  keys = {
    { '"', mode = "n" },
    { '"', mode = "v" },
    { "<C-r>", mode = "i" },
  },
}

function M.config()
  local status_ok, registers = pcall(require, "registers")
  if not status_ok then
    vim.notify("registers failed to load: " .. tostring(registers), vim.log.levels.ERROR)
    return
  end

  registers.setup({
    window = {
      max_width = 0,
      border = "rounded",
      transparency = 20,
    },
  })
end

return M
