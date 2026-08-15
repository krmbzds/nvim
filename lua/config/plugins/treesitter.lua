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

  -- Third-party parsers: register asciidoc (markview prerequisite).
  -- nvim-treesitter's install() reloads the parser table and fires a "User TSUpdate"
  -- autocmd before resolving languages, so registration must happen in that hook.
  --
  -- PINNED to dd0d426: markview.nvim's AsciiDoc parser queries reference the node
  -- types `attr_value` (block) and `ltalic` (inline), which the cathaysia grammar
  -- renamed/removed in June 2026 (`attr_value` -> `attribute_value` in d01171b,
  -- `ltalic` -> `italic` in 06386c8). On the newer grammar, markview's whole query
  -- fails to parse and AsciiDoc renders nothing. Pin both parsers to the last commit
  -- that still has these node types. The parser .so files and queries must be
  -- installed at this revision (see parser-info/*.revision).
  vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
      require("nvim-treesitter.parsers").asciidoc = {
        install_info = {
          url = "https://github.com/cathaysia/tree-sitter-asciidoc",
          branch = "master",
          revision = "dd0d4262fd0a7b2e99fd795a7f6b47190ab15eb2",
          location = "tree-sitter-asciidoc",
          queries = "queries/asciidoc/",
        },
        requires = { "asciidoc_inline" },
      }
      require("nvim-treesitter.parsers").asciidoc_inline = {
        install_info = {
          url = "https://github.com/cathaysia/tree-sitter-asciidoc",
          branch = "master",
          revision = "dd0d4262fd0a7b2e99fd795a7f6b47190ab15eb2",
          location = "tree-sitter-asciidoc_inline",
          queries = "queries/asciidoc_inline",
        },
      }
    end,
  })

  require("nvim-treesitter")
    .install({
      "asciidoc",
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
      "lua",
      "make",
      "markdown",
      "markdown_inline",
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
