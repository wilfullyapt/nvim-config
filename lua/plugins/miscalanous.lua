return {

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

    { "nvim-tree/nvim-web-devicons" },

    {
      'echasnovski/mini.icons',                     -- Icons
      opts = {
        style = 'glyph',                            -- 'glyph uses NerdFonts | 'ascii' if your terminal/font lacks icon support
      },
      config = function(_, opts)
        require('mini.icons').setup(opts)
        -- Optional: Mock nvim-web-devicons for compatibility with other plugins
--      require('mini.icons').mock_nvim_web_devicons()
      end,
    }

}
