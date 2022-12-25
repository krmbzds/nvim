local M = {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    -- LSP Support
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",

    -- Autocompletion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "jose-elias-alvarez/null-ls.nvim",
    "jay-babu/mason-null-ls.nvim",

    -- Snippets
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",

    -- Miscellaneous
    "j-hui/fidget.nvim",
  },
}

function M.config()
  local status_neodev_ok, neodev = pcall(require, "neodev")
  if not status_neodev_ok then
    return
  end

  local status_null_ls_ok, null_ls = pcall(require, "null-ls")
  if not status_null_ls_ok then
    return
  end

  local status_mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
  if not status_mason_null_ls_ok then
    return
  end

  local status_lsp_zero_ok, lsp = pcall(require, "lsp-zero")
  if not status_lsp_zero_ok then
    return
  end

  local status_fidget_ok, fidget = pcall(require, "fidget")
  if not status_fidget_ok then
    return
  end

  require("mason.settings").set({ ui = { border = "rounded" } })
  -- neodev.setup({})
  lsp.preset("recommended")
  lsp.ensure_installed({ "solargraph", "sumneko_lua", "tsserver" })
  lsp.setup()

  mason_null_ls.setup({
    ensure_installed = { "erb_lint", "jq", "prettierd", "shellcheck", "standardrb", "stylua", "tsserver", "vale" },
    automatic_installation = true,
    automatic_setup = true,
  })
  mason_null_ls.setup_handlers({})
  fidget.setup({ text = { spinner = "square_corners" } })
end

return M
