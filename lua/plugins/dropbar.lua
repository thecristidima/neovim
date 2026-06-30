return {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Dropbar",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    config = function(_, opts)
        require("dropbar").setup(opts)

        vim.api.nvim_create_user_command("Dropbar", function()
            require("dropbar.api").pick()
        end, { desc = "Pick symbols in winbar" })
    end,
}
