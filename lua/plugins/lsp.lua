return {
  'neovim/nvim-lspconfig',

  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/neodev.nvim', opts = {} },
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
    { 'L3MON4D3/LuaSnip', dependencies = { 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' } },
  },

  config = function()

    vim.api.nvim_create_autocmd('LspAttach', {

      callback = function(event)

       local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local diagnostics_active = true
        map('<leader>td', function()
          diagnostics_active = not diagnostics_active
          if diagnostics_active then
            vim.diagnostic.config({ virtual_text = true, signs = true })
          else
            vim.diagnostic.config({ virtual_text = false, signs = false })
          end
        end, '[T]oggle [D]iagnostics')

        --  LSP keymapping will jump your buffer. To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame; Refactor')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      end,
    })


    -- Capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())


    -- Mason Setup
    require('mason').setup({})
    require('mason-tool-installer').setup({
            ensure_installed = {
              'clangd',         -- c/c++
              'stylua',         -- Lua formatter
              'black',          -- Python formatter
              'flake8',         -- Python linter
              'isort',
              'llm-ls',
              'lua-language-server',
              'mypy',           -- Python type checker
              'pyright',
              'isort',          -- Python import sorter
              'stylua',         -- Used to format Lua code
              'rust-analyzer',
              'typescript-language-server',
            }
        })

    -- Mason-LSPConfig with Custom Settings
    local servers = {
      pyright = { settings = { python = { analysis = { typeCheckingMode = 'basic' } } } },          -- typeCheckingMode = 'strict' or 'basic' or 'off'
      lua_ls = { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } },
    }
    require('mason-lspconfig').setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      }
    })

    -- Completion Setup
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_lua').load({ paths = '~/.config/nvim/lua/snippets/' })
    luasnip.config.setup({})

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sources = {
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'buffer', priority = 840, keyword_length = 2 },
        { name = 'luasnip', priority = 750 },
        { name = 'path', priority = 500 },
      },
      mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<Enter>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-d>'] = cmp.mapping(function()
          if cmp.visible() then
            vim.lsp.buf.hover()
          end
        end, { 'i' }),
        ['<C-s>'] = cmp.mapping(function()
          if cmp.visible() then
            vim.lsp.buf.signature_help()
          end
        end, { 'i' }),
      }),
    })
  end,
}
