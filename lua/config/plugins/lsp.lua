local M = {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- LSP Support
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

    -- Snippets
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    "krmbzds/friendly-snippets",

    -- Miscellaneous
    { "j-hui/fidget.nvim" },
  },
}

function M.config()
  -- Setup Mason
  require("mason").setup({
    ui = {
      border = "rounded",
    },
  })

  -- Setup Mason LSP Config
  require("mason-lspconfig").setup({
    ensure_installed = { "solargraph", "lua_ls", "ts_ls" },
    handlers = {
      -- Default handler for all servers
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(client, bufnr)
            -- Prevent multiple attachments
            if vim.b.lsp_attached then
              return
            end
            vim.b.lsp_attached = true

            -- Setup neodev for lua_ls
            if client.name == "lua_ls" then
              require("neodev").setup({})
            end

            -- Setup navic for breadcrumbs
            local navic_ok, navic = pcall(require, "nvim-navic")
            if navic_ok and client.server_capabilities.documentSymbolProvider then
              navic.attach(client, bufnr)
            end
          end,
        })
      end,
      -- Custom handler for lua_ls
      ["lua_ls"] = function()
        local lua_ls_opts = require("config.lsp.lua_ls")
        require("lspconfig").lua_ls.setup({
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = lua_ls_opts.settings,
          on_attach = function(client, bufnr)
            -- Prevent multiple attachments
            if vim.b.lsp_attached then
              return
            end
            vim.b.lsp_attached = true

            -- Setup neodev
            require("neodev").setup({})

            -- Setup navic for breadcrumbs
            local navic_ok, navic = pcall(require, "nvim-navic")
            if navic_ok and client.server_capabilities.documentSymbolProvider then
              navic.attach(client, bufnr)
            end
          end,
        })
      end,
      -- Custom handler for solargraph
      ["solargraph"] = function()
        local solargraph_opts = require("config.lsp.solargraph")
        require("lspconfig").solargraph.setup({
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          cmd = solargraph_opts.cmd,
          filetypes = solargraph_opts.filetypes,
          init_options = solargraph_opts.init_options,
          root_dir = solargraph_opts.root_dir,
          settings = solargraph_opts.settings,
          on_attach = function(client, bufnr)
            -- Prevent multiple attachments
            if vim.b.lsp_attached then
              return
            end
            vim.b.lsp_attached = true

            -- Setup navic for breadcrumbs
            local navic_ok, navic = pcall(require, "nvim-navic")
            if navic_ok and client.server_capabilities.documentSymbolProvider then
              navic.attach(client, bufnr)
            end
          end,
        })
      end,
    },
  })

  -- Setup diagnostics
  local icons = require("config.icons").diagnostics
  vim.diagnostic.config({
    signs = {
      severity = { min = vim.diagnostic.severity.WARN },
      text = {
        [vim.diagnostic.severity.ERROR] = icons.Error,
        [vim.diagnostic.severity.WARN] = icons.Warning,
        [vim.diagnostic.severity.HINT] = icons.Hint,
        [vim.diagnostic.severity.INFO] = icons.Information,
      },
    },
    underline = false,
    update_in_insert = false,
    virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
    float = {
      border = "rounded",
    },
  })

  -- Setup LSP keymaps
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      local opts = { buffer = ev.buf }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end,
  })

  -- Setup completion
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    return
  end

  local snip_status_ok, luasnip = pcall(require, "luasnip")
  if not snip_status_ok then
    return
  end

  local tabout_status_ok, tabout = pcall(require, "tabout")
  if not tabout_status_ok then
    return
  end

  local buffer_fts = {
    "markdown",
    "toml",
    "yaml",
    "json",
  }

  local function contains(t, value)
    for _, v in pairs(t) do
      if v == value then
        return true
      end
    end
    return false
  end

  local compare = require("cmp.config.compare")

  require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets/" })
  require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets
  luasnip.filetype_extend("ruby", { "rails" })

  local check_backspace = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  vim.g.cmp_active = true

  luasnip.config.setup({
    updateevents = "TextChanged,TextChangedI", -- dynamic snippets update as you type
  })

  cmp.setup({
    enabled = function()
      local buftype = vim.api.nvim_buf_get_option(0, "buftype")
      if buftype == "prompt" then
        return false
      end
      return vim.g.cmp_active
    end,
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({}), { "i", "c" }),
      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({}), { "i", "c" }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
      ["<m-o>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
      ["<C-u>"] = function()
        if luasnip.choice_active() then
          require("luasnip.extras.select_choice")()
        end
      end,
      ["<C-c>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<m-j>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<m-k>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<m-c>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<S-CR>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
      ["<Right>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if luasnip.expandable() then
          luasnip.expand({})
        elseif cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif luasnip.jumpable(1) then
          luasnip.jump(1)
        elseif vim.api.nvim_get_mode().mode == "i" then
          tabout.tabout()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    }),
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.menu = ({
          luasnip = "",
          nvim_lsp = "",
          nvim_lua = "",
          buffer = "",
          path = "",
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = {
      {
        name = "nvim_lsp",
        filter = function(entry, _)
          local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
          if kind == "Text" then
            return true
          end
        end,
        group_index = 2,
      },
      { name = "nvim_lua", group_index = 2 },
      { name = "luasnip", group_index = 2 },
      {
        name = "buffer",
        group_index = 2,
        filter = function(_, ctx)
          if not contains(buffer_fts, ctx.prev_context.filetype) then
            return true
          end
        end,
      },
      { name = "path", group_index = 2 },
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        compare.offset,
        compare.exact,
        compare.score,
        compare.recently_used,
        compare.locality,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      documentation = {
        border = "rounded",
        winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      },
      completion = {
        border = "rounded",
        winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      },
    },
    experimental = {
      ghost_text = { hl_group = "NonText" },
    },
  })

  cmp.setup.cmdline(":", {
    sources = {
      { name = "cmdline" },
    },
  })

  cmp.setup.cmdline({ "/", "?", "@" }, {
    sources = {
      { name = "buffer" },
    },
  })

  -- Setup fidget with vim.notify override
  require("fidget").setup({
    notification = {
      override_vim_notify = true, -- Route vim.notify() to fidget.nvim
      window = {
        winblend = 0, -- Make notifications slightly transparent
        border = "rounded", -- Use rounded borders for notifications
        x_padding = 1,
        y_padding = 1,
        max_width = 0.6, -- 60% of editor width
        max_height = 10,
      },
      view = {
        stack_upwards = true,
        icon_separator = " ",
        group_separator = "",
        group_separator_hl = "",
      },
    },
    progress = {
      display = {
        render_limit = 5,
        done_ttl = 2,
        done_icon = "✔",
        done_style = "Constant",
        progress_ttl = math.huge,
        progress_icon = { "dots" },
        progress_style = "WarningMsg",
        group_style = "Title",
        icon_style = "Question",
      },
    },
  })
end

return M
