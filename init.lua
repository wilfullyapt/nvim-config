-- Globals
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- Key Mappings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'File Explorer' })
vim.keymap.set('n', 'cr', '"_diwP', { desc = 'Replace the word with the previosly yanked text', silent = true })

-- Remap to move between window focusing
vim.keymap.set("n", "<leader>a", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<leader>d", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<leader>s", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<leader>w", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Remap "Record Macro" to SHIFT+Q and remap q to jump back one word
vim.keymap.set('n', 'Q', 'q', { noremap = true, silent = true, desc = "Record Macro" }) -- Preserve q for macros
vim.keymap.set('n', 'q', 'b', { noremap = true, silent = true, desc = "Prev word" })


-- Remap to goto last file, switching between file1 and file2 seemlessly
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Toggle between current and alternate file" })


-- Remap to move entire blocks of code in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- Jump up and down 20 lines and keep centered
vim.keymap.set("n", "<A-j>", "20jzz", { desc = "Jump down 20 lines" })
vim.keymap.set("n", "<A-k>", "20kzz", { desc = "Jump up 20 lines" })


-- Copy to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

-- Paste from system clipboard
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>P", [["+P]], { desc = "Paste from system clipboard before cursor" })

-- Comment/Uncomment keymapping
local comment_chars = {
  cpp = "//",
  java = "//",
  javascript = "//",
  typescript = "//",
  python = "#",
  lua = "--",
  yaml = "#",
}
vim.keymap.set("n", "cz", function()
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


-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- Options
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME" .. "/.vim/undodir")
vim.opt.undofile = false

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"

vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- Setup lazy.nvim
require("lazy").setup('plugins')


-- Post Lazy Key Mapping
require("keymaps")

-- Post Lazy Color Setup
--require("colors")
