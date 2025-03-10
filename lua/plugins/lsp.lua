return {
    -- TODO We need nvim-lspconfig and mason
    -- We might need mason-lspconfig in the future, but for now we just want LSP in C# and maybe json and yaml
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim"
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "jsonls", "lemminx", "yamlls", "omnisharp" }
            })

            require("mason-lspconfig").setup_handlers {
                function (server_name)
                    require("lspconfig")[server_name].setup {}
                end,

                -- In case you want a special config for a certain server
                -- ["csharp_ls"] = function()
                    -- require("csharp_ls").setup {}
                -- end
                ["omnisharp"] = function()
                    require("lspconfig").omnisharp.setup({
                        cmd = { "dotnet", vim.fn.stdpath "data" .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
                        enable_import_completion = true,
                        organize_imports_on_format = true,
                        enable_roslyn_analyzers = true,
                        root_dir = function()
                            return vim.loop.cwd() -- current working directory
                        end
                    })
                end
            }
        end
    }
}
