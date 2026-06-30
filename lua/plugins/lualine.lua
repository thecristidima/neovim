return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        local devicons = require("nvim-web-devicons")

        local function git_branch()
            return vim.b.gitsigns_head or ""
        end

        local function git_diff()
            local status = vim.b.gitsigns_status_dict

            if not status then
                return nil
            end

            return {
                added = status.added,
                modified = status.changed,
                removed = status.removed,
            }
        end

        require("lualine").setup {
            options = {
                theme = "gruvbox-material",
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    git_branch,
                    { "diff", source = git_diff },
                    "diagnostics",
                },
                lualine_c = { {
                    "filename",
                    path = 1
                } },
                lualine_x = {},
                lualine_y = {
                    {
                        function()
                            local lsps = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })
                            local icon = devicons.get_icon_by_filetype(vim.bo.filetype)
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
                            local _, color = devicons.get_icon_color_by_filetype(vim.bo.filetype)
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
