-- Telescope Remaps


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>tf', builtin.find_files, { desc = '[T]elescope find fi[l]es' })
vim.keymap.set('n', '<leader>tt', builtin.git_files, { desc = '[T]elescope gi[t] files' })
vim.keymap.set('n', '<leader>tg', builtin.live_grep, { desc = '[T]elescope live [g]rep' })
--vim.keymap.set('n', '<leader>ts', builtin.grep_string({search=vim.fn.input("Grep > ")}), { desc = '[T]elescope grep [s]tring' } )


-- Harpoon Key Maps
local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: Add to list" })
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle quick menu" })
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: Select mark 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: Select mark 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: Select mark 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: Select mark 4" })
vim.keymap.set("n", "<leader>[", function() harpoon:list():prev() end, { desc = "Harpoon: Previous mark" })
vim.keymap.set("n", "<leader>]", function() harpoon:list():next() end, { desc = "Harpoon: Next mark" })


-- UndoTree Remap
vim.keymap.set('n', '<leader>q', vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })

