return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        ft = { "lua", "json", "jsonc", "xml", "xaml", "yaml", "yml" },
        config = function()
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
            })
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "jsonls", "lemminx", "yamlls" },
            })
        end,
    },
}
