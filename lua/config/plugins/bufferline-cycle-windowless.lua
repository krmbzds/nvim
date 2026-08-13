local M = {
  "roobert/bufferline-cycle-windowless.nvim",
  event = "BufReadPost",
  dependencies = {
    { "akinsho/bufferline.nvim" },
  },
}

function M.config()
  local status_ok, bufferline_cycle_windowless = pcall(require, "bufferline-cycle-windowless")
  if not status_ok then
    vim.notify(
      "bufferline-cycle-windowless failed to load: " .. tostring(bufferline_cycle_windowless),
      vim.log.levels.ERROR
    )
    return
  end

  bufferline_cycle_windowless.setup({
    -- whether to start in enabled or disabled mode
    default_enabled = true,
  })
end

return M
