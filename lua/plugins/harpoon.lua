return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        -- Required setup call
        harpoon:setup()

        -- Basic keymaps
        vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: Add to list" })
        vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle quick menu" })

        -- Select marks (using <leader>1 to <leader>4 to avoid conflicts)
        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: Select mark 1" })
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: Select mark 2" })
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: Select mark 3" })
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: Select mark 4" })

        -- Navigate previous and next marks
        vim.keymap.set("n", "<leader>[", function() harpoon:list():prev() end, { desc = "Harpoon: Previous mark" })
        vim.keymap.set("n", "<leader>]", function() harpoon:list():next() end, { desc = "Harpoon: Next mark" })
    end,
}
