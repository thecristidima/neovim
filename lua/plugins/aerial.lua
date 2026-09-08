return {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialClose", "AerialNavToggle" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        -- prefer LSP symbols, fall back to treesitter when no server is attached
        backends = { "lsp", "treesitter", "markdown", "man" },
        layout = {
            default_direction = "right",
            min_width = 30,
        },
        attach_mode = "global",
        show_guides = true,
        filter_kind = false, -- show every symbol kind, not just the default subset
    },
    keys = {
        { "<leader>cst", "<cmd>AerialToggle<cr>", desc = "Toggle symbol outline" },
    },
}
