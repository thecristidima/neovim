vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if vim.bo.modified == true then
            vim.cmd("lua vim.lsp.buf.format()")
        end
    end
})
