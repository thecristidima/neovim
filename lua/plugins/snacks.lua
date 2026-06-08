return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        indent = { enabled = true },
        scroll = { enabled = true },
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
