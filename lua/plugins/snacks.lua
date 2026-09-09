return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        indent = { enabled = true },
        quickfile = { enabled = false },
        scroll = { enabled = true },
        -- Native Lua picker - handles files, grep, buffers, symbols and
        -- vim.ui.select. Matching all 56k files in the Studio repo measures
        -- 6-16ms, against ~155ms just to spawn the fzf process on Windows.
        picker = { enabled = true },
        -- Highlight other uses of the symbol under the cursor; jump with ]] / [[
        words = { enabled = true },
        terminal = {
            -- Open the terminal as a centered floating popup instead of the
            -- default bottom split
            win = {
                position = "float",
                height = 0.85,
                width = 0.85,
                border = "rounded",
            },
        },
    }
}
