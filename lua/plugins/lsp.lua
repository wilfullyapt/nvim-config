return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/neodev.nvim', opts = {} },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip', dependencies = { 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' } },
    { 'folke/which-key.nvim', opts = {} }, -- Optional: for keybinding discoverability
  },
  config = function()
    -- Setup LSP capabilities for completion
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Keybindings on LSP attach
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Toggle diagnostics
        local diagnostics_active = true
        map('<leader>td', function()
          diagnostics_active = not diagnostics_active
          vim.diagnostic.config({
            virtual_text = diagnostics_active,
            signs = diagnostics_active,
          })
        end, '[T]oggle [D]iagnostics')

        -- Optimized LSP keybindings
        -- Goto actions under <leader>g
        map('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('<leader>gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        map('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Symbol navigation
        map('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]ymbols [D]ocument')
        map('<leader>sw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]ymbols [W]orkspace')

        -- Refactoring and code actions
        map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<leader>cf', function()
          vim.lsp.buf.format({ async = true })
        end, '[C]ode [F]ormat')

        -- Diagnostics
        map('<leader>dd', vim.diagnostic.open_float, '[D]iagnostic [D]etails')
        map('<leader>dn', vim.diagnostic.goto_next, '[D]iagnostic [N]ext')
        map('<leader>dp', vim.diagnostic.goto_prev, '[D]iagnostic [P]revious')
        map('<leader>dl', require('telescope.builtin').diagnostics, '[D]iagnostic [L]ist')

        -- Hover and signature help
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

        -- Inlay hints (Neovim 0.10+)
        if vim.lsp.inlay_hint then
          map('<leader>th', function()
            local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
            vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end

        -- Register with which-key for discoverability
        require('which-key').add({
          { '<leader>c', group = 'Code', buffer = event.buf },
          { '<leader>dg', group = 'Diagnostics', buffer = event.buf },
          { '<leader>g', group = 'Goto', buffer = event.buf },
          { '<leader>sy', group = 'Symbols', buffer = event.buf },
          { '<leader>t', group = 'Toggle', buffer = event.buf },
        })

      end,
    })

    -- Mason setup
    require('mason').setup({
      ui = {
        border = 'rounded',
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    })

    -- Mason-tool-installer (using Mason package names)
    require('mason-tool-installer').setup({
      ensure_installed = {
        'clangd',                    -- C/C++
        'lua-language-server',       -- Lua
        'stylua',                    -- Lua formatter
        'pyright',                   -- Python
        'black',                     -- Python formatter
        'flake8',                    -- Python linter
        'mypy',                      -- Python type checker
        'isort',                     -- Python import sorter
        'rust-analyzer',             -- Rust
        'typescript-language-server', -- JavaScript/TypeScript
        'llm-ls',                    -- LLM (if needed)
      },
    })

    -- Mason-lspconfig setup (using lspconfig server names)
    local lspconfig = require('lspconfig')
    require('mason-lspconfig').setup({
      ensure_installed = {
        'clangd',
        'lua_ls',
        'pyright',
        'rust_analyzer',
        'ts_ls', -- Corrected to lspconfig server name
      },
      automatic_installation = true,
      automatic_enable = false, -- Disable to avoid inlay hints error
    })

    -- Server-specific configurations (using lspconfig server names)
    local servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = 'basic', -- 'off', 'basic', or 'strict'
            },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      },
      clangd = {},
      rust_analyzer = {
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = { command = 'clippy' },
            cargo = { allFeatures = true },
            procMacro = { enable = true },
          },
        },
      },
      ts_ls = { -- Corrected to lspconfig server name
        init_options = {
          preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
      },
    }

    -- Setup each server
    for server_name, config in pairs(servers) do
      config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
      config.on_attach = function(client, bufnr)
        -- Disable formatting for certain servers to avoid conflicts
        if server_name == 'ts_ls' or server_name == 'clangd' then
          client.server_capabilities.documentFormattingProvider = false
        end
        -- Ensure inlay hints are off by default
        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end
      end
      lspconfig[server_name].setup(config)
    end

    -- Completion setup (unchanged)
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

    -- Diagnostic UI
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
      float = { border = 'rounded', source = 'always' },
    })
  end,
}
