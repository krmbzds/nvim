local M = {
  "DrKJeff16/project.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  cmd = { "Project" },
}

function M.config()
  local status_ok, project = pcall(require, "project")
  if not status_ok then
    return
  end

  project.setup({
    manual_mode = false,
    lsp = { enabled = false },
    patterns = { ".git", "Makefile", "Gemfile", "package.json" },
    show_hidden = false,
    silent_chdir = true,
    history = {
      save_dir = vim.fn.stdpath("data"),
      size = 100,
    },
  })

  local tele_ok, telescope = pcall(require, "telescope")
  if not tele_ok then
    return
  end

  telescope.load_extension("projects")
end

return M
