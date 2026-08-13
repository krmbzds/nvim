local M = {
  "nvim-treesitter/nvim-treesitter",
  -- D-08 targeted pin: the "main" rewrite removed `nvim-treesitter.configs`
  -- (and `define_modules`), silently breaking this old-API config. Pin the
  -- legacy `master` branch, which retains the API this spec is written for.
  branch = "master",
  build = ":TSUpdate",
  priority = 1000,
  lazy = false,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  dependencies = {
    "windwp/nvim-autopairs",
    "RRethy/vim-illuminate",
    "abecodes/tabout.nvim",
    "RRethy/nvim-treesitter-endwise",
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
    "windwp/nvim-ts-autotag",
    "kylechui/nvim-surround",
  },
}

function M.config()
  local status_ok, configs = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    vim.notify("nvim-treesitter.configs failed to load: " .. tostring(configs), vim.log.levels.ERROR)
    return
  end

  configs.setup({
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "comment",
      "cpp",
      "css",
      "dockerfile",
      "hcl",
      "html",
      "http",
      "javascript",
      "json",
      "json5",
      "jsonc",
      "lua",
      "make",
      "python",
      "ruby",
      "scss",
      "toml",
      "typescript",
      "vim",
      "yaml",
    },
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = { "" }, -- List of parsers to ignore installing
    autopairs = {
      enable = true,
    },
    autotag = {
      enable = true,
      filetypes = { "html", "xml", "javascript", "typescript" },
    },
    endwise = {
      enable = true,
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { "" }, -- list of language that will be disabled
      -- additional_vim_regex_highlighting = true,
    },
    indent = { enable = true, disable = { "yaml" } },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
        include_surrounding_whitespace = true,
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]a"] = "@parameter.inner",
          ["]b"] = "@block.inner",
          ["]c"] = "@class.inner",
          ["]f"] = "@function.inner",
          ["]m"] = "@function.outer",
        },
        goto_next_end = {
          ["]eb"] = "@block.inner",
          ["]ec"] = "@class.inner",
          ["]ef"] = "@function.inner",
          ["]em"] = "@function.outer",
        },
        goto_previous_start = {
          ["[a"] = "@parameter.inner",
          ["[b"] = "@block.inner",
          ["[c"] = "@class.inner",
          ["[f"] = "@function.inner",
          ["[m"] = "@function.outer",
        },
        goto_previous_end = {
          ["[eb"] = "@block.inner",
          ["[ec"] = "@class.inner",
          ["[ef"] = "@function.inner",
          ["[em"] = "@function.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = { ["]["] = "@parameter.inner" },
        swap_previous = { ["[]"] = "@parameter.inner" },
      },
    },
  })
end

return M
