return {
    "GustavEikaas/easy-dotnet.nvim",
    cmd = "Dotnet",
    event = {
        "BufReadPre *.cs",
        "BufNewFile *.cs",
        "BufReadPre *.csproj",
        "BufNewFile *.csproj",
        "BufReadPre *.sln",
        "BufNewFile *.sln",
        "BufReadPre *.slnx",
        "BufNewFile *.slnx",
        "BufReadPre *.cshtml",
        "BufNewFile *.cshtml",
        "BufReadPre *.razor",
        "BufNewFile *.razor",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/snacks.nvim",
        "mfussenegger/nvim-dap",
    },
    opts = {
        picker = "snacks",
        test_runner = {
            neotest_integration = true,
        },
    },
    config = function(_, opts)
        require("easy-dotnet").setup(opts)

        vim.schedule(function()
            pcall(function()
                require("easy-dotnet.roslyn.lsp").start()
            end)
        end)
    end,
}
