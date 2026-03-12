local M = {
  "DrKJeff16/project.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  lazy = true,
  cmd = {
    "Project",
    "ProjectAdd",
    "ProjectConfig",
    "ProjectDelete",
    "ProjectExport",
    "ProjectHealth",
    "ProjectHistory",
    "ProjectImport",
    "ProjectRecents",
    "ProjectRoot",
    "ProjectSession",
    "ProjectTelescope",
  },
}

function M.config()
  local status_ok, project = pcall(require, "project")
  if not status_ok then
    return
  end

  project.setup({
    before_attach = nil,
    on_attach = nil,
    lsp = {
      enabled = true,
      ignore = {},
      use_pattern_matching = false,
      no_fallback = false,
    },
    manual_mode = false,
    patterns = {
      ".git",
      "Gemfile",
    },
    different_owners = {
      allow = false,
      notify = true,
    },
    enable_autochdir = false,
    show_hidden = false,
    exclude_dirs = {},
    silent_chdir = true,
    scope_chdir = "global",
    datapath = vim.fn.stdpath("data"),
    historysize = 100,
    log = {
      enabled = false,
      max_size = 1.1,
      logpath = vim.fn.stdpath("state"),
    },
    snacks = {
      enabled = false,
      opts = {
        hidden = false,
        sort = "newest",
        title = "Select Project",
        layout = "select",
        -- icon = {},
        -- path_icons = {},
      },
    },
    fzf_lua = { enabled = false },
    picker = {
      enabled = false,
      hidden = false,
      sort = "newest",
    },
    disable_on = {
      ft = {
        "",
        "NvimTree",
        "TelescopePrompt",
        "TelescopeResults",
        "alpha",
        "checkhealth",
        "lazy",
        "log",
        "ministarter",
        "neo-tree",
        "notify",
        "nvim-pack",
        "packer",
        "qf",
      },
      bt = { "help", "nofile", "nowrite", "terminal" },
    },
    telescope = {
      sort = "newest",
      prefer_file_browser = false,
      disable_file_picker = false,
      mappings = {
        n = {
          b = "browse_project_files",
          d = "delete_project",
          f = "find_project_files",
          r = "recent_project_files",
          s = "search_in_project_files",
          w = "change_working_directory",
        },
        i = {
          ["<C-b>"] = "browse_project_files",
          ["<C-d>"] = "delete_project",
          ["<C-f>"] = "find_project_files",
          ["<C-r>"] = "recent_project_files",
          ["<C-s>"] = "search_in_project_files",
          ["<C-w>"] = "change_working_directory",
        },
      },
    },
  })

  local tele_ok, telescope = pcall(require, "telescope")
  if not tele_ok then
    return
  end

  telescope.load_extension("projects")
end

return M
