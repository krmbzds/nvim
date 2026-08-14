local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  priority = 1000,
  lazy = false,
}

function M.config()
  require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  require("nvim-treesitter")
    .install({
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
    })
    :wait(300000)

  local group = vim.api.nvim_create_augroup("nvim-treesitter-highlight", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      -- main does not auto-enable highlighting; use built-in vim.treesitter.
      pcall(vim.treesitter.start)

      local ft = vim.bo[args.buf].filetype
      if ft == "yaml" then
        return
      end

      -- indent is experimental on main; opt in only when a parser is available.
      local ok, installed = pcall(require("nvim-treesitter").get_installed)
      if not ok or not vim.list_contains(installed, ft) then
        return
      end

      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

return M
