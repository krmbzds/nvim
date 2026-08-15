local M = {
  "OXY2DEV/markview.nvim",
  lazy = true,
  ft = { "markdown", "asciidoc", "quarto", "rmd", "typst" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}

function M.config()
  local status_ok, markview = pcall(require, "markview")
  if not status_ok then
    vim.notify("markview failed to load: " .. tostring(markview), vim.log.levels.ERROR)
    return
  end

  markview.setup({
    preview = {
      filetypes = { "markdown", "quarto", "rmd", "typst", "asciidoc" },
    },
  })

  -- Dracula-pro theming: override markview's base palette + headings so the
  -- rendered Markdown/AsciiDoc preview matches colorscheme.lua. Re-applied on
  -- every :colorscheme reload and run once immediately (no reload required).
  local function apply_highlights()
    -- Base palette slots — accent-only override; the MarkviewPalette{n}Bg
    -- variants keep markview's computed background.
    vim.api.nvim_set_hl(0, "MarkviewPalette0", { fg = "#17161D" }) -- black
    vim.api.nvim_set_hl(0, "MarkviewPalette1", { fg = "#FF9580" }) -- red
    vim.api.nvim_set_hl(0, "MarkviewPalette2", { fg = "#8AFF80" }) -- green
    vim.api.nvim_set_hl(0, "MarkviewPalette3", { fg = "#FFFF80" }) -- yellow
    vim.api.nvim_set_hl(0, "MarkviewPalette4", { fg = "#9580FF" }) -- purple
    vim.api.nvim_set_hl(0, "MarkviewPalette5", { fg = "#FF80BF" }) -- pink
    vim.api.nvim_set_hl(0, "MarkviewPalette6", { fg = "#80FFEA" }) -- cyan
    vim.api.nvim_set_hl(0, "MarkviewPalette7", { fg = "#F8F8F2" }) -- white

    -- Headings: all six levels share dracula purple + bold (no rainbow).
    vim.api.nvim_set_hl(0, "MarkviewHeading1", { fg = "#9580FF", bold = true })
    vim.api.nvim_set_hl(0, "MarkviewHeading2", { fg = "#9580FF", bold = true })
    vim.api.nvim_set_hl(0, "MarkviewHeading3", { fg = "#9580FF", bold = true })
    vim.api.nvim_set_hl(0, "MarkviewHeading4", { fg = "#9580FF", bold = true })
    vim.api.nvim_set_hl(0, "MarkviewHeading5", { fg = "#9580FF", bold = true })
    vim.api.nvim_set_hl(0, "MarkviewHeading6", { fg = "#9580FF", bold = true })

    -- Inline code: green, distinct from body text. markview's default
    -- carries a computed background — preserve it when present.
    local cur = vim.api.nvim_get_hl(0, { name = "MarkviewInlineCode", link = false })
    if cur.bg then
      vim.api.nvim_set_hl(0, "MarkviewInlineCode", { bg = cur.bg, fg = "#8AFF80" })
    else
      vim.api.nvim_set_hl(0, "MarkviewInlineCode", { fg = "#8AFF80" })
    end

    -- Block quotes: cyan.
    vim.api.nvim_set_hl(0, "MarkviewBlockQuoteDefault", { fg = "#80FFEA" })
    vim.api.nvim_set_hl(0, "MarkviewBlockQuoteError", { fg = "#80FFEA" })
    vim.api.nvim_set_hl(0, "MarkviewBlockQuoteNote", { fg = "#80FFEA" })
    vim.api.nvim_set_hl(0, "MarkviewBlockQuoteOk", { fg = "#80FFEA" })
    vim.api.nvim_set_hl(0, "MarkviewBlockQuoteSpecial", { fg = "#80FFEA" })
    vim.api.nvim_set_hl(0, "MarkviewBlockQuoteWarn", { fg = "#80FFEA" })

    -- List markers: pink.
    vim.api.nvim_set_hl(0, "MarkviewListItemMinus", { fg = "#FF80BF" })
    vim.api.nvim_set_hl(0, "MarkviewListItemPlus", { fg = "#FF80BF" })
    vim.api.nvim_set_hl(0, "MarkviewListItemStar", { fg = "#FF80BF" })
  end

  -- Reload safety: re-apply on colorscheme reload, scoped to dracula.
  local group = vim.api.nvim_create_augroup("MarkviewTheme", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "dracula",
    group = group,
    callback = apply_highlights,
  })
  apply_highlights()
end

return M
