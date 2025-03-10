local on_attach = function(_, buff)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = buff, desc = desc })
    end

    nmap("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
    nmap("<leader>ca", function()
        vim.lsp.buf.code_action { context = { only = { "quickfix", "refactor", "source" } } }
    end, "Code Action")
    nmap("<leader>cf", vim.lsp.buf.format, "Format Code")
    nmap("<leader>cgd", vim.lsp.buf.definition, "Go to Definition")
    nmap("<leader>cgi", vim.lsp.buf.implementation, "Go to Implementation")
    nmap("<leader>cgr", vim.lsp.buf.references, "Go to References")
    nmap("<leader>cD", vim.lsp.buf.document_symbol, "Show symbol documentation")
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true }
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "jsonls", "lemminx", "yamlls", "omnisharp" }
            })

            require("mason-lspconfig").setup_handlers {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach
                    })
                end,

                ["omnisharp"] = function()
                    require("lspconfig").omnisharp.setup({
                        cmd = { "dotnet", vim.fn.stdpath "data" .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
                        enable_import_completion = true,
                        organize_imports_on_format = true,
                        enable_roslyn_analyzers = true,
                        root_dir = function()
                            return vim.loop.cwd() -- current working directory
                        end,
                        on_attach = on_attach
                    })
                end
            }
        end
    }
}
