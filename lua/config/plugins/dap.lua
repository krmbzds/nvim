local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui" },
    { "suketa/nvim-dap-ruby" },
  },
}

function M.config()
  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    return
  end

  local icons_ok, icons = pcall(require, "config.icons")
  if not icons_ok then
    return
  end

  local install_root_dir = vim.fn.stdpath("data") .. "/mason"
  local extension_path = install_root_dir .. "/packages/codelldb/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"

  -- nvim-dap
  local dap_config = {
    breakpoint = {
      text = icons.debugging.breakpoint,
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    breakpoint_rejected = {
      text = icons.debugging.breakpoint_rejected,
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = icons.debugging.stopped,
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }

  vim.fn.sign_define("DapBreakpoint", dap_config.breakpoint)
  vim.fn.sign_define("DapBreakpointRejected", dap_config.breakpoint_rejected)
  vim.fn.sign_define("DapStopped", dap_config.stopped)

  dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

  dap.adapters.codelldb = {
    type = "server",
    port = "13000",
    executable = {
      command = codelldb_path,
      args = { "--port", "13000" },
    },
  }
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = true,
    },
  }
  dap.configurations.rust = dap.configurations.cpp
end

return M
