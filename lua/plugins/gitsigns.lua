return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- Default config: shows added/changed/deleted markers in the sign column
    -- and feeds the diff counter in lualine. No staging/commit keymaps - use
    -- lazygit (<leader>G) for that.
    opts = {},
}
