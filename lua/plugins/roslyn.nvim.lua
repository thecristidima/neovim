return {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    opts = {
        -- After the first solution is selected, reuse it instead of repeating
        -- solution discovery for every C# buffer opened from a picker.
        lock_target = true,
        -- Let Roslyn own workspace file watching instead of registering a
        -- large set of Neovim-side LSP file watchers on Windows.
        filewatching = "roslyn",
        silent = true,
    },
    init = function()
        vim.lsp.config("roslyn", {
            settings = {
                ["csharp|background_analysis"] = {
                    dotnet_analyzer_diagnostics_scope = "openFiles",
                    dotnet_compiler_diagnostics_scope = "openFiles",
                },
            },
        })
    end,
    config = function(_, opts)
        require("roslyn").setup(opts)
    end,
}
