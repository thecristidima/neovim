return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        require("lualine").setup {
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { {
                    "filename",
                    path = 1
                } },
                lualine_x = {},
                lualine_y = {
                    {
                        function()
                            local lsps = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })
                            local icon = require("nvim-web-devicons").get_icon_by_filetype(
                                vim.api.nvim_buf_get_option(0, "filetype")
                            )
                            if lsps and #lsps > 0 then
                                local names = {}
                                for _, lsp in ipairs(lsps) do
                                    table.insert(names, lsp.name)
                                end
                                return string.format("%s %s", table.concat(names, ", "), icon)
                            else
                                return icon or ""
                            end
                        end,
                        on_click = function()
                            vim.api.nvim_command("LspInfo")
                        end,
                        color = function()
                            local _, color = require("nvim-web-devicons").get_icon_cterm_color_by_filetype(
                                vim.api.nvim_buf_get_option(0, "filetype")
                            )
                            return { fg = color }
                        end,
                    },
                    "encoding",
                },
                lualine_z = { 'location' }
            }
        }
    end,
}
