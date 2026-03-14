return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
        unusedLocalExclude = { "_*", "entry", "vim_item" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
