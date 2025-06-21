return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'modern', -- Use modern preset for better UI
    delay = 500, -- Reduce delay for faster popup (adjust as needed)
    win = {
      border = 'rounded', -- Match your LSP float border
      padding = { 1, 2 }, -- Cleaner padding
    },
    notify = true, -- Show notifications for conflicts
    plugins = {
      marks = true,
      registers = true,
      spelling = { enabled = true, suggestions = 20 },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
    -- Register global keymaps (example, adjust as needed)
    wk.add({
      { '<leader>f', group = 'File/Find' }, -- Example for file-related mappings
      { '<leader>b', group = 'Buffer' }, -- Example for buffer-related mappings
    })
  end,
}
