return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        indent = { enabled = true },
        quickfile = { enabled = false },
        scroll = { enabled = true },
        -- Native Lua picker - used for the buffer list, since fzf-lua's buffers
        -- picker won't navigate on this setup (fzf-lua still handles files/grep)
        picker = { enabled = true },
        -- Highlight other uses of the symbol under the cursor; jump with ]] / [[
        words = { enabled = true },
        terminal = {
            -- Open the terminal as a centered floating popup (like the fzf-lua finder)
            -- instead of the default bottom split
            win = {
                position = "float",
                height = 0.85,
                width = 0.85,
                border = "rounded",
            },
        },
    }
}
