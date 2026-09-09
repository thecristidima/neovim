return {
    "GustavEikaas/easy-dotnet.nvim",
    cmd = "Dotnet",
    -- Patterns rather than `ft`, deliberately: loading this spawns the dotnet
    -- server and Roslyn (~1.3s), and `ft = "xml"` would trigger that on every
    -- XML and XAML file, not just project files.
    event = {
        {
            event = { "BufReadPre", "BufNewFile" },
            pattern = { "*.cs", "*.csproj", "*.sln", "*.slnx", "*.cshtml", "*.razor" },
        },
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
}
