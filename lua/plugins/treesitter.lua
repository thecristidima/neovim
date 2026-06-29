return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs", -- send opts to the setup() that actually reads them
    opts = {
        ensure_installed = {
            "c_sharp",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "regex",
            "xml",
            "yaml",
        },
        auto_install = false,
        sync_install = false,

        highlight = {
            enable = true,
        },
        indent = { enable = true },

        additional_vim_regex_highlighting = false,

        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KiB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end
    },
}
