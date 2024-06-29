
return {
  "frankroeder/parrot.nvim",
  enabled = false,
  dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
  config = function()
    require("parrot").setup {
      providers = {
        anthropic = {
          api_key = require("utils").load_secret("ANTHROPIC_API_KEY")
        },
      },
    }
    vim.api.nvim_set_keymap("n", "<leader>xn", ":PrtChatNew<CR>", { noremap = true, silent = true, desc = "Open a new Chat interface"})
    vim.api.nvim_set_keymap("n", "<leader>xt", ":PrtChatToggle<CR>", { noremap = true, silent = true, desc = "Toggle the Chat interface's visability"})
    vim.api.nvim_set_keymap("n", "<leader>xc", ":PrtChatRespond<CR>", { noremap = true, silent = true, desc = "Execute the Chat"})
    vim.api.nvim_set_keymap("n", "<leader>xd", ":PrtChatDelete<CR>", { noremap = true, silent = true, desc = "Delete the current Chat"})
    vim.api.nvim_set_keymap("n", "<leader>xs", ":PrtStop<CR>", { noremap = true, silent = true, desc = "Stop the current Chat"})
    vim.api.nvim_set_keymap("n", "<leader>xx", "v:PrtImplement<CR>", { noremap = true, silent = true, desc = "Execute using the current line as the prompt"})
  end
}
