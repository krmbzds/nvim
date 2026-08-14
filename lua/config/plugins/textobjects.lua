local M = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}

function M.config()
  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
      include_surrounding_whitespace = true,
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
    },
    move = {
      set_jumps = true,
    },
  })

  local select = require("nvim-treesitter-textobjects.select")
  local move = require("nvim-treesitter-textobjects.move")
  local swap = require("nvim-treesitter-textobjects.swap")

  -- select (x, o)
  local selects = {
    ab = "@block.outer",
    ib = "@block.inner",
    af = "@function.outer",
    ["if"] = "@function.inner",
    ac = "@class.outer",
    ic = "@class.inner",
    aa = "@parameter.outer",
    ia = "@parameter.inner",
  }
  for key, capture in pairs(selects) do
    vim.keymap.set({ "x", "o" }, key, function()
      select.select_textobject(capture, "textobjects")
    end)
  end

  -- move: goto_next_start
  local next_starts = {
    ["]a"] = "@parameter.inner",
    ["]b"] = "@block.inner",
    ["]c"] = "@class.inner",
    ["]f"] = "@function.inner",
    ["]m"] = "@function.outer",
  }
  for key, capture in pairs(next_starts) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
      move.goto_next_start(capture, "textobjects")
    end)
  end

  -- move: goto_next_end
  local next_ends = {
    ["]eb"] = "@block.inner",
    ["]ec"] = "@class.inner",
    ["]ef"] = "@function.inner",
    ["]em"] = "@function.outer",
  }
  for key, capture in pairs(next_ends) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
      move.goto_next_end(capture, "textobjects")
    end)
  end

  -- move: goto_previous_start
  local prev_starts = {
    ["[a"] = "@parameter.inner",
    ["[b"] = "@block.inner",
    ["[c"] = "@class.inner",
    ["[f"] = "@function.inner",
    ["[m"] = "@function.outer",
  }
  for key, capture in pairs(prev_starts) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
      move.goto_previous_start(capture, "textobjects")
    end)
  end

  -- move: goto_previous_end
  local prev_ends = {
    ["[eb"] = "@block.inner",
    ["[ec"] = "@class.inner",
    ["[ef"] = "@function.inner",
    ["[em"] = "@function.outer",
  }
  for key, capture in pairs(prev_ends) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
      move.goto_previous_end(capture, "textobjects")
    end)
  end

  -- swap (n)
  vim.keymap.set("n", "][", function()
    swap.swap_next("@parameter.inner")
  end)
  vim.keymap.set("n", "[]", function()
    swap.swap_previous("@parameter.inner")
  end)
end

return M
