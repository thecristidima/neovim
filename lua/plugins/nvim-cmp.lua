-- TODO
--
-- Suggestions should work with LSP, file paths and buffer (e.g. in a txt file)
-- LSP suggestions should include docs

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
    },

    config = function()
        local cmp = require("cmp")
        cmp.setup({
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = {
                -- C-Space doesn't work by default in Windows terminal
                -- So add this in Terminal settings.json under actions
                -- {
                --    "keys": "ctrl+space",
                --    "command": {
                    --    "action": "sendInput",
                    --    "input": "\u001b[32;5u]"
                --    }
                -- }
                -- You might wonder what this does; it fixes it
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Up>"] = cmp.mapping.select_prev_item(),
                ["<Down>"] = cmp.mapping.select_next_item(),
                -- Note: other configs seem to have a more complex setup for Tab
                -- Don't bother with that until this breaks :)
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "buffer" },
            },
        })
    end
}
