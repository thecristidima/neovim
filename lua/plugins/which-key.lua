return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            {
                mode = { "n", "v" },
                -- Define groups and mappings here
                -- Take a look at https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/editor.lua#L49
                { "<leader>f",  group = "file/find" },
                { "<leader>s",  group = "search" },
                { "<leader>q",  group = "quit" },
                { "<leader>c",  group = "code" },
                { "<leader>cg", group = "go to" },
            }
        }
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
