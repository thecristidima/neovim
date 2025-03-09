-- Might be a good idea to install parsers manually at first
-- e.g. :TSInstall markdown, c_sharp

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            auto_install = false,
            sync_install = false,
            highlight = {
                enable = true,
                indent = { enable = true },
            },
            additional_vim_regex_highlighting = false,
            -- Disable treesitter if file size is too big
            -- Will have to play around with this
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KiB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end
        })
    end
}
