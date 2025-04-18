return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/neodev.nvim', opts = {} },
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
    {'WhoIsSethDaniel/mason-tool-installer.nvim'},
  },

  config = function()

    vim.api.nvim_create_autocmd('LspAttach', {

      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)

       local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

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

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    require('mason').setup({})
    require('mason-tool-installer').setup({
            ensure_installed = {
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

    require('mason-lspconfig').setup({
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,
      }
    })

    local cmp = require('cmp')

    cmp.setup({
      sources = {
        {name = 'nvim_lsp'},
        {name = 'buffer'},
      },
      snippet = {
        expand = function(args)
          -- You need Neovim v0.10 to use vim.snippet
          vim.snippet.expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({}),
    })
  end,
}
