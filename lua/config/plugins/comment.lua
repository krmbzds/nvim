local M = {
  "numToStr/Comment.nvim",
  keys = { "gc", "gb", "/" },
}

function M.config()
  local status_ok, comment = pcall(require, "Comment")
  if not status_ok then
    return
  end

  comment.setup({
    ignore = "^$",
  })
end

return M
