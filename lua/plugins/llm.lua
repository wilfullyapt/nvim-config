return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- Optional
    {
      "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
      opts = {},
    },
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        anthropic = require("codecompanion.adapters").use("anthropic", {
          schema = {
            model = {
              default = "claude-3-sonnet-20240229",
            },
          },
          env = {
            api_key = "ANTHROPIC_API_KEY"
          },
        }),
      },
      strategies = {
        chat = "anthropic",
        inline = "anthropic",
        agent = "anthropic"
      },
    })
  end,

}
