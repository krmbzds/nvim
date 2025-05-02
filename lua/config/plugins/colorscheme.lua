local M = {
  "krmbzds/dracula.nvim",
  lazy = false,
}

local current_theme = "dark"

-- Separate color tables for light and dark mode
local colors_dark = {
  black = "#17161D",
  red = "#FF9580",
  green = "#8AFF80",
  yellow = "#FFFF80",
  purple = "#9580FF",
  pink = "#FF80BF",
  cyan = "#80FFEA",
  white = "#F8F8F2",
  selection = "#454158",
  bright_red = "#FFAA99",
  bright_green = "#A2FF99",
  bright_yellow = "#FFFF99",
  bright_blue = "#AA99FF",
  bright_magenta = "#FF99CC",
  bright_cyan = "#99FFEE",
  bright_white = "#FFFFFF",
  bg = "#22212C",
  fg = "#F8F8F2",
  comment = "#7970A9",
  menu = "#21222C",
  visual = "#3E4452",
  gutter_fg = "#4B5263",
  nontext = "#424450",
}

local colors_light = {
  black = "#17161D", -- No direct match, kept as original
  red = "#CB3A2A", -- Alucard red
  green = "#14710A", -- Alucard green
  yellow = "#846E15", -- Alucard yellow
  purple = "#644AC9", -- Alucard purple
  pink = "#A3144D", -- Alucard pink
  cyan = "#036A96", -- Alucard cyan
  white = "#1F1F1F", -- Alucard foreground (dark text)
  selection = "#CFCFDE", -- Alucard selection/current-line
  bright_red = "#CB3A2A", -- Use red as no bright variant
  bright_green = "#14710A", -- Use green as no bright variant
  bright_yellow = "#846E15", -- Use yellow as no bright variant
  bright_blue = "#336699", -- Alucard alt-blue
  bright_magenta = "#644AC9", -- Use purple as no magenta
  bright_cyan = "#036A96", -- Use cyan as no bright variant
  bright_white = "#F5F5F5", -- Alucard background (light)
  bg = "#F5F5F5", -- Alucard background
  fg = "#1F1F1F", -- Alucard foreground
  comment = "#635D97", -- Alucard comment
  menu = "#E5E5E5", -- Alucard bg2
  visual = "#C5C5C5", -- Alucard bg4
  gutter_fg = "#4F4F4F", -- Alucard fg4
  nontext = "#3F3F3F", -- Alucard fg3
}

-- Detect system appearance (macOS)
function M.get_system_appearance()
  local output = vim.fn.system("defaults read -g AppleInterfaceStyle")
  if vim.v.shell_error == 0 and output:match("Dark") then
    return "dark"
  else
    return "light"
  end
end

-- Apply Dracula theme with specific colors
function M.set_theme(mode)
  current_theme = mode or "dark"
  vim.o.background = current_theme

  local status_ok, dracula = pcall(require, "dracula")
  if not status_ok then
    vim.cmd("colorscheme default")
    return
  end

  local colors = (mode == "light") and colors_light or colors_dark

  dracula.setup({
    colors = colors,
    show_end_of_buffer = true,
    transparent_bg = false,
    lualine_bg_color = colors.selection,
    italic_comment = true,
  })

  vim.cmd("colorscheme dracula")
end

-- Toggle between modes
function M.toggle_theme()
  if vim.o.background == "dark" then
    M.set_theme("light")
  else
    M.set_theme("dark")
  end
end

-- Plugin setup
function M.config()
  local mode = M.get_system_appearance()
  M.set_theme(mode)
end

return M
