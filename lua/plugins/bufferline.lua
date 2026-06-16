return {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            mode = "buffers",
            diagnostics = "nvim_lsp",
            separator_style = "thin",
            always_show_bufferline = true,
            show_close_icon = false,
            show_buffer_close_icons = true,
            close_command = function(bufnr)
                Snacks.bufdelete(bufnr)
            end,
            right_mouse_command = false,
            middle_mouse_command = function(bufnr)
                Snacks.bufdelete(bufnr)
            end,
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "Neo-tree",
                    highlight = "Directory",
                    separator = true,
                },
            },
        },
    },
}
