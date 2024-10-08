-- Configuation Based on https://github.com/nvim-lua/kickstart.nvim

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set the tab settings
vim.opt.expandtab = true -- Use spaces and not tab characters
vim.opt.tabstop = 4      -- Perfered number of spaces
vim.opt.shiftwidth = 4   -- Should match tabstop

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"
vim.api.nvim_set_keymap('n', 'x', '"ax', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'x', '"ax', { noremap = true, silent = true })

vim.keymap.set('n', 'cr', '"_diwP', { desc = 'Replace the word with the previosly yanked text', silent = true })

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'` and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 7

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Jump up and down by 10 lines
local jump_lines = 10
vim.keymap.set('n', '<A-j>', jump_lines .. 'j', { noremap = true })
vim.keymap.set('n', '<A-k>', jump_lines .. 'k', { noremap = true })

-- <C-N> for a new tab
vim.keymap.set("n", "<C-N>", ":tabnew<CR>", { desc = "New Tab" })

-- Comment/Uncomment keymapping
local comment_chars = {
  cpp = "//",
  java = "//",
  python = "#",
  lua = "--",
  yaml = "#",
}

vim.keymap.set("n", "cb", function()
  local filetype = vim.bo.filetype
  local comment_char = comment_chars[filetype]

  if comment_char then
    local line = vim.api.nvim_get_current_line()
    local new_line

    -- COMMENT DETECTED
    if string.sub(line, 1, #comment_char) == comment_char then
      if string.sub(line, #comment_char + 1, #comment_char + #comment_char) == string.rep(" ", #comment_char) then
        new_line = string.rep(" ", #comment_char) .. string.sub(line, #comment_char + 1)
      else
        new_line = string.sub(line, #comment_char + 1)
      end

    -- NO COMMENT DETECTED
    else
      if string.sub(line, 1, #comment_char) == string.rep(" ", #comment_char) then
        new_line = comment_char .. string.sub(line, #comment_char + 1)
      else
        new_line = comment_char .. line
      end
    end

    vim.api.nvim_set_current_line(new_line)
  else
    vim.api.nvim_err_writeln("Comment characters not defined for this filetype")
  end
end, { noremap = true, desc = "Comment/Uncomment Line" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

local diagnostics_active = true
vim.keymap.set('n', '<leader>tt', function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end, { desc = 'Toggle diagnostics' })


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
