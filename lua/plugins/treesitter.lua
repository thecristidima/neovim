local function is_large_file(_, buf)
    local max_filesize = 100 * 1024 -- 100 KiB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

    return ok and stats and stats.size > max_filesize
end

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    main = "nvim-treesitter.configs",
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
            disable = is_large_file,
        },
        indent = {
            enable = true,
            disable = is_large_file,
        },

        additional_vim_regex_highlighting = false,
    },
}
