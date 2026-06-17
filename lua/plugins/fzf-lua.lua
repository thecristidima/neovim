return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua", -- load on demand, the first time :FzfLua is called
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        winopts = {
            on_create = function()
                local function send(chars)
                    return function()
                        local job_id = vim.b.terminal_job_id
                        if job_id then
                            vim.api.nvim_chan_send(job_id, chars)
                        end
                    end
                end

                vim.keymap.set("t", "<C-Left>", send("\27b"), { buffer = true, silent = true })
                vim.keymap.set("t", "<C-Right>", send("\27[1;2C"), { buffer = true, silent = true })
                vim.keymap.set("t", "<C-BS>", send("\23"), { buffer = true, silent = true })
                vim.keymap.set("t", "<C-h>", send("\23"), { buffer = true, silent = true })
                vim.keymap.set("t", "<C-Del>", send("\27d"), { buffer = true, silent = true })
                vim.keymap.set("t", "<C-Delete>", send("\27d"), { buffer = true, silent = true })
            end,
        },
        keymap = {
            fzf = {
                true,
                ["alt-b"] = "backward-word",
                ["shift-right"] = "forward-word",
                ["alt-d"] = "kill-word",
                ["ctrl-delete"] = "kill-word",
            },
        },
    },
}
