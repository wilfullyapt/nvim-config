return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "lua", "vim", "vimdoc", "c", "python", "rust", "javascript", "html", "typescript", "css" },
          sync_install = false,
	      auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
          textobjects = {
            move = {
              enable = true,
              set_jumps = true, -- Add to jumplist
              goto_next_start = {
                ["]m"] = "@function.outer", -- Jump to next function/method start
              },
              goto_previous_start = {
                ["[m"] = "@function.outer", -- Jump to previous function/method start
              },
            },
           },
        })
    end
}
