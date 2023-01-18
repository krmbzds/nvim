local M = {
  "echasnovski/mini.nvim",
}

function M.config()
  local status_ok, mini_indentscope = pcall(require, "mini.indentscope")
  if not status_ok then
    return
  end

  mini_indentscope.setup({
    symbol = "¦",
    draw = {
      delay = 100,
      animation = require("mini.indentscope").gen_animation.linear({
        easing = "in-out",
        duration = 20,
        unit = "total",
      }),
    },
  })

  vim.cmd([[ highlight MiniIndentscopeSymbol guifg=#4B5263 ]])
end

return M
