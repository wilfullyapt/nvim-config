return {
	-- LSP requirements
	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},


	-- Singlular Add-ons; if the come with config, they get their own file
	{ 'nvim-treesitter/playground' },
	{ 'tpope/vim-fugitive' },

    {
        "lewis6991/gitsigns.nvim",                  -- See `:help gitsigns` to understand what the configuration keys do
        opts = {                                    -- Adds git related signs to the gutter, as well as utilities for managing changes
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },

    {                                               -- Highlight todo, notes, etc in comments
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },

    { "nvim-tree/nvim-web-devicons" }

}
