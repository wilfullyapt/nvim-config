return {
  "mbbill/undotree",
  config = function()
    -- Optional undotree settings
    vim.g.undotree_SetFocusWhenToggle = 1

    -- Persistent undo setup
    if vim.fn.has("persistent_undo") == 1 then
      local target_path = vim.fn.expand('~/.undodir') -- Ensure proper expansion
      -- Verify and create the directory if it doesn't exist
      if vim.fn.isdirectory(target_path) == 0 then
        vim.fn.mkdir(target_path, 'p', 0700)
      end
      -- Set undodir as a comma-separated list (Neovim expects this)
      vim.opt.undodir = target_path
      -- Clear any existing undodir defaults to avoid conflicts
      vim.opt.undodir:prepend(target_path)
      -- Enable undofile
      vim.opt.undofile = true
    end
  end,
}
