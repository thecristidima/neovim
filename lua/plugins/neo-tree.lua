return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false, -- load eagerly at startup so opening the tree is instant
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        filesystem = {
            hijack_netrw_behavior = "disabled",
        },
    },
}
